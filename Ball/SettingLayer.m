//
//  SettingLayer.m
//  Ball
//
//  Created by panda zheng on 13-6-18.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "SettingLayer.h"
#import "HelloWorldLayer.h"


@implementation SettingLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [SettingLayer node];
    [scene addChild:layer];
    return scene;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *menuLabel = [CCLabelTTF labelWithString:@"设置" fontName:@"AppleGothic" fontSize:40];
        menuLabel.position = ccp(160,340);
        [self addChild:menuLabel];
        
        //设置CCMenuItemFont
        [CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
        [CCMenuItemFont setFontSize:26];
        CCMenuItemFont *item1 = [CCMenuItemFont itemWithString:@"Go Back!" target:self selector:@selector(goBack:)];
        CCMenu *menu = [CCMenu menuWithItems:item1, nil];
        menu.position = ccp(160,size.height - 200);
        [self addChild:menu];
    }
    
    return self;
}

- (void) goBack: (id) sender
{
    CCTransitionShrinkGrow *shrink = [CCTransitionShrinkGrow transitionWithDuration:1 scene:[HelloWorldLayer scene]];
    [[CCDirector sharedDirector] replaceScene:shrink];
}

@end
