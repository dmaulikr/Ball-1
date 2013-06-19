//
//  HelloWorldLayer.m
//  Ball
//
//  Created by panda zheng on 13-6-18.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SettingLayer.h"
#import "GameScene.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CCLabelTTF *menuLabel = [CCLabelTTF labelWithString:@"主菜单" fontName:@"STHeitiJ-Light" fontSize:40];
        menuLabel.position = ccp(160,440);
        [self addChild:menuLabel];
        
        //设置CCMenuItemFont
        [CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
        [CCMenuItemFont setFontSize:26];
        CCMenuItemFont *item1 = [CCMenuItemFont itemWithString:@"-> 开始" target:self selector:@selector(startGame:)];
        CCMenuItemFont *item2 = [CCMenuItemFont itemWithString:@"-> 设置" target:self selector:@selector(setting:)];
        
        CCMenu *menu = [CCMenu menuWithItems:item1,item2, nil];
        menu.position = CGPointMake(160, 300);
        [menu alignItemsVertically];
        
        float delayTime = 0.3f;
        
        for (CCMenuItemFont *each in [menu children])
        {
            each.scaleX = 0.0f;
            each.scaleY = 0.0f;
            CCAction *action = [CCSequence actions:
                                [CCDelayTime actionWithDuration:delayTime],
                                [CCScaleTo actionWithDuration:0.5 scale:1.0], nil];
            delayTime += 0.2f;
            [each runAction:action];
        }
        
        [self addChild:menu];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void) startGame: (id) sender
{
    CCTransitionShrinkGrow *shrink = [CCTransitionShrinkGrow transitionWithDuration:1 scene:[GameScene scene]];
    [[CCDirector sharedDirector] replaceScene:shrink];
}

- (void) setting: (id) sender
{
    CCTransitionShrinkGrow *shrink = [CCTransitionShrinkGrow transitionWithDuration:1 scene:[SettingLayer scene]];
    [[CCDirector sharedDirector] replaceScene:shrink];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
