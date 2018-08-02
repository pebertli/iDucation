//
//  IDCViewController.h
//  eletron_energy
//
//  Created by pebertli on 27/09/13.
//  Copyright (c) 2013 com.handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVUtils.h"
#import "HVGeometry.h"
#import "IDCParticleDrone.h"

@interface IDCViewController : UIViewController
{
    UIImageView* eletron;
    UIImageView* nucleus;
    
    CADisplayLink* displayLink;
    BOOL workComplete;
    HVVelocity* velocityEletron;
    HVVelocity* velocityRadius;
    
    IDCParticleDrone* particle;
}

@end
