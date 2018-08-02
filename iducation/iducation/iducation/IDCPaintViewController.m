//
//  IDCPaintViewController.m
//  iducation
//
//  Created by pebertli on 11/09/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCPaintViewController.h"

@interface IDCPaintViewController ()

@end

@implementation IDCPaintViewController

@synthesize slide;
@synthesize canvas;
@synthesize closeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        slide = @"slide_1";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.alpha = 0.0;
    
//    canvas = [[IDCPaintView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:canvas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redButtonClick:(id)sender {
    [canvas setMainColor:[UIColor redColor]];
    [canvas enableEraser:NO];
}

- (IBAction)eraserButtonClick:(id)sender {
    [canvas enableEraser:YES];
}

- (IBAction)cleanButtonClick:(id)sender {
    [canvas clear];
}

//- (IBAction)closeButtonClick:(id)sender {
////    if(canvas.modified)
////        [canvas saveImage:slide];
////    
////    [self.view removeFromSuperview];
//}

@end
