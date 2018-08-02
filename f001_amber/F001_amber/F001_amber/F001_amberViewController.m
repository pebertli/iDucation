//
//  F001_amberViewController.m
//  F001_amber
//
//  Created by User on 13/06/13.
//  Copyright (c) 2013 iDucation. All rights reserved.
//

#import "F001_amberViewController.h"

@interface F001_amberViewController ()

@end

@implementation F001_amberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //amber = [F001_amberContainer fastCreationSettingParent:self.view];
    
    amberScene =
    [F001_amberScene amberSceneAt:CGPointMake(200, 180) inView:self.view];
    
    amberStone =
    [F001_amberStone amberStoneAt:CGPointMake(250, 300) inScene:amberScene];
    
//    HVImageMatrix * test = [HVImageMatrix fastCreation:@"F001_amber_buttons.png"];
//    [test setImageScale:0.8];
//    [test setMatrixCellWidth:80 andHeight:80];
//    UIImage * imgTest = [test imageFromIndex:7 scale:0.8];
//    UIImageView * vwTest = [[UIImageView alloc] initWithImage:imgTest];
//    
//    [self.view addSubview:vwTest];
    
    
    HVDot * dot1 = [HVDot dotAt:CGPointMake(30, 30) inView:amberScene];
    [dot1 setDrag:nil onStart:nil onChange:nil onEnd:nil];
    //[dot1 setTap:self actionSingleTap:@selector(dot1Tap) actionDoubleTap:nil];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
        
}

- (void)dot1Tap{
    [amber prepareToLeavesFall];
    [amber fallLeaves];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
