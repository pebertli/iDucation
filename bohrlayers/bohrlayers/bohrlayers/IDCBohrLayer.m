//
//  IDCBohrLayer.m
//  bohrlayers
//
//  Created by pebertli on 17/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCBohrLayer.h"
#import <QuartzCore/QuartzCore.h>

@implementation IDCBohrLayer

@synthesize color;
@synthesize lineWidth;
@synthesize isDashed;


static CGFloat const kDashedBorderWidth     = (2.0f);
static CGFloat const kDashedPhase           = (0.0f);
static CGFloat const kDashedLinesLength[]   = {4.0f, 2.0f};
static size_t const kDashedCount            = (2.0f);


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0 ];
        color = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.8];
        isDashed = NO;
        lineWidth = 2.0;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
//    [super drawRect:rect];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGRect newRect = rect;
    newRect.size.width-=lineWidth;
    newRect.size.height-=2;
    newRect.origin.x+=lineWidth/2;
    newRect.origin.y+=lineWidth/2;
    
    if(isDashed)
        CGContextSetLineDash(context, kDashedPhase, kDashedLinesLength, kDashedCount) ;
    
    CGContextAddEllipseInRect(context, newRect);
    CGContextStrokePath(context);
    

}

@end
