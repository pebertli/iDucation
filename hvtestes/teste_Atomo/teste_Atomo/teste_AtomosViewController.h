//
//  teste_AtomosViewController.h
//  teste_Atomo
//
//  Created by User on 26/04/13.
//  Copyright (c) 2013 iDucation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HVCustomizedViews.h"
#import "HVUtils.h"

@interface IDCAtom : UIView{
    HVImageMatrix * atom;
    NSMutableArray * electrons;
    double d;
    CADisplayLink * displayLink;
    UIBezierPath * path;
    double duration;
    CFTimeInterval timestampStart;
    BOOL isAnimating;
}

+ (IDCAtom *) atomWithImage:(NSString *)imageName;
- (void) setNumberOfElectrons:(int)num;

@end

@interface IDCElectron : UIView{
    NSTimer * timer;
    double direction;
    HVImageMatrix * electron;
    double d;
}

+ (IDCElectron *) electronWithRadius:(double)radius;
- (void) setAngle:(double)angle;
- (void) anim;

@end

@interface teste_AtomosViewController : UIViewController


@end


