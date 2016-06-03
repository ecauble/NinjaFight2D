//
//  NinjaStar.h
//  Ninja Fighters 2D
//
//  Created by Scott Bailey on 11/19/13.
//  Copyright (c) 2013 Eric Cauble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NinjaStar : CCNode
{
    
}

@property (nonatomic, strong) CCSprite* ninjaStar;
@property (nonatomic, strong) CCSpawn * spinStar;
@property (nonatomic, strong) CCSequence* throwStar;

+(id)create: (int) player andPosition: (int) xCoord;
-(id) initWithPlayer: (int) player andPosition: (int) xCoord;
@end
