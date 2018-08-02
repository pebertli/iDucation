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
    int randomFactor;
    int animFactor;
    int factorX;
    int factorY;
    int factorZ;

}

@property int randomFactor;
@property int factorX;
@property int factorY;
@property int factorZ;
@property int animFactor;

-(void) rangeRandom:(float) factor;
-(void)setIsEmitting:(BOOL)isEmitting;

@end
