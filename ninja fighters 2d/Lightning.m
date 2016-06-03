//
//  Lightning.m
//  lightning test
//
//  Created by Eric Cauble on 11/28/13.
//  Copyright 2013 Eric Cauble. All rights reserved.
//

#import "Lightning.h"
#import "SimpleAudioEngine.h"


@implementation Lightning
@synthesize lightningBolt, lightningBoltAction;

+(id)create: (int) player
{
    return [[[self alloc] initWithPlayer: (int) player] autorelease];
}

-(id) initWithPlayer:(int)player
{
    
    if(self = [super init])
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"lightning.plist"];
        
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"lightning.png"];
        [self addChild:spriteSheet];
        
        NSMutableArray *lightningAnimFrames = [NSMutableArray array];
        for (int i=0; i<=5; i++) {
            [lightningAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"lightning%d.png",i]]];
        }
        
        CCAnimation *lightningAnim = [CCAnimation animationWithSpriteFrames:lightningAnimFrames delay:0.1f];
        self.lightningBolt = [CCSprite spriteWithSpriteFrameName:@"lightning0.png"];
        self.lightningBoltAction = [CCAnimate actionWithAnimation: lightningAnim];
        [spriteSheet addChild:self.lightningBolt];
        
        id removeMySprite = [CCCallFuncND actionWithTarget:self.lightningBolt selector:@selector(removeFromParentAndCleanup:) data:(void*)YES];
        //REMOVE AFTER RUNNING
        [self.lightningBolt runAction:
         [CCSequence actions: self.lightningBoltAction, removeMySprite, nil]];
        
        if(player ==1){
            self.lightningBolt.position = ccp(256, winSize.height/2);
            [[SimpleAudioEngine sharedEngine]playEffect:@"thunder1.mp3"];
            
        }
        if(player ==2){
            self.lightningBolt.position = ccp(768, winSize.height/2);
            [[SimpleAudioEngine sharedEngine]playEffect:@"thunder1.mp3"];
        }
    }
    return self;
}



-(void) dealloc
{
    [super dealloc];
}

@end