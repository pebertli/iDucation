//
//  teste_CoresViewController.m
//  teste_Cores
//
//  Created by User on 16/04/13.
//  Copyright (c) 2013 HandVerse. All rights reserved.
//

#import "teste_CoresViewController.h"

@interface teste_CoresViewController ()

@end

@implementation teste_CoresViewController

CGColorRef CGColorMix(CGColorRef color1, CGColorRef color2, double percentage){
    CGFloat * components1 = CGColorGetComponents(color1);
    CGFloat * components2 = CGColorGetComponents(color2);
    double r = (1-percentage)*components1[0]+percentage*components2[0];
    double g = (1-percentage)*components1[1]+percentage*components2[1];
    double b = (1-percentage)*components1[2]+percentage*components2[2];
    double a = (1-percentage)*components1[3]+percentage*components2[3];
    CGFloat components3[] = {r, g, b, a};
    NSLog(@"White: %0.02f , %0.02f , %0.02f , %0.02f",
          components2[0],
          components2[1],
          components2[2],
          components2[3]);
    return CGColorCreate(CGColorSpaceCreateDeviceRGB(), components3);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGFloat components1[] = {0.5, 1.0, 0.7, 1.0};
//    CGFloat components2[] = {1.0, 0.0, 0.0, 1.0};
    CGFloat components2[] = {0, 0, 0, 1.0};
    CGColorRef cor1 = CGColorCreate(CGColorSpaceCreateDeviceRGB(), components1);
    CGColorRef cor2 = CGColorCreate(CGColorSpaceCreateDeviceRGB(), components2);
    cor2 = [[UIColor whiteColor] CGColor];
    int interactions = 20;
    for (int i=0; i<=interactions; i++) {
        UIView * view = [[UIView alloc] initWithFrame:
                         CGRectMake(50 + i * 30, 50, 25, 25)];
        UIColor * corAtual = [UIColor colorWithCGColor:
                              CGColorMix(cor1, cor2, (i/(double)interactions))];
        [view setBackgroundColor:corAtual];
        [self.view addSubview:view];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
