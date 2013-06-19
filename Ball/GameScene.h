//
//  GameScene.h
//  Ball
//
//  Created by panda zheng on 13-6-18.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCLayer {
    CCSprite *player;
    NSMutableArray *spiders;
    float spiderMoveDuration;
    CGPoint playerVelocity;
    int numSpidersMoved;
    CCMenu *menu;
    CCLabelTTF *gameover;
}


+(CCScene*) scene;
-(void) initSpiders;
-(void) resetSpiders;
-(void) runSpiderMoveSequence: (CCSprite*) spider;
-(void) checkForCollision;

@end
