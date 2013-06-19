//
//  GameScene.m
//  Ball
//
//  Created by panda zheng on 13-6-18.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "HelloWorldLayer.h"


@implementation GameScene

+(CCScene*) scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [GameScene node];
    [scene addChild:layer];
    return scene;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.isTouchEnabled = YES;
        spiderMoveDuration = 3;
        player = [CCSprite spriteWithFile:@"player.png"];
        [self addChild:player z:0 tag:1];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        float ImageHeight = [player texture].contentSize.height;
        player.position = CGPointMake(screenSize.width/2, ImageHeight/2);
        
        [self initSpiders];
    }
    
    return self;
}

-(void) initSpiders
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *tempSpider = [CCSprite spriteWithFile:@"spider.png"];
    float imageWidth = [tempSpider texture].contentSize.width;
    int numSpiders = screenSize.width / imageWidth;
    
    spiders = [[NSMutableArray alloc] initWithCapacity:numSpiders];
    for (int i = 0 ; i < numSpiders ; i++)
    {
        CCSprite *spider = [CCSprite spriteWithFile:@"spider.png"];
        [self addChild:spider z:0 tag:2];
        [spiders addObject:spider];
    }
    [self resetSpiders];
}

- (void) resetSpiders
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCSprite *tempSpider = [CCSprite spriteWithFile:@"spider.png"];
    CGSize size = [tempSpider texture].contentSize;
    
    for (int i = 0 ; i < [spiders count] ; i++)
    {
        CCSprite *spider = [spiders objectAtIndex:i];
        spider.position = CGPointMake(size.width*i + size.width * 0.5f, screenSize.height + 26);
        NSLog(@"%f,%f",spider.position.x,spider.position.y);
        [spider stopAllActions];
    }
    [self schedule:@selector(spidersUpdate:) interval:0.7f];
}

- (void) spidersUpdate: (ccTime) delta
{
    for (int i = 0 ; i < 10 ; i++)
    {
        int randomSpiderIndex = arc4random() % [ spiders count];
        CCSprite *spider = [spiders objectAtIndex:randomSpiderIndex];
        if ([spider numberOfRunningActions] == 0)
        {
            [self runSpiderMoveSequence:spider];
        }
    }
    [self checkForCollision];
}

- (void) runSpiderMoveSequence:(CCSprite *)spider
{
    numSpidersMoved++;
    if (numSpidersMoved % 8 == 0 && spiderMoveDuration > 0.6f)
    {
        spiderMoveDuration -= 0.15f;
    }
    
    CGPoint belowScreenPosition = CGPointMake(spider.position.x, -27);
    CCMoveTo *move = [CCMoveTo actionWithDuration:spiderMoveDuration position:belowScreenPosition];
    CCCallFuncN *call = [CCCallFuncN actionWithTarget:self selector:@selector(spiderBelowScreen:)];
    CCSequence *sequence = [CCSequence actions:move,call, nil];
    [spider runAction:sequence];
}

- (void) spiderBelowScreen: (id) sender
{
    //确保传进来的sender参数是我们需要的类
    NSAssert([sender isKindOfClass:[CCSprite class]],@"sender is not a CCSprite!");
    CCSprite *spider = (CCSprite*) sender;
    
    CGPoint pos = spider.position;
    pos.y += 10;
    spider.position = pos;
    if (pos.y < -16)
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        spider.position = CGPointMake(pos.x, screenSize.height + 26);
    }
    NSLog(@"移动中......%f,%f",spider.position.x,spider.position.y);
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    playerVelocity = [touch locationInView:[touch view]];
    [self checkForCollision];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self checkForCollision];
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint nowPoint = [touch locationInView:[touch view]];
    player.position = CGPointMake(player.position.x + nowPoint.x - playerVelocity.x,
                                  player.position.y - nowPoint.y + playerVelocity.y);
    playerVelocity = nowPoint;
    [self checkForCollision];
}

- (void) checkForCollision
{
    float playerImageSize = 50;
    float spiderImageSize = 50;
    float playerCollisionRadius = playerImageSize * 0.4f;
    float spiderCollisionRadius = spiderImageSize * 0.4f;
    float maxCollisionDistance = playerCollisionRadius + spiderCollisionRadius;
    int numSpiders = [spiders count];
    
    for (int i = 0 ; i < numSpiders ; i++)
    {
        CCSprite *spider = [spiders objectAtIndex:i];
        if ([spider numberOfRunningActions] == 0)
        {
            continue;
        }
        
        float actualDistance = ccpDistance(player.position, spider.position);
        //检查是否两个物体已经碰撞
        if (actualDistance < maxCollisionDistance)
        {
            CCAction *action = [CCBlink actionWithDuration:3 blinks:6];
            [player runAction:action];
            [self unschedule:@selector(spidersUpdate:)];
            gameover = [CCLabelTTF labelWithString:@"GAME OVER" fontName:@"STHeitiJ-Light" fontSize:40];
            gameover.position = ccp(160,380);
            [self addChild:gameover];
            
			[CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
			[CCMenuItemFont setFontSize:26];
			CCMenuItemFont* item1 = [CCMenuItemFont itemWithString:@"->  New Game" target:self selector:@selector(setItem1:)];
			CCMenuItemFont* item2 = [CCMenuItemFont itemWithString:@"->  Back" target:self selector:@selector(setItem2:)];
			
			menu =[CCMenu menuWithItems:item1,item2,nil];
            [menu alignItemsVertically];
			menu.position = CGPointMake(160, 300);
            [self addChild:menu];
            
            CGSize screenSize = [[CCDirector sharedDirector] winSize];
            float ImageHeight = [player texture].contentSize.height;
            player.position = CGPointMake(screenSize.width/2, ImageHeight/2);
            self.isTouchEnabled = NO;
        }
    }
}

- (void) setItem1: (id) sender
{
    self.isTouchEnabled = YES;
    spiderMoveDuration = 3;
    [self removeChild:gameover cleanup:YES];
    [self removeChild:menu cleanup:YES];
    [self schedule:@selector(spidersUpdate:) interval:0.7f];
}

- (void) setItem2: (id) sender
{
    CCTransitionShrinkGrow *shrink = [CCTransitionShrinkGrow transitionWithDuration:1 scene:[HelloWorldLayer scene]];
    [[CCDirector sharedDirector] replaceScene:shrink];
}

- (void) dealloc
{
    [spiders release];
    spiders = nil;
    [super dealloc];
}

@end
