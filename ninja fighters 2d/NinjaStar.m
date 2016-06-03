//
//  NinjaStar.m
//  Ninja Fighters 2D
//
//  Created by Scott Bailey on 11/19/13.
//  Copyright (c) 2013 Eric Cauble. All rights reserved.
//

#import "NinjaStar.h"

@implementation NinjaStar
@synthesize ninjaStar, spinStar, throwStar;

+(id)create: (int) player andPosition: (int) xCoord
{
    return [[[self alloc] initWithPlayer: (int) player andPosition: (int) xCoord] autorelease];
}

-(id) initWithPlayer:(int)player andPosition: (int) xCoord
{
    if(self = [super init])
    {
        /*
         * NINJA STAR
         */
        ninjaStar = [CCSprite spriteWithFile:@"ninja_star.png"];
        ninjaStar.position = ccp(xCoord, 175);
        
        if(player == 1)
        {
            CCMoveBy * moveStar = [CCMoveBy actionWithDuration:2.2 position:ccp(1000,0)];
            id repeat = [CCRepeat actionWithAction: [CCRotateBy actionWithDuration:1.0f angle: 360] times:3];
            spinStar = [CCSpawn actions: repeat, moveStar,nil];
        }
        else if(player == 2)
        {
            CCMoveBy * moveStar = [CCMoveBy actionWithDuration:2.2 position:ccp(-1000,0)];
            id repeat = [CCRepeat actionWithAction: [CCRotateBy actionWithDuration:1.0f angle:-360] times:3];
            spinStar = [CCSpawn actions: repeat, moveStar,nil];
        }
       

    }
    return self;
}

@end
