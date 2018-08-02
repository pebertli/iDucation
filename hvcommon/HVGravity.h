//
//  HVGravity.h
//  teste_Gravity
//
//  Created by User on 14/06/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HVGeometry.h"
#import "HVUtils.h"

@class HVGravityBody;

@interface HVGravityUniverse : NSObject{
    NSMutableArray * bodies;
    NSTimer * timer;
//    id target;
//    SEL actionAfterCalculateForces;
}

@property float gravityFactor; // gravity constant
@property float frictionFactor; // friction constant
@property BOOL electromagneticField;
@property BOOL enableMoviment;

+ (HVGravityUniverse *)fastCreation;
- (void)addBody:(HVGravityBody *)body;
- (void)calculateForces;
- (void)moveBodies;
- (void)drawForces:(CGContextRef)context;
- (CGPoint)forcesReceivedBy:(HVGravityBody *)body at:(CGPoint)point;
//- (void)setActions:(id)_target afterCalculateForces:(SEL)_action;

@end

@interface HVGravityBody : NSObject{
    UIView * body;
    HVPoint * center;
}
@property BOOL fixed;
@property CGPoint vector;
@property (readonly) CGPoint center;
@property float mass;
@property HVGravityUniverse * universe;

+ (HVGravityBody *)body;
- (void)setCenter:(CGPoint)_center;
- (void)move;

@end

CGPoint gravityForce(HVGravityBody * b1, CGPoint b1Center,
                     HVGravityBody * b2, CGPoint b2Center);
double vectorModulus(CGPoint V);
