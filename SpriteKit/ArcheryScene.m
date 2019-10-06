//
//  ArcheryScene.m
//  SpriteKit
//
//  Created by Durga on 4/27/15.
//  Copyright (c) 2015 Durga. All rights reserved.
//

#import "ArcheryScene.h"
#import "GameOverScene.h"
static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t monsterCategory        =  0x1 << 1;
static const uint32_t personCategory        =  0x1 << 2;
static const uint32_t bonusCategory        =  0x1 << 3;


@interface ArcheryScene ()
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) int monstersDestroyed;
@end

@implementation ArcheryScene
{
    SKNode *gunNode;
    NSUInteger score;
    NSUInteger life;
    SKLabelNode *lblScore,*lblTime,*lblLife;
    NSTimer *timer,*timerDie;
    int currMinute;
    int currSeconds;
    int pausetimeSeconds;
    NSUInteger bonusCount;
    SKSpriteNode * monster,*bonus;
    SKEmitterNode *burstNode;
    SKAction *gunsound,*deadsound,*personDeadSound;
    BOOL Die;

}
-(void)didMoveToView:(SKView *)view
{
    
    SKSpriteNode  *bgNode=[[SKSpriteNode alloc]initWithImageNamed:@"main.png"];
    bgNode.position=CGPointMake( CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
     bgNode.size=self.view.frame.size;
    //   playNode.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:playNode.frame.size];
    
    bgNode.name=@"bgNode";
    [self addChild:bgNode];
    
    
    SKSpriteNode *scoreicon = [SKSpriteNode spriteNodeWithImageNamed:@"trophy.png"];
    scoreicon.position = CGPointMake(CGRectGetWidth(self.frame)-100,CGRectGetHeight(self.frame)-20);
    [self addChild:scoreicon];
    
    
    SKSpriteNode *lifeicon = [SKSpriteNode spriteNodeWithImageNamed:@"life.png"];
    lifeicon.position = CGPointMake(CGRectGetWidth(self.frame)-200,CGRectGetHeight(self.frame)-20);
    [self addChild:lifeicon];

    lblLife = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    lblLife.fontSize = 17;
    lblLife.fontColor = [SKColor redColor];
    lblLife.position=CGPointMake(CGRectGetWidth(self.frame)-170,CGRectGetHeight(self.frame)-25);
    life=3;
    lblLife.text = [NSString stringWithFormat:@"%lu",(unsigned long)life];
    lblLife.fontName=@"Chalkduster";
    [self addChild:lblLife];
    
    lblScore = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    lblScore.fontSize = 17;
    lblScore.fontColor = [SKColor redColor];
    lblScore.position=CGPointMake(CGRectGetWidth(self.frame)-70,CGRectGetHeight(self.frame)-25);
    score=0;
    lblScore.text = [NSString stringWithFormat:@"%lu",(unsigned long)score];
    lblScore.fontName=@"Chalkduster";
    [self addChild:lblScore];
    
    
    lblTime = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    lblTime.fontSize = 17;
    lblTime.fontColor = [SKColor redColor];
    lblTime.position=CGPointMake(60,CGRectGetHeight(self.frame)-25);
    lblTime.text = @"Time : 1:00";
    lblTime.fontName=@"Chalkduster";
    [self addChild:lblTime];
    
    
    currMinute=1;
    currSeconds=00;
    [self start];
    
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"person.png"];
     self.player.position = CGPointMake(self.player.size.width/2+20, self.frame.size.height/2);
     self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.size.width/2];
    

    self.player.physicsBody.dynamic = YES;
    self.player.physicsBody.categoryBitMask = personCategory;
    self.player.physicsBody.contactTestBitMask = monsterCategory;
    self.player.physicsBody.collisionBitMask = 0;
    self.player.physicsBody.usesPreciseCollisionDetection = YES;
    
    self.player.name=@"person";
    [self addChild:self.player];
    
    
    
    SKSpriteNode *pause= [SKSpriteNode spriteNodeWithImageNamed:@"pause.png"];
    pause.position = CGPointMake(140,CGRectGetHeight(self.frame)-20);
     pause.name=@"pauseNode";
    [self addChild:pause];

    
    SKSpriteNode *shoot = [SKSpriteNode spriteNodeWithImageNamed:@"shoot.png"];
    shoot.position = CGPointMake( CGRectGetWidth(self.frame)-50, CGRectGetMidY(self.frame)-120);
    shoot.name=@"shoot";
    [self addChild:shoot];

     gunsound = [SKAction playSoundFileNamed:@"gunshot.mp3" waitForCompletion:NO];
     deadsound = [SKAction playSoundFileNamed:@"screamsound.mp3" waitForCompletion:NO];
     personDeadSound=[SKAction playSoundFileNamed:@"deadsound.mp3" waitForCompletion:NO];
  
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
               self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        bonusCount=14;
      

        
    }
    return self;
}
-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [lblTime setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",currMinute,@":",currSeconds]];
    }
    
    else
    {
        
        [timer invalidate];
        
        SKTransition *reveal = [SKTransition doorsCloseVerticalWithDuration:0.5];
        GameOverScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size];
        NSNumber *scorevalue=@(score);
        gameOverScene.score=[scorevalue stringValue];
        [self.view presentScene:gameOverScene transition: reveal];

    }
}
- (void)addMonster {
    
    [burstNode removeFromParent];

    monster = [SKSpriteNode spriteNodeWithImageNamed:@"thief.png"];
    monster.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:monster.size.width/2]; // 1
    monster.physicsBody.dynamic = YES; // 2
    monster.physicsBody.categoryBitMask = monsterCategory; // 3
    monster.physicsBody.contactTestBitMask = projectileCategory | personCategory; // 4
    monster.physicsBody.collisionBitMask = 0; // 5
    
    // Determine where to spawn the monster along the Y axis
    int minY = monster.size.height / 2;
    int maxY = self.frame.size.height - monster.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = CGPointMake(self.frame.size.width + monster.size.width/2, actualY);
    [self addChild:monster];
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-monster.size.width/2, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [monster runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        if (!Die)
        {
            [self addMonster];

        }
        else
        {
            [monster removeFromParent];
        }
        if (currSeconds==52)
        {
            [self addBonus];
            
        }
        
    }
}
- (void)addBonus
{
    bonus = [SKSpriteNode spriteNodeWithImageNamed:@"star.png"];
    bonus.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bonus.size.width/2]; // 1
    bonus.physicsBody.dynamic = YES; // 2
    bonus.physicsBody.categoryBitMask = bonusCategory;
    bonus.physicsBody.contactTestBitMask = personCategory;
    bonus.physicsBody.collisionBitMask = 0;
    
    // Determine where to spawn the monster along the Y axis
    int minY = bonus.size.height / 2;
    int maxY = self.frame.size.height - bonus.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    bonus.position = CGPointMake(self.frame.size.width + bonus.size.width/2, actualY);
    [self addChild:bonus];
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-bonus.size.width/2, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [bonus runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];

}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
  //  [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];
    
    // 1 - Choose one of the touches to work with
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    BOOL shoot=NO;
    BOOL pause=NO;
    BOOL notMove=NO;
    NSMutableArray *nodeName=[[NSMutableArray alloc]init];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];

    
    for (SKNode *node in nodes)
    {
        if (node.name!=nil)
        {
            [nodeName addObject:node.name];

        }
        
    }
    
    for (NSString *name in nodeName)
    {
    
        if ([name isEqualToString:@"pauseNode"]||[name isEqualToString:@"shoot"])
        {
            notMove=YES;
        }
    }
  
  
      for (SKNode *node in nodes)
    {
        
        
        
        
        if ([node.name isEqualToString:@"pauseNode"])
        {
            pause=YES;
            if (self.view.paused==YES)
            {
                self.view.paused = false;
                [self start];
            }
            else
            {
                self.view.paused = true;
                [timer invalidate];
                pausetimeSeconds=currSeconds;

            }
        }
        else if ([node.name isEqualToString:@"shoot"])
        {
            shoot=YES;
            // 2 - Set up initial location of projectile
            SKSpriteNode * projectile = [SKSpriteNode spriteNodeWithImageNamed:@"bullets.png"];
            projectile.position =self.player.position;
            projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
            projectile.physicsBody.dynamic = YES;
            projectile.physicsBody.categoryBitMask = projectileCategory;
            projectile.physicsBody.contactTestBitMask = monsterCategory;
            projectile.physicsBody.collisionBitMask = 0;
            projectile.physicsBody.usesPreciseCollisionDetection = YES;
            
            
            // 5 - OK to add now - we've double checked position
            [self addChild:projectile];
            
            SKAction * actionMove = [SKAction moveToX:700 duration:1.2];
            [projectile runAction:actionMove];
            [self runAction:gunsound];


            
        }
        else if([node.name isEqualToString:@"bgNode"] && !notMove)
        {
            SKAction *moveHorizontal = [SKAction moveToY:location.y duration:1.0f];
            
            [self.player runAction:moveHorizontal];

        }

       
    }
    
}

- (void)projectile:(SKSpriteNode *)projectile didCollideWithMonster:(SKSpriteNode *)thief {
    

    [projectile removeFromParent];
    SKAction * actionMove = [SKAction rotateByAngle:1.57 duration:0.0001];
    bonusCount=bonusCount+1;
    [thief runAction:actionMove];
    
    
    double delayInSeconds = 0.10;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [thief removeFromParent];
        SKAction * actionFadeOut = [SKAction fadeInWithDuration:0.2];
        [self.player runAction:actionFadeOut];
     //   monster.paused=NO;

    });
   
    self.monstersDestroyed++;
    if (self.monstersDestroyed > 30) {
//        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
//        [self.view presentScene:gameOverScene transition: reveal];
    }
}
- (void)projectile:(SKSpriteNode *)hero didCollideWithstar:(SKSpriteNode *)star
{
   
    double delayInSeconds = 0.10;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [star removeFromParent];
        
    });
}
- (void)didEndContact:(SKPhysicsContact *)contact{
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
        (secondBody.categoryBitMask & monsterCategory) != 0)
    {
       
        NSLog(@"Hit");
        score=score+5;
        lblScore.text=[NSString stringWithFormat:@"%lu",(unsigned long)score];
        NSString *burstParticle=[[NSBundle mainBundle]pathForResource:@"BurstParticle" ofType:@"sks"];
        burstNode=[NSKeyedUnarchiver unarchiveObjectWithFile:burstParticle];
        burstNode.position=CGPointMake(monster.position.x, monster.position.y);
      //  [self addChild:burstNode];
        [self runAction:deadsound];
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
    }
     else  if ((firstBody.categoryBitMask & monsterCategory) != 0 &&
        (secondBody.categoryBitMask & personCategory) != 0)

    {
        SKAction * actionMove = [SKAction rotateByAngle:10 duration:0.2];
        [self.player runAction:actionMove];
        [self runAction:personDeadSound];
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            life=life-1;
            lblLife.text=[NSString stringWithFormat:@"%lu",(unsigned long)life];
            if (life==1 || life==2 || life==3)
            {
                SKAction * actionMove = [SKAction rotateByAngle:-10 duration:0.1];
                [self.player runAction:actionMove];

                
                SKAction *flashAction = [SKAction sequence:@[
                                                             [SKAction fadeAlphaTo:0.4 duration:0.1f],
                                                             [SKAction waitForDuration:0.1f],
                                                             [SKAction fadeAlphaTo:1.0 duration:0.1f]]];
                SKAction *repeatFlash=[SKAction repeatAction:flashAction count:5];
                [self.player runAction:repeatFlash];
                Die=YES;
                [monster removeFromParent];
                timerDie=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerDie) userInfo:nil repeats:NO];
                

            }

        });
        
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
        if (life==0)
        {
            SKTransition *reveal = [SKTransition doorsCloseVerticalWithDuration:0.5];
            GameOverScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size];
            NSNumber *scorevalue=@(score);
            gameOverScene.score=[scorevalue stringValue];
            [self.view presentScene:gameOverScene transition: reveal];
            
        }
        });

       
        
    }
     else  if ((firstBody.categoryBitMask & personCategory) != 0 &&
               (secondBody.categoryBitMask & bonusCategory) != 0)
     {
         life=life+1;
         lblLife.text=[NSString stringWithFormat:@"%lu",(unsigned long)life];
         SKAction *big = [SKAction sequence:@[
                                                      [SKAction scaleBy:2 duration:0.1f],
                                                      [SKAction waitForDuration:0.1f],
                                                      [SKAction scaleBy:0.5 duration:0.1f]]];
         
         [self.player runAction:big];
         [self projectile:(SKSpriteNode *)firstBody.node didCollideWithstar:(SKSpriteNode *)secondBody.node];
     }
}
-(void)timerDie
{
    Die=NO;
}

@end
