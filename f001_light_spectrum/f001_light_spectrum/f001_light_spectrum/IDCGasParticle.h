//
//  IDCParticleDrone.h
//  dalton.combinations
//
//  Created by pebertli on 11/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "HVParticleSystem.h"

@interface IDCGasParticle : HVParticleSystem
{
//    UIView* rect;
}

//@property (nonatomic,strong) UIView* rect;

- (id)initWithFrame:(CGRect)frame color:(UIColor*) color;
-(void)setIsEmitting:(BOOL)isEmitting;
-(void)setEmitterPositionFromTouch: (UITouch*)t;
- (void) setEmitterPosition: (CGPoint) p;

@end
