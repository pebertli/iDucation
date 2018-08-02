//
//  teste_BrilhoViewController.m
//  teste_Brilho
//
//  Created by User on 27/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import "teste_BrilhoViewController.h"


@interface teste_BrilhoViewController ()

@end

@implementation teste_BrilhoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    HVImageMatrix * botao =
    [HVImageMatrix fastCreation:@"F001_thomson_button_power.png"];
    [botao setMatrixRowsCount:1 andColsCount:2];
    
    [self.view addSubview:botao];
    [botao alignToCenter];
    [botao setIndex:0];
    
    shine_test = [HVShineView fastCreationSettingParent:botao];
    
    dotTeste = [HVDot fastCreationInView:self.view];
    dotTeste.center = CGPointMake(350, 100);
    [dotTeste setTap:self
     actionSingleTap:@selector(pause)
     actionDoubleTap:@selector(play)];
    
    HVImageMatrix * botao2 =
    [HVImageMatrix fastCreation:@"F001_thomson_button_power.png"];
    [botao2 setMatrixRowsCount:1 andColsCount:2];
    [botao2 setIndex:1];
    [botao2 setCenter:CGPointMake(300, 300)];
    [self.view addSubview:botao2];
//    UIColor * branco = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.35];
//    UIColor * branco2 = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
//    CGGradientRef gradiente =
//    gradientBiLinear(branco, branco2);
//    UIImage * shine =
//    [HVShineView diagonalShine:CGSizeMake(500, 100)
//                         angle:eulerToRadians(20)
//                     thickness:40
//                      gradient:gradiente];
//    [shine_test setShineImage:shine];
//    [shine_test setMaskImage:[UIImage imageNamed:@"F001_thomson_button_power.png"]];
//    

    [shine_test setShineWithDefaultLinearGradient:
     [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
    [shine_test setMaskImage:[UIImage imageNamed:@"F001_thomson_button_power.png"]];
    
    [self.view addSubview:botao];
    [botao alignToCenter];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //Get a UIImage from the UIView
    UIGraphicsBeginImageContext(botao.bounds.size);
    [botao.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Blur the UIImage
    CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 5] forKey: @"inputRadius"];
    CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
    UIImage *endImage = [[UIImage alloc] initWithCIImage:resultImage];
    
    //Place the UIImage in a UIImageView
    UIImageView *newView = [[UIImageView alloc] initWithFrame:botao.bounds];
    newView.image = endImage;
    [self.view addSubview:newView];

}

- (void)pause{
    HVlog(@"pause ", 0);
    [shine_test stop];
}

- (void)play{
    HVlog(@"play ", 0);
    [shine_test play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
