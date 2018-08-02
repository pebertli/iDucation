//
//  F001_rutherford.h
//  F001_rutherford
//
//  Created by User on 22/05/13.
//  Copyright (c) 2013 iDucation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "HVCustomizedViews.h"
#import "HVGeometry.h"
#import "HVUtils.h"

@class F001_rutherfordContainer;

@interface F001_rutherfordRay : HVView{
    F001_rutherfordContainer * container;
    HVBezier * bezier;
    double factor;
}

+ (F001_rutherfordRay *) fastCreation:(F001_rutherfordContainer *)parent;
- (void)setMinReflectionAngle:(double)min maxReflectionAngle:(double)max;
- (void)play;

@end

@interface F001_rutherfordContainer : HVView{
    UIImageView * scene;
    UIImageView * machine;
    UIImageView * machineShine;
    UIImageView * gold_01;
    UIImageView * gold_02;
    CADisplayLink * displayLink;
    CFTimeInterval lastTimestamp;
    CFTimeInterval cycleTime;
    double progress;
    BOOL machineActive;
    HVAnimatedAlphaView * machineShineBlink;
    HVDot * dotMachine;
    CGPoint machinePosition;
    HVGesturesArea * gestureArea;
    @public
        CGPoint startPoint;
        CGPoint reflectionPoint;
        CGPoint endPoint;
        double minReflectionAngle;
        double maxReflectionAngle;
}

+ (F001_rutherfordContainer *) fastCreationSettingParent:(UIView *)parent;
- (void) displayLinkCalled:(CADisplayLink *)sender;
- (void) tap;

@end
