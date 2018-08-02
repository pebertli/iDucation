//
//  Slide1ViewController.m
//  iducation
//
//  Created by pebertli on 09/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "Slide1ViewController.h"
#import "IDCDaltonViewController.h"


@interface Slide1ViewController ()

@end

@implementation Slide1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    //load note view controller
//    NSArray* a = [NSArray arrayWithObjects:@"teapot", nil];
//    gl1Controller = [[IDCGLKitViewController alloc] initWithFrame:CGRectMake(300, 300, 300, 300) modelList:@"teapot" modelNames:a ];
//    [self.view insertSubview:gl1Controller.view aboveSubview:self.view];
   //  NSArray* a = [NSArray arrayWithObjects:@"cart", nil];
   //  gl1Controller = [[IDCGLKitViewController alloc] initWithFrame:CGRectMake(0, 0, 100, 100) modelList:@"cart007" modelNames:a ];
    //[self.view insertSubview:gl1Controller.view aboveSubview:self.view];
    //[self.view addSubview:gl1Controller.view];
    


    HVThumbnail* t = [[HVThumbnail alloc] initWithFrame:CGRectMake(100, 600, 500, 200) thumbnail:@"cartTextures.png"];
    [self.view addSubview:t];
    //[t setMainViewWithView:gl1Controller.view frame:CGRectMake(0, 0, 768, 1024)];
    
    dc = [[IDCDaltonViewController alloc] init];
    [t setMainViewWithView:dc.view frame:CGRectMake(0, 0, 768, 1024)];
    
    HVThumbnail* t2 = [[HVThumbnail alloc] initWithFrame:CGRectMake(100, 400, 100, 100) thumbnail:@"cartTextures.png"];
    [self.view addSubview:t2];
    
    bh = [[IDCBohrHeatViewController alloc] init];
    [t2 setMainViewWithView:bh.view frame:CGRectMake(0, 0, 768, 1024)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


@end
