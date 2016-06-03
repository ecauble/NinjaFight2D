//
//  Player.m
//  Ninja Fighters 2D
//
//  Created by Scott Bailey on 11/14/13.
//  Copyright (c) 2013 Eric Cauble. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize player, walkAction, walkRight, walkLeft, health, moveAction,blockAction,block, strikingAction, jump, throwingAction, moveInProgress, stamina;

+(id)create
{
   return [[[self alloc] init] autorelease];
}

-(id) init
{
    if(self = [super init])
    {
        
        
        /*
         * IDLE FRAMES
         */
        
        NSMutableArray *idleFrames = [[NSMutableArray alloc] init];
        for (int i=1; i<5; i++) {
            [idleFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"idle%d.png",i]]];
        }
        
        CCAnimation *idleAnim = [CCAnimation
                                     animationWithSpriteFrames:idleFrames delay:0.3f];
        player = [CCSprite spriteWithSpriteFrameName:@"idle1.png"];
        self.idleAction = [CCRepeatForever actionWithAction:
                               [CCAnimate actionWithAnimation:idleAnim]];
         player = [CCSprite spriteWithSpriteFrameName:@"idle1.png"];
        
        /*
         *  WALKING FRAMES
         */
        NSMutableArray *walkAnimFrames = [[NSMutableArray alloc] init];
        for (int i=1; i<=6; i++)
        {
            NSString*file = [NSString stringWithFormat:@"walking%d.png", i];
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
            [walkAnimFrames addObject:frame];
        }
        CCCallFunc* moveDone = [CCCallFunc actionWithTarget:self selector:@selector(allowAnotherMove)];
        CCAnimation* walkAnimation = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.1];
        CCAnimate* animateWalk = [CCAnimate actionWithAnimation:walkAnimation];
        
        CCMoveBy* moveRight = [CCMoveBy actionWithDuration:1 position:ccp(100, 0)];
        CCSpawn* spawnWalkRight = [CCSpawn actions:animateWalk, moveRight, nil];
        self.walkRight = [CCSequence actions:spawnWalkRight, moveDone, nil];
        
        CCMoveBy* moveLeft = [CCMoveBy actionWithDuration:1 position:ccp(-100, 0)];
        CCSpawn* spawnWalkLeft = [CCSpawn actions:animateWalk, moveLeft, nil];
        self.walkLeft = [CCSequence actions:spawnWalkLeft, moveDone, nil];
        
        /*
         *  JUMPING FRAMES
         */
        
        NSMutableArray* jumpFrames = [[NSMutableArray alloc] init];
        for(int i = 1; i <= 4; i++)
        {
            NSString*file = [NSString stringWithFormat:@"jump%i.png", i];
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
            [jumpFrames addObject:frame];
        }
        
        CCAnimation* jumpAnimation = [CCAnimation animationWithSpriteFrames:jumpFrames delay:0.05];
        CCAnimate* animateJump = [CCAnimate actionWithAnimation:jumpAnimation];
        CCRepeat* repeatAnimation = [CCRepeat actionWithAction:animateJump times:2];
        CCJumpBy*jumpBy = [CCJumpBy actionWithDuration:1 position:ccp(0,0) height:350 jumps:1];
        CCSpawn* spawnJump = [CCSpawn actions:animateJump, repeatAnimation, jumpBy, nil];
        self.jump = [CCSequence actions:spawnJump, moveDone, nil];
        
        /*
         * STRIKING FRAMES
         */
        
        NSMutableArray *strikingFrames = [[NSMutableArray alloc] init];
        for (int i=1; i<=8; i++) {
            [strikingFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"striking%d.png",i]]];
        }
        
        CCAnimation *strikingAnim = [CCAnimation
                                     animationWithSpriteFrames:strikingFrames delay:0.2f];
       
        self.strikingAction = [CCRepeatForever actionWithAction:
                               [CCAnimate actionWithAnimation:strikingAnim]];
        
        
        /*
         * THROWING FRAMEs
         */
        NSMutableArray *throwingFrames = [NSMutableArray array];
        for (int i=1; i<=7; i++) {
            [throwingFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"throwing%d.png",i]]];
        }
        
        CCAnimation* throwAnimation = [CCAnimation animationWithSpriteFrames:throwingFrames delay:0.05f];
        self.throwingAction = self.blockAction = [CCAnimate actionWithAnimation:throwAnimation restoreOriginalFrame:YES];

        
        
        
        /*
         * BLOCKING FRAMES
         */
        
        NSMutableArray *blockingFrames = [[NSMutableArray alloc] init];
        for (int i=1; i<=2; i++) {
            [blockingFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"block%d.png",i]]];
        }
        
        CCAnimation *blockingAnim = [CCAnimation
                                     animationWithSpriteFrames:blockingFrames delay: .15f];
        self.blockAction = [CCAnimate actionWithAnimation:blockingAnim restoreOriginalFrame:YES];

        
        stamina = 100;
        health = 100;
        
    }
    return self;
}

-(void)allowAnotherMove
{
    moveInProgress = NO;
    [player runAction:self.idleAction];
    
}

-(void) dealloc
{
    walkLeft = nil;
    walkRight = nil;
    jump = nil;
    [super dealloc];
}
@end
