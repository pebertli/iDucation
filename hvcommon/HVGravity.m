//
//  HVGravity.m
//  teste_Gravity
//
//  Created by User on 14/06/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import "HVGravity.h"

@implementation HVGravityUniverse

@synthesize gravityFactor;
@synthesize frictionFactor;
@synthesize electromagneticField;

+ (HVGravityUniverse *)fastCreation{
    HVGravityUniverse * universe = [[HVGravityUniverse alloc] init];
    universe.frictionFactor = 1;
    universe.gravityFactor = 10;
    universe->bodies = [NSMutableArray array];
    universe.electromagneticField = NO;
    universe.enableMoviment = NO;
//    universe->timer = [NSTimer scheduledTimerWithTimeInterval:(0.25)
//                                                       target:universe
//                                                     selector:@selector(moveBodies)
//                                                     userInfo:nil
//                                                      repeats:YES];
    return universe;
}

- (BOOL)enableMoviment{
    return self.enableMoviment;
}

- (void)setEnableMoviment:(BOOL)enableMoviment{
    
}

- (void)moveBodies{
    for (int i=0; i<[bodies count]; i++) {
        HVGravityBody * body = [bodies objectAtIndex:i];
        [body move];
    }
}

- (void)addBody:(HVGravityBody *)body{
    [bodies addObject:body];
    body.universe = self;
}

- (CGPoint)forcesReceivedBy:(HVGravityBody *)body at:(CGPoint)point{
    HVPoint * vectorAux = [HVPoint initWithCGPoint:CGPointMake(0, 0)];
    for (int j=0; j<[bodies count]; j++) {
        HVGravityBody * bodyJ = (HVGravityBody *)[bodies objectAtIndex:j];
        if (body == bodyJ) { continue; }
        CGPoint vector = gravityForce(bodyJ, bodyJ.center, body, point);
        [vectorAux sumVector:vector];
    }
    return vectorAux.point;
}

- (void)calculateForces{
    HVPoint * vectorAux = [HVPoint initWithCGPoint:CGPointMake(0, 0)];
    for (int i=0; i<[bodies count]; i++) {
        [vectorAux setX:0];
        [vectorAux setY:0];
        HVGravityBody * bodyI = [bodies objectAtIndex:i];
        for (int j=0; j<[bodies count]; j++) {
            if (i == j) { continue; }
            HVGravityBody * bodyJ = (HVGravityBody *)[bodies objectAtIndex:j];
            CGPoint vector = gravityForce(bodyJ, bodyJ.center, bodyI, bodyI.center);
            [vectorAux sumVector:vector];
        }
        bodyI.vector = vectorAux.point;
        //NSLog(@"vector x: %0.02f   y: %0.02f", bodyI.vector.x, bodyI.vector.y);
    }
    //performSelector(target, actionAfterCalculateForces);
}

//- (void)setActions:(id)_target afterCalculateForces:(SEL)_action{
//    target = _target;
//    actionAfterCalculateForces = _action;
//}

- (void)drawForces:(CGContextRef)context{
    for (int i=0; i<[bodies count]; i++) {
        HVGravityBody * body = [bodies objectAtIndex:i];
        CGPoint vectorEnd = sumVectors(body.center, body.vector);
        //drawLine(context, body.center, vectorEnd);
        drawCircle(context, body.center, body.mass);
        //drawTrianguleIsosceles(context, vectorEnd, 10, 15, angleOfSegment(vectorEnd, body.center));
        drawArrow(context, body.center, vectorEnd, 15);
    }
}

@end

@implementation HVGravityBody
@synthesize fixed;
@synthesize vector;
@synthesize mass;
@synthesize universe;
/*
- (BOOL)fixed{
    return self.fixed;
}

- (void)setFixed:(BOOL)fixed{
    if (fixed) {
        HVlog(@"body is fixed ", 0);
    }else{
        HVlog(@"body is NOT fixed ", 0);
    }
}
*/

- (CGPoint)center{
    return center.point;
}

- (void)setCenter:(CGPoint)_center{
    [center setPoint:_center];
}

+ (HVGravityBody *)body{
    HVGravityBody * body = [[HVGravityBody alloc] init];
    body->center = [HVPoint initWithCGPoint:CGPointZero];
    [body setCenter:CGPointZero];
    body.mass = 3;
    return body;
}

- (void)verify:(float)_factor{
    CGPoint possibleCenter = sumVectors(self.center,multiplyVector(_factor,vector));
    if (_factor < 0.001) { return; }
    double currentModulus = vectorModulus(vector);
    CGPoint newVector = [universe forcesReceivedBy:self at:possibleCenter];
    double newModulus = vectorModulus(newVector);
    if ((newModulus > currentModulus) || (currentModulus < 100)) {
        [self setCenter:possibleCenter];
        HVlog(@"newModulus: ", newModulus);
    }else{
        [self verify:(_factor * 0.25)];
    }
}

- (void)move{
    if (fixed) { return; }
    //[self setCenter:sumVectors(self.center, vector)];
    [self verify:0.125];
}


@end

CGPoint gravityForce(HVGravityBody * b1, CGPoint b1Center,
                     HVGravityBody * b2, CGPoint b2Center){
    float gFactor = b1.universe.gravityFactor;
    float dist = distance(b1Center, b2Center);
    //if (dist < 1) { return CGPointZero; }
    //dist = dist < 1 ? 1 : dist;
//    float modulus = gFactor * b1.mass * b2.mass / pow(dist, 2);
    float modulus = gFactor * b1.mass * b2.mass / (0.125 * dist);
    //float modulus = gFactor * b1.mass * b2.mass * (functionGaussian(0.0025*dist));
    double angle = angleOfSegment(b2Center, b1Center);
    if (b1.universe.electromagneticField) {
        angle = angleOfSegment(b1Center, b2Center);
    }
    //HVlog(@"modulus: ", modulus);
    CGPoint vector = pointAround(CGPointZero, modulus, angle);
//    NSLog(@"vector x: %0.02f   y: %0.02f", vector.x, vector.y);
    return vector;
                                                   
}

double vectorModulus(CGPoint V){
    return distance(CGPointZero, V);
}


