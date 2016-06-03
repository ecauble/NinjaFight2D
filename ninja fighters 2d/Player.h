//
//  Player.h
//  Ninja Fighters 2D
//
//  Created by Scott Bailey on 11/14/13.
//  Copyright (c) 2013 Eric Cauble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : NSObject
{
   
}

@property (nonatomic, strong) CCSprite* player;

@property (nonatomic, strong) CCAction *idleAction;
@property (nonatomic, strong) CCAction *blockAction;
@property (nonatomic, strong) CCAction *walkAction;
@property (nonatomic, strong) CCAction *moveAction;
@property (nonatomic, strong) CCAction *throwingAction;
@property (nonatomic, strong) CCAction *strikingAction;

@property (nonatomic, strong) CCSequence* walkRight;
@property (nonatomic, strong) CCSequence* walkLeft;
@property (nonatomic, strong) CCSequence* jump;
@property (nonatomic, strong) CCSequence* block;


@property (nonatomic) float health;
@property (nonatomic) float stamina;

@property (nonatomic) bool moveInProgress;

+(id) create;
-(void)allowAnotherMove;
@end
