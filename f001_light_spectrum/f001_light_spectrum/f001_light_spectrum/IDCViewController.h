//
//  IDCViewController.h
//  f001_light_spectrum
//
//  Created by pebertli on 8/1/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCGasParticle.h"
#import "IDCParticleFlame.h"
#import "HVGeometry.h"
#import "HVUtils.h"

@interface IDCViewController : UIViewController <UIGestureRecognizerDelegate>
{
    IDCGasParticle* gasHelium;
    IDCGasParticle* gasHydrogen;
    IDCGasParticle* gasUranium;
    IDCGasParticle* gasMercury;
    
    IDCParticleFlame* flame;
    
    IDCGasParticle* currentGas;
    UIView* currentRect;
    CGPoint currentContainer;
    
    UIView* heliumRect;
    UIView* hydrogenRect;
    UIView* uraniumRect;
    UIView* mercuryRect;
    
    CGPoint previousLocation;
    
    CGPoint bulbCenter;
    
    UIImageView* bulb;
    UIImageView* torch;
    UIImageView* torch_zero;
    UIImageView* emission;
    UIImageView* emission_below;
    UIImageView* switch_button;
    
    UIImageView* gas_set;
    UIImageView* gas_set_front;
    
    CGPoint containerHelium;
    CGPoint containerHydrogen;
    CGPoint containerUranium;
    CGPoint containerMercury;
    
}

@end
