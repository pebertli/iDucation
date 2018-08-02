//
//  F001_rutherfordViewController.m
//  F001_rutherford
//
//  Created by User on 22/05/13.
//  Copyright (c) 2013 iDucation. All rights reserved.
//

#import "F001_rutherfordViewController.h"

@interface F001_rutherfordViewController ()

@end

@implementation F001_rutherfordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    F001_rutherfordContainer * rutherford =
    [F001_rutherfordContainer fastCreationSettingParent:self.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
