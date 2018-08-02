//
//  testeDragViewController.m
//  teste_Drag
//
//  Created by User on 28/03/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import "testeDragViewController.h"
#import "HVCustomizedViews.h"
#import "HVUtils.h"
#import "HVGeometry.h"



@interface testeDragViewController ()

@end


@interface testeDragViewController ()

@end

@implementation testeDragViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    view0 = [[UIView alloc] initWithFrame:CGRectMake(80, 80, 620, 840)];
    view1 = [[UIView alloc] initWithFrame:CGRectMake(25, 100, 250, 150)];
    view2 = [[UIView alloc] initWithFrame:CGRectMake(25, 300, 250, 150)];
    view3 = [[UIView alloc] initWithFrame:CGRectMake(25, 500, 250, 150)];
    view4 = [[UIView alloc] initWithFrame:CGRectMake(25, 700, 250, 150)];
    view5 = [[HVView alloc] initWithFrame:CGRectMake(30, 40, 250, 150)];
    
    view0.alpha = 0.5;
    view1.alpha = 0.5;
    view2.alpha = 0.5;
    view3.alpha = 0.5;
    view4.alpha = 0.5;
    view5.alpha = 0.5;
    
    [view0 setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
    [view1 setBackgroundColor:[UIColor greenColor]];
    [view2 setBackgroundColor:[UIColor blueColor]];
    [view3 setBackgroundColor:[UIColor redColor]];
    [view4 setBackgroundColor:[UIColor yellowColor]];
    [view5 setBackgroundColor:[UIColor orangeColor]];
    
    [self.view addSubview:view0];
    
//    [self.view addSubview:view1];
//    [self.view addSubview:view2];
//    [self.view addSubview:view3];
//    [self.view addSubview:view4];
        [view0 addSubview:view1];
        [view0 addSubview:view2];
        [view0 addSubview:view3];
        [view0 addSubview:view4];

    
    //[self.view addSubview:view5];
    
    //HVDrag * drag1 = [HVDrag fastCreationSettingView:view1];
    HVDrag * drag2 = [HVDrag fastCreationSettingView:view2];
    HVDrag * drag3 = [HVDrag fastCreationSettingView:view3];
    //HVDrag * drag4 = [HVDrag fastCreationSettingView:view4];
    
    HVDragView * test = [HVDragView fastCreationSettingView:view1];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    UILabel * label4 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    UILabel * label5 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    
    label1.text = @"1 dedo para deslizar";
    label2.text = @"2 dedos para deslizar";
    label3.text = @"3 dedos para deslizar";
    label4.text = @"deslizar sob uma linha";
    label5.text = @"Deslizamento externo";
    
    [view1 addSubview:label1];
    [view2 addSubview:label2];
    [view3 addSubview:label3];
    [view4 addSubview:label4];
    [view5 addSubview:label5];
    
    //[drag1 setNumberOfTouchesToDrag:1];
    [drag2 setNumberOfTouchesToDrag:2];
    [drag3 setNumberOfTouchesToDrag:3];
    //    [drag3 enableDrag:NO];
    
    HVGesturesArea * gestureAreaTest = [HVGesturesArea fastCreationSettingNumberOfFingers:2];
    [gestureAreaTest setFrame:CGRectMake(350, 400, 400, 500)];
    [gestureAreaTest setBackgroundColor:[UIColor purpleColor]];
    [gestureAreaTest setAlpha:0.25];
    [self.view addSubview:gestureAreaTest];
    [gestureAreaTest addSubview:view5];
//    [gestureAreaTest enablePanGestureRecognizer:YES];
    
    HVDrag * drag5 = [HVDrag fastCreationSettingView:view5
                                      andGestureArea:gestureAreaTest
                                   thatMovesTogether:NO];
    
    
    HVSlider * slider = [HVSlider fastCreationSettingView:view4];
    [slider setLineTrackFrom:view4.center
                          to:sumVectors(view4.center,
                                        CGPointMake(150, -150))];
    [slider createGestureArea];
    [slider enableSpring:YES];
    [slider setDefaultValue:0.5];
    [slider setValue:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

