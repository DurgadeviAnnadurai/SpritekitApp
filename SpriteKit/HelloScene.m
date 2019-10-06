//
//  HelloScene.m
//  SpriteKit
//
//  Created by Durga on 5/27/14.
//  Copyright (c) 2014 Durga. All rights reserved.
//

#import "HelloScene.h"
#import <SpriteKit/SpriteKit.h>
#import "ArcheryScene.h"
@implementation HelloScene




-(void)didMoveToView:(SKView *)view
{
    UIImageView *imvBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imvBg.image=[UIImage imageNamed:@"Startscreen-Logo.png"];
  //  [self.view addSubview:imvBg];

    self.backgroundColor=[UIColor yellowColor];
    
    
    SKSpriteNode  *aNode=[[SKSpriteNode alloc]initWithImageNamed:@"MainscreenBg.png"];
    aNode.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    aNode.size=self.view.frame.size;
    //   playNode.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:playNode.frame.size];
    
    aNode.name=@"playNode";
    [self addChild:aNode];
    
    [self playNode];
    self.physicsWorld.contactDelegate=(id)self;
    
    
    
    
    SKLabelNode *lblTitle = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    lblTitle.fontSize = 47;
    lblTitle.fontColor = [SKColor redColor];
    lblTitle.position=CGPointMake(300,CGRectGetHeight(self.frame)-85);
    lblTitle.text =@"The Killer";
    lblTitle.fontName=@"Chalkduster";
    [self addChild:lblTitle];

    SKAction *playsound = [SKAction playSoundFileNamed:@"jamesbond.mp3" waitForCompletion:YES];
    SKAction *repeatMusic=[SKAction repeatActionForever:playsound];
    [self runAction:repeatMusic];
    
   
}

- (CIFilter *)blurFilter
{
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"]; // 3
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:20] forKey:@"inputRadius"];
    return filter;
}
-(void)playNode
{
    
    
    
    playNode=[[SKSpriteNode alloc]initWithImageNamed:@"play.png"];
    playNode.position=CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-50);
    playNode.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:playNode.frame.size];
    playNode.physicsBody.dynamic=NO;
    playNode.physicsBody.usesPreciseCollisionDetection=YES;
    playNode.name=@"playNode";
    
   
    SKAction *moveHorizontal = [SKAction moveToX:CGRectGetMidX(self.frame)+150 duration:1.0f];
    moveHorizontal.timingMode = SKActionTimingEaseOut;
    SKAction *moveBack = [SKAction moveToX:CGRectGetMidX(self.frame)+50 duration:1.0];
    SKAction *wait = [SKAction waitForDuration:0.4f];
    SKAction *backAndForth = [SKAction sequence:@[moveHorizontal, wait, moveBack, wait]];
    SKAction *repeatHorizMove = [SKAction repeatActionForever:backAndForth];
    [self addChild:playNode];
    [playNode runAction:repeatHorizMove];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        
        SKNode *node = [self nodeAtPoint:location];
        if ([[node name]  isEqual: @"playNode"])
        {
//            SKAction *fade=[SKAction fadeInWithDuration:0.1];
//            SKAction *animate=[SKAction rotateByAngle:6.28 duration:0.3];
//            SKAction *speed=[SKAction speedTo:3.0 duration:0.3];
            
          //  SKAction *sequence= [SKAction sequence:@[fade,animate,speed]];
//            [playNode runAction:sequence completion:^{
                ArcheryScene *archeryScene=[[ArcheryScene alloc]initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
            SKTransition *transition=[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5];
            //[SKTransition flipHorizontalWithDuration:0.3];
             //   archeryScene.backgroundColor=[UIColor brownColor];
            
                [self.view presentScene:archeryScene transition:transition];
//            }];
            
            
        }
        
        
    }
    
}

@end
