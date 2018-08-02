//
//  IDCParticleDrone.h
//  dalton.combinations
//
//  Created by pebertli on 11/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "HVParticleSystem.h"

@interface IDCParticleTrail : HVParticleSystem
{
    CGRect visualFrame;
    BOOL emitting;
}

@property BOOL emitting;
@property CGRect visualFrame;

-(void)setIsEmitting:(BOOL)isEmitting;
-(void)setEmitterPositionFromTouch: (UITouch*) t;

@end
