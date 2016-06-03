//
//  Lightning.h
//  lightning test
//
//  Created by Eric Cauble on 11/28/13.
//  Copyright 2013 Eric Cauble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Lightning : CCNode {
    int count;
}
@property (nonatomic, strong) CCSprite *lightningBolt;
@property (nonatomic, strong) CCAction *lightningBoltAction;
+(id)create: (int) player;
-(id) initWithPlayer: (int) player;
@end

