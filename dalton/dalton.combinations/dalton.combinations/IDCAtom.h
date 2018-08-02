//
//  IDCAtom.h
//  dalton.combinations
//
//  Created by pebertli on 22/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HVGeometry.h"
#import "HVUtils.h"
#import "IDCParticleDrone.h"
#import "HVCustomizedViews.h"
#import "IDCConstants.h"
#import "HVAudioVideo.h"

enum {
    IDCAtomStateNormal = 0,
    IDCAtomStateTouched = 1,
    IDCAtomStateCombinated = 2,
    IDCAtomStateCombinating = 3,
    //IDCAtomState = 3
};
typedef NSUInteger     IDCAtomState;

@interface IDCAtom : UIView
{
    NSString *element;
    IDCAtomState state;
    UIImage* art;
    CGPoint desiredPoint;
    CGPoint originalPoint;
    UIImageView* imageView;
    UIImageView* glowView;
    UIImageView* flashView;
    double randomAnimationFactor;
    BOOL touch;
    double currentAnimationTime;
    HVAudio* energizedSound;
    
    double delay;
    
    NSMutableArray* energyParticles;
    
    UIImageView* spark;
    
    BOOL hasParent;
    float angle;
}

@property (strong, nonatomic) UIImageView* glowView;
@property (nonatomic) IDCAtomState state;
@property (nonatomic) CGPoint desiredPoint;
@property (nonatomic) CGPoint originalPoint;
@property (nonatomic) BOOL touch;
@property (nonatomic) double currentAnimationTime;
@property (nonatomic) double delay;
@property (nonatomic, strong) HVAudio* energizedSound;
@property (nonatomic) BOOL hasParent;
@property (nonatomic) float angle;

- (id)initWithElement: (NSString*) symbol scale:(float) scale;
- (void)doFloatAnimation:(double) elapsed;
- (void)doShakeAnimation:(double) elapsed;
- (void) doCombinationAnimation:(double) timeSinceLastUpdate;
- (void) doGlowingAnimation:(double) elapsed;
- (void) doEnergyAnimation:(double) elapsed;
- (void) resetImageAtCenter;
- (void) pauseEnergyParticles:(BOOL) pause;
@end
