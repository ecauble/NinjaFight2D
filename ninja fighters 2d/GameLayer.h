//
//  GameLayer.h
//  Ninja Fighters 2D
//
//  Created by Eric Cauble on 11/9/13.
//  Copyright Eric Cauble 2013. All rights reserved.
//
 

#import "cocos2d.h"
#import "Music.h"
#import "Player.h"
#import "NinjaStar.h"

 @interface GameLayer : CCLayer
{
    int initialTouchX;
    int initialTouchY;
    int middleOfScreen;
    CGSize winSize;
  
    CCSprite* background;
  
    CCSprite* hblock1;
    CCSprite* hblock2;
    
    CCSprite* sblock1;
    CCSprite* sblock2;
    
    CCSprite* testSprite;
    CCSpriteFrame* defaultPose;
    
    CCRepeatForever *walk; //the action we can start and stop whenever
  
    BOOL playerMoving;
    BOOL isGameOver;
    CGPoint startingPositionPlayer1;
    CGPoint startingPositionPlayer2;
    UISwipeGestureRecognizer *swipeDownGR;
    UITapGestureRecognizer* tapToAttack;
    UITapGestureRecognizer* tapToThrowStar;
    UISwipeGestureRecognizer* swipeUp;
    UISwipeGestureRecognizer* swipeLeft;
    UISwipeGestureRecognizer* swipeRight;
    
    Music* music;
    Player* player1;
    Player* player2;

    NSMutableArray* player1Stars;
    NSMutableArray* player2Stars;
    
    int staminaCounter;
    
    //for game timer
    CCLabelTTF *timeLabel;
    CCLabelTTF *fightLabel;

    ccTime totalTime;
    int myTime; 
    int currentTime;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) sceneWithData: (ccColor3B) player1Color player2Color: (ccColor3B)player2Color;

@end
