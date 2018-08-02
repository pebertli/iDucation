//
//  IDCTextCategory.m
//  iducation
//
//  Created by pebertli on 04/07/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCTextHighlight.h"

@implementation IDCMarkedArea

@synthesize area;
@synthesize startColor;
@synthesize endColor;

- (id) initWithArea:(CGRect) rect startColor:(UIColor*)pStartColor encColor:(UIColor*) pEndColor
{
    if(self = [super initWithFrame:rect])
    {
        area = rect;
        self.startColor = pStartColor;
        self.endColor = pEndColor;
        self.opaque = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    CGContextSaveGState(context);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    //Gradient creation
    CGFloat r1, g1, b1, a1;
    CGFloat r2, g2, b2, a2;
    [startColor getRed: &r1 green:&g1 blue:&b1 alpha:&a1];
    [endColor getRed: &r2 green:&g2 blue:&b2 alpha:&a2];
    CGFloat comps[] = {r1,g1,b1,a1,r2,g2,b2,a2};
    CGFloat locs[] = {0,1};
    CGGradientRef g = CGGradientCreateWithColorComponents(space, comps, locs, 2);
    
    
    CGContextBeginPath(context);
    //random numbers between Margin+range
    int xStart = (arc4random()%X_RANDOM_RANGE_MARGIN_MARK_TEXT_IPAD)+floor(X_MARGIN_MARK_TEXT_IPAD/2);
    int yStart = (arc4random()%Y_RANDOM_RANGE_MARGIN_MARK_TEXT_IPAD)+floor(Y_MARGIN_MARK_TEXT_IPAD/2);
    int xVeryStart = xStart;
    int yVeryStart = yStart;
    CGContextMoveToPoint(context, xStart, yStart);
    
    //upper arest
    //number of humps based in width size
    int humpsWidth = floor((area.size.width-floor(X_MARGIN_MARK_TEXT_IPAD/2))/SLICE_HUMPS_WIDTH_MARK_TEXT_IPAD) ;
    if(humpsWidth<MINIMUM_HUMPS_WIDTH_MARK_TEXT_IPAD)
        humpsWidth = MINIMUM_HUMPS_WIDTH_MARK_TEXT_IPAD;
    //size between humps
    int humpGapWidth = floor(floor(area.size.width-floor(X_MARGIN_MARK_TEXT_IPAD/2))/humpsWidth);
    if(humpGapWidth<=0)
        humpGapWidth = 1;
    for(int countHumps = 0; countHumps<humpsWidth;countHumps++)
    {
        int xCP1 = xStart+(arc4random()%humpGapWidth);
        int yCP1 = yStart+(arc4random()%Y_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD)-floor((Y_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD-1)/2);
        int xCP2 = xStart+(arc4random()%humpGapWidth);
        int yCP2 = yStart+(arc4random()%Y_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD)-floor((Y_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD-1)/2);
        int xEnd = xStart+humpGapWidth;
        int yEnd = yStart;
        CGContextAddCurveToPoint(context, xCP1, yCP1, xCP2, yCP2, xEnd, yEnd);
        xStart = xEnd;
        yStart = yEnd;
        //won`t exceed the right margin
        if(countHumps==humpsWidth-1)
        {
            xStart = area.size.width-floor(X_MARGIN_MARK_TEXT_IPAD/2);
        }
        
    }
    
    //right arest
    int humpsHeight = floor((area.size.height-floor(Y_MARGIN_MARK_TEXT_IPAD/2))/SLICE_HUMPS_HEIGHT_MARK_TEXT_IPAD);
    if(humpsHeight<MINIMUM_HUMPS_HEIGHT_MARK_TEXT_IPAD)
        humpsHeight = MINIMUM_HUMPS_HEIGHT_MARK_TEXT_IPAD;
    //size between humps
    int humpGapHeight = floor((area.size.height-floor(Y_MARGIN_MARK_TEXT_IPAD/2))/humpsHeight);
    if(humpGapHeight<=0)
        humpGapHeight=1;
    for(int countHumps = 0; countHumps<humpsHeight;countHumps++)
    {
        
        int xCP1 = xStart+(arc4random()%X_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD)-floor((X_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD-1)/2);
        int yCP1 = yStart+(arc4random()%humpGapHeight);
        int xCP2 = xStart+(arc4random()%X_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD)-floor((X_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD-1)/2) ;
        int yCP2 = yStart+(arc4random()%humpGapHeight);
        int xEnd = xStart;
        int yEnd = yStart+humpGapHeight;
        if(countHumps==humpsHeight-1){
            yEnd =yVeryStart+area.size.height-(Y_MARGIN_MARK_TEXT_IPAD);
        }
        CGContextAddCurveToPoint(context, xCP1, yCP1, xCP2, yCP2, xEnd, yEnd);
        xStart = xEnd;
        yStart = yEnd;
        //        if(countHumps==humpsHeight-1){
        //            xStart = xEnd-((arc4random()%X_RANDOM_RANGE_MARGIN_MARK_TEXT_IPAD)+X_MARGIN_MARK_TEXT_IPAD);
        //            yStart = yEnd-(Y_MARGIN_MARK_TEXT_IPAD*2);
        //
        //        }
    }
    
    //bottom arest
    humpsWidth = floor((xStart-floor(X_MARGIN_MARK_TEXT_IPAD/2))/SLICE_HUMPS_WIDTH_MARK_TEXT_IPAD) ;
    if(humpsWidth<MINIMUM_HUMPS_WIDTH_MARK_TEXT_IPAD)
        humpsWidth = MINIMUM_HUMPS_WIDTH_MARK_TEXT_IPAD;
    //size between humps
    humpGapWidth = floor(floor(xStart-floor(X_MARGIN_MARK_TEXT_IPAD/2))/humpsWidth);
    if(humpGapWidth<=0)
        humpGapWidth = 1;
    for(int countHumps = 0; countHumps<humpsWidth;countHumps++)
    {
        
        int xCP1 = xStart-(arc4random()%humpGapWidth);
        int yCP1 = yStart+(arc4random()%Y_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD)-floor((Y_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD-1)/2);
        int xCP2 = xStart-(arc4random()%humpGapWidth);
        int yCP2 = yStart+(arc4random()%Y_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD)-floor((Y_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD-1)/2);
        int xEnd = xStart-humpGapWidth;
        int yEnd = yStart;
        //        if(countHumps==0){
        //            yEnd +=Y_MARGIN_MARK_TEXT_IPAD;
        //        }
        CGContextAddCurveToPoint(context, xCP1, yCP1, xCP2, yCP2, xEnd, yEnd);
        xStart = xEnd;
        yStart = yEnd;
        //won`t exceed the left margin
        if(countHumps==humpsWidth-1)
        {
            xStart = xVeryStart;
        }
        
    }
    
    //left arest
    humpsHeight = floor((yStart-floor(Y_MARGIN_MARK_TEXT_IPAD/2))/SLICE_HUMPS_HEIGHT_MARK_TEXT_IPAD);
    if(humpsHeight<MINIMUM_HUMPS_HEIGHT_MARK_TEXT_IPAD)
        humpsHeight = MINIMUM_HUMPS_HEIGHT_MARK_TEXT_IPAD;
    //size between humps
    humpGapHeight = floor((yStart-floor(Y_MARGIN_MARK_TEXT_IPAD/2))/humpsHeight);
    if(humpGapHeight<=0)
        humpGapHeight=1;
    for(int countHumps = 0; countHumps<humpsHeight;countHumps++)
    {
        
        int xCP1 = xStart+(arc4random()%X_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD)-floor((X_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD-1)/2);
        
        int yCP1 = yStart-(arc4random()%humpGapHeight);
        int xCP2 = xStart+(arc4random()%X_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD)-floor((X_RANDOM_RANGE_CONTROL_POINT_MARK_TEXT_IPAD-1)/2);
        int yCP2 = yStart-(arc4random()%humpGapHeight);
        int xEnd = xStart;
        int yEnd = yStart-humpGapHeight;
        CGContextAddCurveToPoint(context, xCP1, yCP1, xCP2, yCP2, xEnd, yEnd);
        xStart = xEnd;
        yStart = yEnd;
        //connect with the first point
        if(countHumps==humpsHeight-1)
        {
            xStart = xVeryStart;
            yStart = yVeryStart;
        }
        
    }
    
    //CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, g, CGPointMake(area.origin.x+floor(area.size.width/2), 0),CGPointMake(area.origin.x+floor(area.size.width/2), area.origin.y+area.size.height),0);
    CGContextDrawPath(context,kCGPathFillStroke);
}
@end
