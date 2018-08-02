//
//  HVThumbnail.m
//  iducation
//
//  Created by pebertli on 11/07/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "HVThumbnail.h"
#import "HVUtils.h"

@implementation HVThumbnail

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame thumbnail:(NSString*) file
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        self.autoresizesSubviews = YES;
        state = HVTHUMBNAIL_STATE_MINIMIZED;
        thumbnailViewFrame = frame;
        
        UIImage* thumbnailImage = [UIImage imageNamed:file];
        
        thumbnail = [[UIImageView alloc] initWithImage:thumbnailImage];
        thumbnail.frame = [self convertRect:frame fromView:thumbnail];
        
        HVShineView* shine = [HVShineView fastCreationSettingParent:thumbnail];
        [shine setShineWithDefaultLinearGradient:
         [UIColor colorWithRed:1 green:1 blue:1 alpha:0.65]];
        [shine setMaskImage:thumbnailImage];
        
        [self addSubview:thumbnail];
        
        mainView = nil;
        mainViewFrame = CGRectMake(0, 0, 768, 1024);
        
        self.userInteractionEnabled = YES;
        thumbnail.userInteractionEnabled = NO;
        shine.userInteractionEnabled = NO;
        
        returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        //returnButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [returnButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
        [returnButton addTarget:self action:@selector(pressedReturnButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)pressedReturnButton:(UIButton *)sender
{
    [self animateToThumbnail];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//  [super touchesBegan:touches withEvent:event];
    if(state == HVTHUMBNAIL_STATE_MINIMIZED)
        [self animateToMainView];
    else
        [self.nextResponder touchesBegan:touches withEvent:event];
        
}

- (void) setMainViewWithView:(UIView*) view frame:(CGRect) rect
{
    mainView = view;
    mainViewFrame = rect;
    
}

- (void) animateToMainView
{
    if(mainView && self.superview)
    {
        self.autoresizesSubviews = YES;
    [self addSubview:mainView];
    [self bringSubviewToFront:mainView];
    [self.superview bringSubviewToFront:self];
    [self addSubview:returnButton];
        returnButton.alpha = 1;
    //animateViewBySetFrame(mainView, thumbnail.frame, [self convertRect:CGRectMake(0, 0, 768, 1024) fromView:nil], 1);
        self.frame = [self convertRect:thumbnail.frame toView:nil];
        mainView.frame = [self convertRect:thumbnail.frame toView:self];
    animateViewBySetFrameAndAlpha(self, mainViewFrame,1, 1, NO);
        state = HVTHUMBNAIL_STATE_MAXIMIZED;
    }
}
- (void) animateToThumbnail
{
    if(mainView && self.superview)
    {
        //[self addSubview:mainView];
//        [self bringSubviewToFront:mainView];
//        [self.superview bringSubviewToFront:self];
//        [self addSubview:returnButton];
        //self.frame = [self convertRect:thumbnail.frame toView:nil];
        returnButton.alpha = 0;
        self.autoresizesSubviews = NO;
        self.frame = thumbnailViewFrame;
        mainView.frame = CGRectMake(-thumbnailViewFrame.origin.x, -thumbnailViewFrame.origin.y, mainViewFrame.size.width, mainViewFrame.size.height);
        
        animateViewBySetFrameAndAlpha(mainView, CGRectMake(0, 0, thumbnailViewFrame.size.width, thumbnailViewFrame.size.height),1, 1, YES);
        state = HVTHUMBNAIL_STATE_MINIMIZED;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
