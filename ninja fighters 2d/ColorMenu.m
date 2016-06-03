//
//  ColorMenu.m
//  ninja fighters menu
//
//  Created by Eric Cauble on 11/20/13.
//  Copyright Eric Cauble 2013. All rights reserved.
//


// Import the interfaces
#import "ColorMenu.h"
#import "CCLabelBMFont.h"
#import "GameLayer.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

#pragma mark - ColorMenu

// ColorMenu implementation
@implementation ColorMenu

// Helper class method that creates a Scene with the ColorMenu as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ColorMenu *layer = [ColorMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        winSize = [CCDirector sharedDirector].winSize;
        
        self.isTouchEnabled = YES;
        
        backgroundMenu = [CCSprite spriteWithFile:@"color_menu.png"];
        backgroundMenu.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild: backgroundMenu];
        
        
        cblock1 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock1.position = ccp(144, 558);
        cblock1.color = ccRED;
        [self addChild: cblock1 z: 1 tag: 1];
        
        cblock2 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock2.position = ccp(144, 430);
        cblock2.color = ccYELLOW;
        [self addChild: cblock2 z: 1 tag: 2];
        
        cblock3 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock3.position = ccp(144, 303);
        cblock3.color = ccBLUE;
        [self addChild: cblock3 z: 1 tag: 3];
        
        cblock4 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock4.position = ccp(144, 179);
        cblock4.color = ccGRAY;
        [self addChild: cblock4 z: 1 tag: 4];
        
        cblock5 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock5.position = ccp(387, 558);
        cblock5.color = ccORANGE;
        [self addChild: cblock5 z: 1 tag: 5];
        
        cblock6 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock6.position = ccp(387, 430);
        cblock6.color = ccGREEN;
        [self addChild: cblock6 z: 1 tag: 6];
        
        cblock7 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock7.position = ccp(387, 303);
        cblock7.color = ccMAGENTA;
        [self addChild: cblock7 z: 1 tag: 7];
        
        cblock8 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock8.position = ccp(387, 179);
        cblock8.color = ccWHITE;
        [self addChild: cblock8 z: 1 tag: 8];
        
        cblock9 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock9.position = ccp(632, 558);
        cblock9.color = ccRED;
        [self addChild: cblock9 z: 1 tag: 9];
        
        cblock10 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock10.position = ccp(632, 430);
        cblock10.color = ccYELLOW;
        [self addChild: cblock10 z: 1 tag: 10];
        
        cblock11 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock11.position = ccp(632, 303);
        cblock11.color = ccBLUE;
        [self addChild: cblock11 z: 1 tag: 11];
        
        cblock12 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock12.position = ccp(632, 179);
        cblock12.color = ccGRAY;
        [self addChild: cblock12 z: 1 tag: 12];
        
        cblock13 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock13.position = ccp(878, 558);
        cblock13.color = ccORANGE;
        [self addChild: cblock13 z: 1 tag: 13];
        
        cblock14 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock14.position = ccp(878, 430);
        cblock14.color = ccGREEN;
        [self addChild: cblock14 z: 1 tag: 14];
        
        cblock15 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock15.position = ccp(878, 303);
        cblock15.color = ccMAGENTA;
        [self addChild: cblock15 z: 1 tag: 15];
        
        cblock16 = [CCSprite spriteWithFile:@"menu_block.png"];
        cblock16.position = ccp(878, 179);
        cblock16.color = ccWHITE;
        [self addChild: cblock16 z: 1 tag: 16];
        
        
        readyButton1 = [CCSprite spriteWithFile:@"ready_button.png"];
        readyButton1.position = ccp(350, 700);
        [self addChild: readyButton1];
        
        readyButton2 = [CCSprite spriteWithFile:@"ready_button.png"];
        readyButton2.position = ccp(670, 700);
        [self addChild: readyButton2];
        
        dividerSword = [CCSprite spriteWithFile:@"katana.png"];
        dividerSword.position = ccp(winSize.width/2, 2000);
        [self addChild: dividerSword z:100];
        CCMoveTo * moveSword = [CCMoveTo actionWithDuration:1.5 position:ccp(winSize.width/2, winSize.height/2)];
        
        CCSprite * swordeStone = [CCSprite spriteWithFile:@"sword_stone.png"];
        swordeStone.position = ccp(winSize.width/2, 30);
        [self addChild: swordeStone z:101];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"title_theme.mp3" loop:YES];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"sword.mp3"];
        [dividerSword runAction: moveSword];
        CCSequence* playSwordEffect = [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCCallBlock actionWithBlock:^(void) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"sword.mp3"];
        }], nil];
        [self runAction:playSwordEffect];
        [self addLabel ];
        
	}
	return self;
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
}
-(bool) testCollisionUsingPoint: (CGPoint) thePoint andSprite:(CCSprite*) theSprite {
    if ( thePoint.x > (theSprite.position.x - theSprite.contentSize.width /2 ) &&
        thePoint.x < (theSprite.position.x + theSprite.contentSize.width /2 ) &&
        thePoint.y > (theSprite.position.y - theSprite.contentSize.height /2 ) &&
        thePoint.y < (theSprite.position.y + theSprite.contentSize.height /2 )) {
        
        return YES;
        
    } else {
        return NO;
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    //player1 color selected, set color for next scene,
    //fade block sprites to white
    for(int i = 1; i <= 8; i++)
    {
        if ( [self testCollisionUsingPoint:location andSprite: (CCSprite*)[self  getChildByTag:i ] ]) {
            CCSprite * temp = (CCSprite*)[self getChildByTag:i];
            readyButton1.color = temp.color;
            c1set = YES;
            for(int j = 1; j <= 8; j++)
            {
                CCFadeOut * fadeTiles = [CCFadeOut actionWithDuration:.5];
                [[self getChildByTag:j] runAction:fadeTiles];
            }
        }
        //player2 color selected, set color for next scene,
        //fade block sprites to white
        for(int i = 9; i <= 16; i++)
        {
            if ( [self testCollisionUsingPoint:location andSprite: (CCSprite*)[self  getChildByTag:i ] ]) {
                CCSprite * temp = (CCSprite*)[self getChildByTag:i];
                readyButton2.color = temp.color;
                c2set = YES;
                for(int j = 9; j <= 16; j++)
                {
                    CCFadeOut * fadeTiles = [CCFadeOut actionWithDuration:.5];
                    [[self getChildByTag:j] runAction:fadeTiles];
                }
            }
            
        }
        
    }
    
    if(c1set && c2set){
        CCMoveTo * moveOut = [CCMoveTo actionWithDuration:1.5 position:ccp(winSize.width/2, 2000)];
        CCSprite * leftDoor = [CCSprite spriteWithFile:@"left.png"];
        CCSprite * rightDoor = [CCSprite spriteWithFile:@"right.png"];
        leftDoor.position = ccp(256,winSize.height/2);
        rightDoor.position = ccp(768,winSize.height/2);
        CCMoveTo * move1 = [CCMoveTo actionWithDuration:3.0 position: ccp(-3000,0)];
        CCMoveTo * move2 = [CCMoveTo actionWithDuration:3.0 position: ccp(3000,0)];
        [leftDoor runAction:move1];
        [rightDoor runAction:move2];
        [self addChild:leftDoor];
        [self addChild:rightDoor];
        [self removeChild:backgroundMenu cleanup:YES];
        [dividerSword runAction:moveOut];
        [[SimpleAudioEngine sharedEngine] playEffect:@"sword.mp3"];
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:[GameLayer sceneWithData:readyButton1.color player2Color:readyButton2.color]]];
    }
    
}


-(void) addLabel{
    CCLabelTTF *colorLabel = [CCLabelTTF labelWithString:@"CHOOSE YOUR COLOR" fontName:@"Arial" fontSize:60];
    CGSize size = [[CCDirector sharedDirector] winSize];
    colorLabel.position =  ccp( size.width /2 , 647 );
    colorLabel.color = ccGRAY;
    [self addChild: colorLabel];
    CCFadeOut * fade = [CCFadeOut actionWithDuration:12.0];
    [colorLabel runAction:fade];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
