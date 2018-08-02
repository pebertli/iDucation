//
//  IDCViewController.h
//  f001_friction_object
//
//  Created by pebertli on 04/10/13.
//  Copyright (c) 2013 com.handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVCustomizedViews.h"
#import "IDCAtom.h"

@interface IDCViewController : UIViewController <UIGestureRecognizerDelegate>
{
    UIImageView* positive;
    UIImageView* positiveGlow;
    
    BOOL workComplete;
    CADisplayLink* displayLink;
    
    HVPixelatedImage* pixelated;
    
    NSMutableArray* atoms;
    NSArray* eletronsPosition;
    
    NSDate* lastTouchOutside;
    
    int countTouch;
    int currentIndex;
    
    CGPoint firstTouch;
    
    CGPoint currentTouch;
    
    double distanceTouch;
    CGPoint directionObject;
    BOOL moving;
    
    BOOL justFilled;
    
    CGPoint lastPanPoint;
    
}

@end
