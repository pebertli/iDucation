//
//  IDCDaltonViewController.h
//  dalton.combinations
//
//  Created by pebertli on 22/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import "IDCNature.h"
#import "HVUtils.h"
#import "HVGeometry.h"
#import "HVParticleSystem.h"

@interface IDCDaltonViewController : UIViewController <UIGestureRecognizerDelegate>
{
    CADisplayLink* displayLink;
    BOOL workComplete;
    IDCNature* nature;
    double lastTimeStamp;
    double timeSinceLastUpdate;
    UIView* fadeView;
    BOOL alphaAnimation;
    NSTimer* atomTouchedTimer;
    UIImageView* cross;
    
    UIImageView* flash;
    
    BOOL combinating;
    
    HVParticleSystem* particle1;
}

@end
