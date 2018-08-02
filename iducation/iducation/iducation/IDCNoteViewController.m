//
//  IDCTextViewController.m
//  iducation
//
//  Created by pebertli on 2/25/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCNoteViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IDCConstants.h"

@interface IDCNoteViewController ()

@end

@implementation IDCNoteViewController

@synthesize noteView;
@synthesize containerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithNoteViewFrame:(CGRect) frame
{
    self = [super init];
    if (self) {
        containerView = [[UIView alloc] initWithFrame:frame];
        containerView.backgroundColor = [UIColor colorWithRed:0.3 green:0.7 blue:0.5 alpha:1];
        //Config for round corners and shadow under view
        containerView.layer.cornerRadius = RADIUS_CORNER_VIEW;
        containerView.layer.shadowOffset = CGSizeMake(OFFSET_SHADOW_VIEW, OFFSET_SHADOW_VIEW);
        containerView.layer.shadowRadius = RADIUS_SHADOW_VIEW;
        containerView.layer.shadowOpacity = OPACITY_SHADOW_VIEW;
        containerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:containerView.bounds].CGPath;
        [self.view addSubview:containerView];
        
        noteView = [[IDCNoteView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        noteView.layer.cornerRadius = RADIUS_CORNER_VIEW;
        noteView.delegate = self;
        noteView.userInteractionEnabled = YES;
        
        [containerView addSubview:noteView];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [noteView setNeedsDisplay];
}


@end
