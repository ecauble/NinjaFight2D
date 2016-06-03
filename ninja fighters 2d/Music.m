//
//  Music.m
//  Ninja Fighters 2D
//
//  Created by Scott Bailey on 11/14/13.
//  Copyright 2013 Eric Cauble. All rights reserved.
//

#import "Music.h"


@implementation Music

+(id)createMusic
{
    return [[[self alloc] init] autorelease];
}

-(id)init
{
    if(self = [super init])
    {
        songIndex = (arc4random() %4) +1;
        song = [NSString stringWithFormat: @"song%d.mp3", songIndex];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic: song loop:YES];
    }
    return self;
}

 
@end
