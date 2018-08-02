//
//  teste_ToolbarViewController.m
//  teste_Toolbar
//
//  Created by User on 04/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import "teste_ToolbarViewController.h"
#import "HVToolbar.h"
#import "HVUtils.h"

@interface teste_ToolbarViewController ()

@end

@implementation teste_ToolbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //UIImage * icons = imageFromFileWithScale(@"handverse_icons.png", 2);
    UIImage * icons = [UIImage imageNamed:@"handverse_icons.png"];
    
    HVToolbar * toolbar =
    [HVToolbar fastCreationSettingImage:icons andButtonSize:CGSizeMake(50, 50)];
    [toolbar setImageScale:0.5];
    HVToolbarGroup * grupo1 = [HVToolbarGroup fastCreationInToolbar:toolbar];
    botao0 = [grupo1 addButtonWithIconIndex:[HVIconIndex pencil]];
    [grupo1 addButtonWithIconIndex:1];
    [grupo1 addButtonWithIconIndex:2];
    [grupo1 addButtonWithIconIndex:3];
    [grupo1 addButtonWithIconIndex:9];
//    HVToolbarGroup * grupo2 = [HVToolbarGroup fastCreationInToolbar:toolbar];
//    [grupo2 addButtonWithIconIndex:8];
//    [grupo2 addButtonWithIconIndex:7];
//    [grupo2 addButtonWithIconIndex:6];
//    [grupo2 addButtonWithIconIndex:5];
//    [grupo2 addButtonWithIconIndex:4];

    
    [self.view addSubview:toolbar];
    [toolbar setCenter:self.view.center];
    [grupo1 setBackgroundColor:[UIColor yellowColor]];
    
    dot = [HVDot dotAt:CGPointMake(350, 300) inView:self.view];
    [dot setBackgroundColor:[UIColor yellowColor]];
    
    [botao0 setBackgroundColor:[UIColor greenColor]];
    
}

- (void) escalarDot{
    HVlog(@"botao acionado", 0);
    CGAffineTransform tr = CGAffineTransformScale(dot.transform, 4, 4);
    [UIView animateWithDuration:3.5 delay:1 options:0 animations:^{
        dot.transform = tr;
        dot.alpha = 0.5;
        //dot.center = dot.center;
    } completion:^(BOOL finished) {
        [dot setNeedsDisplay];
    }];
    [dot setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
