//
//  HVParticle.h
//  dalton.combinations
//
//  Created by pebertli on 04/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HVUtils.h"

@interface HVParticleSystem : UIView
{
    CAEmitterLayer* viewLayer;
}

@property (nonatomic, strong) CAEmitterLayer* viewLayer;

@end
