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

@interface IDCAtom : UIView
{
    UIImage* art;
    CGPoint desiredPoint;
    UIImageView* imageView;
    double randomAnimationFactor;
}

@property (nonatomic) CGPoint desiredPoint;

- (id)initWithArt: (NSString*) file withSize:(CGSize) size;
- (void)doFloatAnimation:(double) elapsed;
- (void)doShakeAnimation:(double) elapsed;
@end
