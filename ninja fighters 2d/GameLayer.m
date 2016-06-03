//
//  GameLayer.m
//  Ninja Fighters 2D
//
//  Created by Eric Cauble on 11/9/13.
//  Copyright Eric Cauble 2013. All rights reserved.
//


#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#import "CCLabelBMFont.h"
#import "AppDelegate.h"
#import "Lightning.h"

#pragma mark - GameLayer

@interface GameLayer ()
{
   
}
@end

// GameLayer implementation
@implementation GameLayer

// Helper class method that creates a Scene with the GameLayer as the only child.
+(CCScene *) sceneWithData:(ccColor3B)player1Color player2Color:(ccColor3B)player2Color
{
    CCScene *scene = [CCScene node];
	GameLayer *layer = [[GameLayer alloc] initWithData:player1Color player2Color:player2Color];
	[scene addChild: layer];
	return scene;
}


// on "init" you need to initialize your instance
-(id) initWithData: (ccColor3B) player1Color player2Color: (ccColor3B)player2Color
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        //screen size
        winSize = [CCDirector sharedDirector].winSize;
        middleOfScreen = winSize.width/2;
        //enable touch events
		self.touchEnabled = YES;
        
        //start background music
        music = [Music createMusic];
        
        //add static background sprite
        [self addBackground];
        
        //set up frame cache
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ninja.plist"];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"ninja.png"];
        [self addChild:spriteSheet];
        
        //Create the 2 players
        player1 = [Player create];
        player2 = [Player create];
        
        startingPositionPlayer1 = ccp(256, 170);
        player1.player.position = startingPositionPlayer1;
        player1.player.color = player1Color;
        [player1.player runAction: player1.idleAction];
        
       [spriteSheet addChild: player1.player];
    
      
        startingPositionPlayer2 = ccp(768, 170);
        player2.player.position = startingPositionPlayer2;
        player2.player.color = player2Color;
        player2.player.flipX = YES;

       
        [spriteSheet addChild: player2.player];
        [player2.player runAction: player2.idleAction];
        
        //setup timer and label
        myTime = 0;
        
        timeLabel = [CCLabelTTF labelWithString:@"00:00" fontName:@"Arial-BoldMT" fontSize:38];
        timeLabel.position = CGPointMake(winSize.width/2, 720);
        timeLabel.anchorPoint = CGPointMake(0.5f, 1.0f);
        timeLabel.color = ccYELLOW;
        [self addChild:timeLabel];
       
        //Create the ninja star arrays.
        player1Stars = [[NSMutableArray array] retain];
        player2Stars = [[NSMutableArray array] retain];
        [self addHealthBar];
        [self addStaminaBar];
        [self addLabels];
        [self addSwipeToMoveGesture];
        [self addSwipeToJumpGesture];
        [self addTapToThrowGesture];
        [self addTapToAttack];
        [self scheduleUpdate];
    }
	return self;
}

-(void) addBackground{
    
    NSString * randomBackGround = [NSString stringWithFormat: @"bg%d.png", ((arc4random()%4) +1)];
    //add static background sprite
    background = [CCSprite spriteWithFile: randomBackGround];
    background.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:background z: -2];
    //add static background sprite
    if([randomBackGround characterAtIndex:2] == '1'){
        CCSprite * grass = [CCSprite spriteWithFile:@"grass.png"];
        grass.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:grass z: 4];
    }
    
}

-(void) addLabels{
    fightLabel = [CCLabelTTF labelWithString:@"FIGHT!" fontName:@"Arial-BoldMT" fontSize:64];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    fightLabel.position =  ccp( size.width /2 , 600 );
    [self addChild: fightLabel];
    CCFadeOut * fade = [CCFadeOut actionWithDuration:3.0];
    [CCMenuItemFont setFontSize:22];
    [fightLabel runAction:fade];
    
    CCLabelTTF *player1Label = [CCLabelTTF labelWithString:@"PLAYER 1" fontName:@"Arial-BoldMT" fontSize:17];
    CCLabelTTF *player2Label = [CCLabelTTF labelWithString:@"PLAYER 2" fontName:@"Arial-BoldMT" fontSize:17];
    
    player1Label.position =  ccp( 250 , 700 );
    [self addChild: player1Label z: 5];
    player2Label.position =  ccp( 750 , 700 );
    [self addChild: player2Label z: 5];
}

-(void) update:(ccTime)delta
{
    //game timer
    totalTime += delta;
    currentTime = (int)totalTime;
    int minutes = myTime/60;
    int seconds = myTime%60;
    
   //update game timer
    if (myTime < currentTime && myTime <61 && !isGameOver){
        myTime = currentTime;
        //update timerLabel and format to "MM:SS"
        [timeLabel setString:[NSString stringWithFormat:@"%02d:%02d", minutes, seconds]];
        //5 seconds left
        if(myTime > 55){
            timeLabel.color = ccRED;
            CCBlink * blinkLabel  =[CCBlink actionWithDuration:5 blinks:10];
            [timeLabel runAction:blinkLabel];
            [[SimpleAudioEngine sharedEngine] playEffect:@"beep.mp3"];
        }
        if(myTime == 61){
            if(player1.health > player2.health){
                [self gameOver:1];
            }
            else if(player1.health < player2.health){
                [self gameOver:2];
            }else{//tie
                [self gameOver:3];
            }
        }
    }
    
    //Player 1
    if(player1.player.position.x < 0)
    {
        [player1.player stopAllActions];
        [player1 allowAnotherMove];
        player1.player.position = ccp(1, startingPositionPlayer1.y);
    }
    else if( player1.player.position.x > winSize.width)
    {
        [player1.player stopAllActions];
        [player1 allowAnotherMove];
        player1.player.position = ccp(startingPositionPlayer1.x, startingPositionPlayer1.y);
    }
    
    //Player 2
    if(player2.player.position.x < 0)
    {
        [player2.player stopAllActions];
        [player2 allowAnotherMove];
        player2.player.position = ccp(-1, startingPositionPlayer2.y);
    }
    else if( player2.player.position.x > winSize.width)
    {
        [player2.player stopAllActions];
        [player2 allowAnotherMove];
        player2.player.position = ccp(startingPositionPlayer2.x, startingPositionPlayer2.y);
    }
    
    if(player1.player.position.x > player2.player.position.x - player2.player.contentSize.width/2)
        player1.player.position = ccp(player1.player.position.x - 5, player1.player.position.y);
    
    if(player2.player.position.x < player1.player.position.x + player1.player.contentSize.width/2)
        player2.player.position = ccp(player2.player.position.x + 5, player2.player.position.y);
    
    if(staminaCounter % 30 == 0)
    {
        if (player1.stamina < 100)
        {
            player1.stamina += 5;
            if(player1.stamina > 100)
                player1.stamina = 100;
            sblock1.scaleX += .30;
            sblock1.position = ccp(165 + (sblock1.contentSize.width)*(sblock1.scaleX)/2, 670);
        }
        
        if (player2.stamina < 100)
        {
            player2.stamina += 5;
            if(player2.stamina > 100)
                player2.stamina = 100;
            sblock2.scaleX += .30;
             sblock2.position = ccp(664 + sblock2.contentSize.width*(sblock2.scaleX)/2, 670);
        }
        
    }
    
    if(staminaCounter == 60)
        staminaCounter = 0;
    
    staminaCounter++;
    
    [self checkForCollisions];
    
}

-(void) addHealthBar  {
    CCSprite * hbframe1 = [CCSprite spriteWithFile:@"healthbar_frame.png"];
    hbframe1.position = ccp(250, 700);
    [self addChild:hbframe1 z:2];
    CCSprite * hbfill1 = [CCSprite spriteWithFile:@"healthbar_fill.png"];
    hbfill1.position = ccp(250, 700);
    [self addChild:hbfill1 z:0];
   
    hblock1 = [CCSprite spriteWithFile:@"block.png"];
    hblock1.position = ccp(250, 700);
    hblock1.scaleX *= 6;
    hblock1.color = ccRED;
    [self addChild: hblock1 z: 1 tag: 1];
    
    CCSprite * hbframe2 = [CCSprite spriteWithFile:@"healthbar_frame.png"];
    hbframe2.position = ccp(750, 700);
    [self addChild:hbframe2 z:2];
    CCSprite * hbfill2 = [CCSprite spriteWithFile:@"healthbar_fill.png"];
    hbfill2.position = ccp(750, 700);
    [self addChild:hbfill2 z:0];
    
    hblock2 = [CCSprite spriteWithFile:@"block.png"];
    hblock2.position = ccp(750, 700);
    hblock2.scaleX *= 6;
    hblock2.color = ccRED;
    [self addChild: hblock2 z: 1 tag: 1];
    
}

-(void) addStaminaBar  {
    
    CCSprite * sbframe1 = [CCSprite spriteWithFile:@"healthbar_frame.png"];
    sbframe1.position = ccp(250, 670);
    sbframe1.scaleY *= 0.4;
    [self addChild:sbframe1 z:2];
    CCSprite * sbfill1 = [CCSprite spriteWithFile:@"healthbar_fill.png"];
    sbfill1.position = ccp(250, 670);
    sbfill1.scaleY *= 0.4;
    [self addChild:sbfill1 z:0];
    
    sblock1 = [CCSprite spriteWithFile:@"block.png"];
    sblock1.position = ccp(250, 670);
    sblock1.scaleX *= 6;
    sblock1.scaleY *= 0.4;
    sblock1.color = ccGREEN;
    [self addChild: sblock1 z: 1 tag: 3];
    
    CCSprite * sbframe2 = [CCSprite spriteWithFile:@"healthbar_frame.png"];
    sbframe2.position = ccp(750, 670);
    sbframe2.scaleY *= 0.4;
    [self addChild:sbframe2 z:2];
    CCSprite * sbfill2 = [CCSprite spriteWithFile:@"healthbar_fill.png"];
    sbfill2.position = ccp(750, 670);
    sbfill2.scaleY *= 0.4;
    [self addChild:sbfill2 z:0];
    
    sblock2 = [CCSprite spriteWithFile:@"block.png"];
    sblock2.position = ccp(750, 670);
    sblock2.scaleX *= 6;
    sblock2.scaleY *= 0.4;
    sblock2.color = ccGREEN;
    [self addChild: sblock2 z: 1 tag: 4];
    
}

- (void) gameOver: (int) player {
    isGameOver = YES;
    CCBlink * blink = [CCBlink actionWithDuration:2.0 blinks:5];
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:.03];
    [fightLabel runAction:fadeIn];
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playEffect:@"game_over.mp3"];
    [player1.player stopAllActions];
    [player2.player stopAllActions];
    CCSprite * tapAgain = [CCSprite spriteWithFile:@"tap_again.png"];
    tapAgain.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:tapAgain z:100];
    //player 1 wins
    if (player == 1){
        [fightLabel setString:@"PLAYER 1 WINS!"];
        [player2.player runAction:blink];
        player2.player.rotation = 35;
        player2.player.position = ccp(player2.player.position.x, (player2.player.position.y -50));
      }
    
    // player 2 wins
    if (player == 2){
        [fightLabel setString:@"PLAYER 2 WINS!"];
        [player1.player runAction:blink];
        player1.player.rotation = -35;
        player1.player.position = ccp(player1.player.position.x, (player1.player.position.y -50));

       
      }//timer runs out on tied health
    if(player == 3){
        [fightLabel setString:@"TIED GAME!"];
        [player1.player runAction:blink];
        player1.player.rotation = -35;
        player1.player.position = ccp(player1.player.position.x, (player1.player.position.y -50));

        [player2.player runAction:blink];
        player2.player.rotation = 35;
        player2.player.position = ccp(player2.player.position.x, (player2.player.position.y -50));
    }
}

-(void) updateHealth: (int) playerNumber withAttack: (int) attackNumber {
    float scale = 0;
    float health = 0;
    if(!isGameOver){
    //star attack
    if (attackNumber == 1){
        scale = .30;
        health = 5;
    }
    
    //hit attack
    if (attackNumber == 2){
        scale = .60;
        health = 10;
    }
    
    //kick attack
    if (attackNumber == 3){
        scale = 1.20;
        health = 20;
    }
    
    //super attack
    if (attackNumber == 4){
        scale = 1.80;
        health = 30;
    }
    
    //lightning
    if (attackNumber == 5){
        scale = 1.80;
        health = 30;
    }
    
    //update first players health
    if (playerNumber == 1){
        
        //update variables
        hblock1.scaleX -= scale;
        player1.health -= health;
        hblock1.position = ccp(165 + (hblock1.contentSize.width)*(hblock1.scaleX)/2, 700);
        
        NSLog(@"Player 1 health = %f", player1.health);
        
        //check if the player is low on health
        if(player1.health < 5){
            
            [self gameOver:2];
        }
        
        //udate second players health
    }else if (playerNumber == 2){
        
        //update variables
        hblock2.scaleX -= scale;
        player2.health -= health;
        hblock2.position = ccp(664 + hblock2.contentSize.width*(hblock2.scaleX)/2, 700);
        
        NSLog(@"Player 2 health = %f", player2.health);
        
        //check if the player is low on health
        if(player2.health < 5){
            
            [self gameOver:1];
            
        }
    }
    }
}

-(BOOL) checkPlayerStamina:(int) playerNumber withAttack: (int) attackNumber
{
    float stamina = 0;
    
    //star attack
    if (attackNumber == 1)
    {
        stamina = 20;
    }
    
    //hit attack
    if (attackNumber == 2)
    {
        stamina = 10;
    }
    
    //kick attack
    if (attackNumber == 3)
    {
        stamina = 20;
    }
    
    //super attack
    if (attackNumber == 4)
    {
        stamina = 30;
    }
    
    if (attackNumber == 5)
    {
        stamina = 95;
    }
    
    if (playerNumber == 1)
    {
        if((player1.stamina - stamina) >= 0)
            return YES;
        else
            return NO;
    }
    else
    {
        if((player2.stamina - stamina) >= 0)
            return YES;
        else
            return NO;
    }

}

-(void) updateStamina: (int) playerNumber withAttack: (int) attackNumber {
    float scale = 0;
    float stamina = 0;
    
    if (attackNumber == 1){
        //scale = .30;
        scale = 1.2;
        stamina = 20;
    }
    
    //hit attack
    if (attackNumber == 2){
        scale = .60;
        stamina = 10;
    }
    
    //kick attack
    if (attackNumber == 3){
        scale = 1.20;
        stamina = 20;
    }
    
    //super attack
    if (attackNumber == 4){
        scale = 1.80;
        stamina = 30;
    }
    
    //lightning attack
    if (attackNumber == 5){
        scale =  5.75;
        stamina = 95;
    }
    
    //update first players health
    if (playerNumber == 1)
    {
        
        //update variables
            sblock1.scaleX -= scale;
            player1.stamina -= stamina;
            sblock1.position = ccp(165 + (sblock1.contentSize.width)*(sblock1.scaleX)/2, 670);
            
            NSLog(@"Player 1 stamina = %f", player1.stamina);
            
            //check if the player is low on stamina
            if(player1.stamina < 5)
            {
                NSLog(@"Player 1 out of stamina!!!!!!");
            }
   
        
        
        //udate second players stamina
        
    }else if (playerNumber == 2){
        
        //update variables
        sblock2.scaleX -= scale;
        player2.stamina -= stamina;
        sblock2.position = ccp(664 + sblock2.contentSize.width*(sblock2.scaleX)/2, 670);
        
        NSLog(@"Player 2 stamina = %f", player2.stamina);
        
        //check if the player is low on stamina
        if(player2.stamina < 5){
            
        NSLog(@"Player 2 out of stamina!!!!!!");
            
        }
    }
}

-(void) addTapToAttack
{
    tapToAttack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapToAttack:)];
    tapToAttack.numberOfTouchesRequired = 2;
    tapToAttack.numberOfTapsRequired = 1;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:tapToAttack];
    [tapToAttack release];
    
}

-(void) addTapToThrowGesture
{
    tapToThrowStar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapToThrowStar:)];
    tapToThrowStar.numberOfTouchesRequired = 1;
    tapToThrowStar.numberOfTapsRequired = 1;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:tapToThrowStar];
    [tapToThrowStar release];
}

//adds lightning bolt on side of screen
-(void) handleSwipeDown:(UISwipeGestureRecognizer *)recognizer  {
    if(player1.moveInProgress == NO)
    {
        CGPoint pt = [recognizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x < middleOfScreen && [self checkPlayerStamina:1 withAttack:5])
        {
            [self updateStamina:1 withAttack:5];
            Lightning * lightningBolt1 = [Lightning create: 1];
            lightningBolt1.lightningBolt.color = player1.player.color;
            [self addChild:lightningBolt1];
            [player1.player stopAllActions];
            [player1.player runAction: player1.blockAction];
            //if player 2 is on player 1's side of the screen
            if(CGRectIntersectsRect(lightningBolt1.lightningBolt.boundingBox, player2.player.boundingBox)){
                CCMoveTo * moveP2 = [CCMoveTo actionWithDuration:0.5 position:ccp(player2.player.position.x+250, player2.player.position.y)];
                [player2.player runAction:moveP2];
                [[SimpleAudioEngine sharedEngine]playEffect:@"hurt.mp3"];
                [self updateHealth:2 withAttack:5];
            }
            [player1 allowAnotherMove];
        }
    }
    
    if(player2.moveInProgress == NO)
    {
        CGPoint pt = [recognizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x > middleOfScreen && [self checkPlayerStamina:2 withAttack:5])
        {
            [self updateStamina:2 withAttack:5];
            Lightning * lightningBolt2 = [Lightning create:2];
            lightningBolt2.lightningBolt.color = player2.player.color;
            [self addChild:lightningBolt2];
            [player2.player stopAllActions];
            [player2.player runAction: player2.blockAction];
            //if player 1 is on player 2's side of the screen
            if(CGRectIntersectsRect(lightningBolt2.lightningBolt.boundingBox, player1.player.boundingBox)){
                CCMoveTo * moveP1 = [CCMoveTo actionWithDuration:0.5 position:ccp(player1.player.position.x-250, player1.player.position.y)];
                [player1.player runAction:moveP1];
                [[SimpleAudioEngine sharedEngine]playEffect:@"hurt.mp3"];
                [self updateHealth:1 withAttack:5];
                
            }
            [player2 allowAnotherMove];
        }
    }
  
}

-(void) addSwipeToMoveGesture
{
    swipeDownGR =[[ UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeDown:)];
    swipeDownGR.numberOfTouchesRequired = 1;
    swipeDownGR.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer: swipeDownGR];
    [swipeDownGR release];
  
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeLeft.numberOfTouchesRequired = 1;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
    [swipeLeft release];
    
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
    [swipeRight release];
}

-(void) addSwipeToJumpGesture
{
    swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    
    [swipeUp release];
}

-(void) handleTapToAttack: (UITapGestureRecognizer*) recongnizer
{
    if(player1.moveInProgress == NO && [self checkPlayerStamina:1 withAttack:2])
    {
        CGPoint pt = [recongnizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x < middleOfScreen)
        {
            [player1.player stopAllActions];
            
            ccBezierConfig path;
            path.controlPoint_1 = ccp(player1.player.position.x + 100, player1.player.position.y + 300);
            path.controlPoint_2 = ccp(player1.player.position.x + 50, player1.player.position.y + 150);
            path.endPosition = ccp (player1.player.position.x + 200, startingPositionPlayer1.y);
            CCBezierTo * bezierMove = [CCBezierTo actionWithDuration:1 bezier:path];
            [[SimpleAudioEngine sharedEngine]playEffect:@"sword_hit.mp3"];
            player1.moveInProgress = YES;
            [player1.player runAction:player1.strikingAction];
            [player1.player runAction:bezierMove];
            [self updateStamina:1 withAttack:2];
            [self schedule:@selector(checkCollisionsWithPlayer2:) interval:1.0f/30.0f];
        }
    }
    
    if(player2.moveInProgress == NO && [self checkPlayerStamina:2 withAttack:2])
    {
        CGPoint pt = [recongnizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x > middleOfScreen)
        {
            [player2.player stopAllActions];
            
            ccBezierConfig path;
            path.controlPoint_1 = ccp(player2.player.position.x - 100, player2.player.position.y + 300);
            path.controlPoint_2 = ccp(player2.player.position.x - 50, player2.player.position.y + 150);
            path.endPosition = ccp (player2.player.position.x - 200, startingPositionPlayer2.y);
            player2.moveInProgress = YES;
            CCBezierTo * bezierMove = [CCBezierTo actionWithDuration:1 bezier:path];
            [[SimpleAudioEngine sharedEngine]playEffect:@"sword_hit.mp3"];
            [player2.player runAction:player2.strikingAction];
            [player2.player runAction:bezierMove];
            [self updateStamina:2 withAttack:2];
            [self schedule:@selector(checkCollisionsWithPlayer1:) interval:1.0f/30.0f];
        }
    }
}

-(void)checkCollisionsWithPlayer2: (ccTime) delta
{
    if(player1.player.position.y == startingPositionPlayer1.y)
    {
        if(CGRectIntersectsRect([self returnRect:player1.player], [self returnRect:player2.player]))
        {
            [[SimpleAudioEngine sharedEngine]playEffect:@"sword_clang.mp3"];
            [[SimpleAudioEngine sharedEngine]playEffect:@"hurt.mp3"];
            CCMoveTo * move2 =[CCMoveTo actionWithDuration:0.3 position:ccp((player2.player.position.x + 100), player2.player.position.y)];
            [player2.player runAction:move2];
            [self updateHealth:2 withAttack:2];
        }
        [player1.player stopAllActions];
        [player1 allowAnotherMove];
        [self unschedule:@selector(checkCollisionsWithPlayer2:)];
    }
}

-(void)checkCollisionsWithPlayer1: (ccTime) delta
{
    
    if(player2.player.position.y == startingPositionPlayer2.y)
    {
        if(CGRectIntersectsRect([self returnRect:player2.player], [self returnRect:player1.player]))
        {
            [[SimpleAudioEngine sharedEngine]playEffect:@"sword_clang.mp3"];
            [[SimpleAudioEngine sharedEngine]playEffect:@"hurt.mp3"];
            CCMoveTo * move1 =[CCMoveTo actionWithDuration:0.3 position:ccp((player1.player.position.x - 100), player1.player.position.y)];
            [player1.player runAction:move1];
            [self updateHealth:1 withAttack:2];
        }
        
        [player2.player stopAllActions];
        [player2 allowAnotherMove];
        [self unschedule:@selector(checkCollisionsWithPlayer1:)];
    }
}


-(void) handleTapToThrowStar: (UITapGestureRecognizer*) recongnizer
{
    if(player1.moveInProgress == NO)
    {
        CGPoint pt = [recongnizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x < middleOfScreen && [self checkPlayerStamina:1 withAttack:1])
        {
            [player1.player stopAllActions];
            [player1.player runAction: player1.throwingAction];
            [[SimpleAudioEngine sharedEngine]playEffect:@"star_throw.mp3"];
            NinjaStar* ninjaStar = [NinjaStar create:1 andPosition:player1.player.position.x];
            ninjaStar.ninjaStar.color = player1.player.color;
            [self addChild:ninjaStar.ninjaStar];
            //Add the ninja star to player1's ninja star array.
            [player1Stars addObject:ninjaStar];
            [ninjaStar.ninjaStar runAction: ninjaStar.spinStar];
             [player1 allowAnotherMove];
             [self updateStamina:1 withAttack:1];
        }
        //this will reset the game after one tap
        if(isGameOver){
            [[CCDirector sharedDirector]replaceScene:[GameLayer sceneWithData:player1.player.color player2Color:player2.player.color]];
        }
    }
    
   if(player2.moveInProgress == NO)
    {
        CGPoint pt = [recongnizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x > middleOfScreen && [self checkPlayerStamina:2 withAttack:1])
        {
            [player2.player stopAllActions];
            [player2.player runAction: player2.throwingAction];
            [[SimpleAudioEngine sharedEngine]playEffect:@"star_throw.mp3"];
            NinjaStar* ninjaStar = [NinjaStar create:2 andPosition:player2.player.position.x];
            ninjaStar.ninjaStar.color = player2.player.color;
            [self addChild:ninjaStar.ninjaStar];
    
            //Add the ninja star to player2's ninja star array.
            [player2Stars addObject:ninjaStar];
            [ninjaStar.ninjaStar runAction: ninjaStar.spinStar];
            [player2 allowAnotherMove];
            [self updateStamina:2 withAttack:1];
        }
    }
}

-(void)handleSwipeLeft: (UISwipeGestureRecognizer*) recongnizer
{
    if(player1.moveInProgress == NO)
    {
        CGPoint pt = [recongnizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x < middleOfScreen)
        {
            player1.moveInProgress = YES;
           [player1.player stopAllActions];
           [player1.player runAction:player1.walkLeft];
            
        }
    }
    
    if(player2.moveInProgress == NO)
    {
        CGPoint pt = [recongnizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x > middleOfScreen)
        {
            player2.moveInProgress = YES;
            [player2.player stopAllActions];
            [player2.player runAction:player2.walkLeft];
        }
    }

}

-(void) handleSwipeRight: (UISwipeGestureRecognizer*) recongnizer
{
    if(player1.moveInProgress == NO)
    {
        CGPoint pt = [recongnizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x < middleOfScreen)
        {
            player1.moveInProgress = YES;
            [player1.player stopAllActions];
            [player1.player runAction:player1.walkRight];
        }
    }
    
    if(player2.moveInProgress == NO)
    {
        CGPoint pt = [recongnizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x > middleOfScreen)
        {
            player2.moveInProgress = YES;
            [player2.player stopAllActions];
            [player2.player runAction:player2.walkRight];
        }
    }
}

-(void) handleSwipeUp: (UISwipeGestureRecognizer*) recongnizer
{
    if(player1.moveInProgress == NO)
    {
        CGPoint pt = [recongnizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x < middleOfScreen)
        {
            player1.moveInProgress = YES;
            [player1.player stopAllActions];
            [player1.player runAction:player1.jump];
        }
    }
    
    if(player2.moveInProgress == NO)
    {
        CGPoint pt = [recongnizer locationOfTouch:0 inView:[[CCDirector sharedDirector] view]];
        if(pt.x > middleOfScreen)
        {
            player2.moveInProgress = YES;
            [player2.player stopAllActions];
            [player2.player runAction:player2.jump];
        }
    }
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


- (CGRect) returnRect: (CCSprite*) sprite{
    CGRect rect = CGRectMake(sprite.position.x - (sprite.contentSize.width/2),
                             sprite.position.y - (sprite.contentSize.height/2),
                             sprite.contentSize.width,
                             sprite.contentSize.height);
    return rect;
}

- (void) checkForCollisions{
    [self checkForNinjaStarCollisions];
}


- (void) checkForNinjaStarCollisions{
    int count = [player1Stars count];
    
    for(int i = 0; i < count; i++){
        NinjaStar* current = [player1Stars objectAtIndex:i];
        //Check if the ninja star went off the screen, if so then remove.
        NSLog(@"i = %d", i);
        if(current.position.x > winSize.width){
            [self removeChild:current.ninjaStar];
            [player1Stars removeObject:current];
            
            //Update the loop.
            count--;
            i--;
        }
        
        
        
        //Check if the ninja star hit the other player.
        if (CGRectIntersectsRect([self returnRect: current.ninjaStar], [self returnRect: player2.player])) {
            [[SimpleAudioEngine sharedEngine]playEffect:@"hurt.mp3"];
            [self removeChild:current.ninjaStar];
            [player1Stars removeObject:current];
            [self updateHealth:2 withAttack:1];
            //Update the loop.
            count--;
            i--;
        }
    }
    
    
    
    
    count = [player2Stars count];
    for(int i = 0; i < count; i++){
        NinjaStar* current = [player2Stars objectAtIndex:i];
        //Check if the ninja star went off the screen, if so then remove.
        if(current.position.x < 0){
            [self removeChild:current.ninjaStar];
            [player2Stars removeObject:current];
            
            //Update the loop.
            count--;
            i--;
        }
        
        //Check if the ninja star hit the other player.
        if (CGRectIntersectsRect([self returnRect: current.ninjaStar], [self returnRect: player1.player])) {
            [[SimpleAudioEngine sharedEngine]playEffect:@"hurt.mp3"];
            [self removeChild:current.ninjaStar];
            [player2Stars removeObject:current];
             [self updateHealth:1 withAttack:1];
            //Update the loop.
            count--;
            i--;
        }
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
