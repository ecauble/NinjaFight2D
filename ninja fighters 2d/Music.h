//
//  Music.h
//  Ninja Fighters 2D
//
//  Created by Scott Bailey on 11/14/13.
//  Copyright 2013 Eric Cauble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface Music : NSObject
{
    int songIndex;
    NSString* song;
}
+(id)createMusic;

@end
