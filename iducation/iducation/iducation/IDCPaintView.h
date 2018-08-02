//
//  PaintView.h
//  PaintingSample
//
//  Created by Sean Christmann on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVUtils.h"

@interface IDCPaintView : UIView {
    void *cacheBitmap;
    CGContextRef cacheContext;
    
    CGPoint point0;
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    
    UIColor *mainColor;

    
    CGBlendMode mode;
    
    UIImage* currentImage;
    UIImage* savedImage;
    
    BOOL modified;
}

@property BOOL modified;

//- (void) initContext:(CGSize)size;
//- (void) drawToCache;
//- (void) touchesBegan:(CGPoint) point;
//- (void) touchesMoved:(CGPoint)point;

- (void) clear;
- (void) setMainColor:(UIColor*) color;
- (void) saveImage:(NSString*) fileName;
- (void) paintWithImage:(NSString*) fileName;
- (void) enableEraser:(BOOL) enable;
@end
