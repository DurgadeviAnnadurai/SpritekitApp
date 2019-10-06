//
//  ViewController.m
//  SpriteKit
//
//  Created by Durga on 5/27/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "HelloScene.h"
#import <SpriteKit/SpriteKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     //  SKView *skview=(SKView *)self.view;
//skview.showsDrawCount=YES;
  //  skview.showsFPS=YES;
   // skview.showsNodeCount=YES;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    HelloScene *helloscene=[[HelloScene alloc]initWithSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.height)];
    SKView *skview=(SKView *)self.view;
    [skview presentScene:helloscene];
}
@end
