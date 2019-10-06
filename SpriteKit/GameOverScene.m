//
//  GameOverScene.m
//  SpriteKit
//
//  Created by Durga on 30/04/15.
//  Copyright (c) 2015 Durga. All rights reserved.
//

#import "GameOverScene.h"
#import "ArcheryScene.h"

@implementation GameOverScene
@synthesize score;
-(void)didMoveToView:(SKView *)view
{
     
    SKSpriteNode  *playNode=[[SKSpriteNode alloc]initWithImageNamed:@"GameOver.png"];
    playNode.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    playNode.size=self.view.frame.size;
    playNode.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:playNode.frame.size];
    playNode.physicsBody.dynamic=NO;
    playNode.physicsBody.usesPreciseCollisionDetection=YES;
    playNode.name=@"playNode";
    [self addChild:playNode];
    
    
    SKSpriteNode  *replayNode=[[SKSpriteNode alloc]initWithImageNamed:@"replay.png"];
    replayNode.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100);
    replayNode.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:playNode.frame.size];
    replayNode.physicsBody.dynamic=NO;
    replayNode.physicsBody.usesPreciseCollisionDetection=YES;
    replayNode.name=@"replayNode";
    [self addChild:replayNode];

    
    SKLabelNode  *lblScore = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    lblScore.fontSize = 40;
    lblScore.fontColor = [SKColor redColor];
    lblScore.position=CGPointMake(CGRectGetMidX(self.frame)-150, CGRectGetMidY(self.frame)+30);
    NSString *strscore=score;
    lblScore.text = [NSString stringWithFormat:@"Score  %@",strscore];
    lblScore.fontName=@"Zapfino";
    [self addChild:lblScore];
    

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        
        SKNode *node = [self nodeAtPoint:location];
        if ([[node name]  isEqual: @"replayNode"])
        {
            SKAction *fade=[SKAction fadeInWithDuration:0.1];
            SKAction *animate=[SKAction rotateByAngle:6.28 duration:0.3];
            SKAction *speed=[SKAction speedTo:3.0 duration:0.3];
            
            SKAction *sequence= [SKAction sequence:@[fade,animate,speed]];
            //            [playNode runAction:sequence completion:^{
            ArcheryScene *archeryScene=[[ArcheryScene alloc]initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
            SKTransition *transition=[SKTransition doorsOpenVerticalWithDuration:0.3];
            archeryScene.backgroundColor=[UIColor brownColor];
            [self.view presentScene:archeryScene transition:transition];
            //            }];
            
            
        }
        
        
    }
    
}
@end
