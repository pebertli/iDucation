//
//  IDCAtom.h
//  dalton.combinations
//
//  Created by pebertli on 22/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVGeometry.h"
#import "HVUtils.h"

enum {
    IDCAtomStateNormal = 0,
    IDCAtomStateEnergized = 1
};
typedef NSUInteger     IDCAtomState;

@interface IDCAtom : UIView
{
    UIImage* art;
    CGPoint desiredPoint;
    UIImageView* imageView;
    double randomAnimationFactor;
    double currentAnimationTime;
    
    IDCAtomState state;
    
}

@property (nonatomic) CGPoint desiredPoint;
@property (nonatomic) IDCAtomState state;

- (id)initWithArt: (NSString*) file withSize:(CGSize) size;
- (void)doFloatAnimation:(double) elapsed;
- (void)doShakeAnimation:(double) elapsed;
- (void) doCombinationAnimation:(double) timeSinceLastUpdate;
@end
