//
//  IDCViewController.h
//  bohrlayers
//
//  Created by pebertli on 17/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IDCBohrLayer.h"
#import "HVUtils.h"
#import "PaintView.h"
#import "IDCParticleTrail.h"

typedef enum {
    kStable = 0,
    kLeavingFirstLayer = 1
} EletronState;

@interface IDCViewController : UIViewController
{
    UIImageView* nucleus;
    UIImageView* eletron1;
    UIImageView* eletron2;
    UIImageView* eletronAnimated1;
    UIImageView* eletronAnimated2;
    
    UIImageView* flareBlue;
    UIImageView* flareRed;
    
    NSMutableArray* layers;
    
    //PaintView* trailView;
    
    CADisplayLink* displayLink;
    BOOL workComplete;
    HVVelocity* velocityUpdater1;
    HVVelocity* velocityUpdater2;
    
    CGPoint initialTouch;
    double timeInitialTouch;
    CGPoint finalTouch;
    
    EletronState eletronState;
    CGPoint eletronShakePoint;
    
    NSMutableArray* frames ;
    NSMutableArray* framesInvert ;
    
    float accLap;
    int currentLayer;
    int lastLayer;
    
    IDCParticleTrail* particleTrail;
}

@end
