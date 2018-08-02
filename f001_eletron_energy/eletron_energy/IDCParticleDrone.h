//
//  IDCParticleDrone.h
//  dalton.combinations
//
//  Created by pebertli on 11/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "HVParticleSystem.h"

@interface IDCParticleDrone : HVParticleSystem
{
    BOOL emitting;
}

@property BOOL emitting;

-(void)setIsEmitting:(BOOL)isEmitting;
-(void)setEmitterPosition: (CGPoint) p;

@end
