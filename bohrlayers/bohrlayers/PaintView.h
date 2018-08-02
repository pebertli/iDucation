//
//  PaintView.h
//  PaintingSample
//
//  Created by Sean Christmann on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintView : UIView {
    void *cacheBitmap;
    CGContextRef cacheContext;
    float hue;
    
    CGPoint point0;
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    
    BOOL clear;
    
    UIColor *color;
}
- (void) initContext:(CGSize)size;
- (void) drawToCache;
- (void) touchesBegan:(CGPoint) point;
- (void) touchesMoved:(CGPoint)point;
@end
