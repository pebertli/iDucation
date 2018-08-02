//
//  IDCTopBarViewController.m
//  iducation
//
//  Created by pebertli on 20/03/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCTopBar.h"
#import "IDCConstants.h"

@implementation IDCTopBar

@synthesize textSelection;
@synthesize themesList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.6f alpha:1.0f];
//        self.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:SIZE_FONT_NOTE_VIEW_IPAD];
        CGRect frameButton = frame;
        frameButton.origin.x = frame.size.width-150;
        frameButton.origin.y = 0;
        
        frameButton.size.width = 150;
        
        textSelection = [[UIButton alloc] initWithFrame:frameButton];
        [textSelection setTitle:@"Text Selection" forState:UIControlStateNormal];
        [textSelection setTitle:@"Text Selection" forState:UIControlStateSelected];
        [textSelection setImage:[UIImage imageNamed:@"checked_box.png"] forState:UIControlStateSelected];
        [textSelection setImage:[UIImage imageNamed:@"unchecked_box.png"] forState:UIControlStateNormal];
        textSelection.backgroundColor = [UIColor colorWithRed:1.0f green:0.4f blue:0.6f alpha:0.0f];  [self addSubview:textSelection];
        textSelection.imageEdgeInsets = UIEdgeInsetsMake(2, -5, 2, 5);
        textSelection.showsTouchWhenHighlighted = YES;
        //textSelection.titleEdgeInsets= UIEdgeInsetsMake(2, 5, 2, 5);
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    CGContextSaveGState(context);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    //Gradient creation
    CGFloat comps[] = {R_COLOR_GRADIENT_START_TOPBAR_THEME_DEFAULT,G_COLOR_GRADIENT_START_TOPBAR_THEME_DEFAULT,B_COLOR_GRADIENT_START_TOPBAR_THEME_DEFAULT,A_COLOR_GRADIENT_START_TOPBAR_THEME_DEFAULT,R_COLOR_GRADIENT_END_TOPBAR_THEME_DEFAULT,G_COLOR_GRADIENT_END_TOPBAR_THEME_DEFAULT,B_COLOR_GRADIENT_END_TOPBAR_THEME_DEFAULT,A_COLOR_GRADIENT_END_TOPBAR_THEME_DEFAULT};
    CGFloat locs[] = {0,1};
    CGGradientRef g = CGGradientCreateWithColorComponents(space, comps, locs, 2);
    
    CGContextDrawLinearGradient(context,
                                g,
                                CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)),
                                CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)),
                                0);
    
    CGColorSpaceRelease(space);
    CGContextRestoreGState(context);
}

@end
