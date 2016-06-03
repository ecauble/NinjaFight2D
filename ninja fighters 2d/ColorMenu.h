//
//  ColorMenu.h
//  Ninja Fighters 2D
//
//  Created by Eric Cauble on 11/21/13.
//  Copyright 2013 Eric Cauble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ColorMenu : CCLayer {
    CGSize winSize;
    CCMenu *menu;
    CCSprite * ninja1Color;
    CCSprite * ninja2Color;
    CCSprite * backgroundMenu;
    CCSprite * currentItem;
    CCSprite * cblock1;
    CCSprite * cblock2;
    CCSprite * cblock3;
    CCSprite * cblock4;
    CCSprite * cblock5;
    CCSprite * cblock6;
    CCSprite * cblock7;
    CCSprite * cblock8;
    CCSprite * cblock9;
    CCSprite * cblock10;
    CCSprite * cblock11;
    CCSprite * cblock12;
    CCSprite * cblock13;
    CCSprite * cblock14;
    CCSprite * cblock15;
    CCSprite * cblock16;
    CCSprite * readyButton1;
    CCSprite * readyButton2;
    CCSprite * dividerSword;
    int ready1, ready2;
    bool c1set;
    bool c2set;
}
+(CCScene *) scene;

@end
