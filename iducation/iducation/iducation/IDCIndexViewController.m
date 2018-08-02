//
//  IDCIndexViewController.m
//  iducation
//
//  Created by pebertli on 20/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCIndexViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IDCConstants.h"

@interface IDCIndexViewController ()

@end

@implementation IDCIndexViewController

@synthesize rootController;
@synthesize tableSlides;
@synthesize viewForTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rootController:(IDCRootViewController*) root
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rootController = root;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Config for round corners and shadhow under view
    //viewForTable.layer.masksToBounds = NO;
    viewForTable.layer.cornerRadius = RADIUS_CORNER_VIEW;
    viewForTable.layer.shadowOffset = CGSizeMake(OFFSET_SHADOW_VIEW, OFFSET_SHADOW_VIEW);
    viewForTable.layer.shadowRadius = RADIUS_SHADOW_VIEW;
    viewForTable.layer.shadowOpacity = OPACITY_SHADOW_VIEW;
    viewForTable.layer.shadowPath = [UIBezierPath bezierPathWithRect:viewForTable.bounds].CGPath;
    
    //verify if the rootController is properly delegate for tableslides
    if([rootController conformsToProtocol:@protocol(UITableViewDataSource)])
    {
        [self.tableSlides setDataSource:rootController];
    }
    
    if([rootController conformsToProtocol:@protocol(UITableViewDelegate)])
    {
        [self.tableSlides setDelegate:rootController];
    }
    
    tableSlides.rowHeight = HEIGHT_CELL_TABLE_IPAD;
    
    //associate a nib to a cell identifier
    UINib *nib = [UINib nibWithNibName:@"IDCIndexCell" bundle:nil];
    static NSString* simpleTableIndentifier = @"IDCIndexCellIdentifier";
    [tableSlides registerNib:nib forCellReuseIdentifier:simpleTableIndentifier];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
