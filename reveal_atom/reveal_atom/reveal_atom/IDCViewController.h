//
//  IDCViewController.h
//  reveal_atom
//
//  Created by pebertli on 5/2/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVGeometry.h"
#import "IDCAtom.h"
#import "iCarousel.h"
#import "HVCustomizedViews.h"

@interface IDCViewController : UIViewController <UIGestureRecognizerDelegate, iCarouselDataSource, iCarouselDelegate>
{
    UIImageView* diamond;
    UIImageView* hand;
    UIImageView* ring;
//    SVGKLayeredImageView* diamond;
//    SVGKLayeredImageView* hand;
//    SVGKLayeredImageView* ring;
    CGFloat lastScale;
    UIView* zoomContainer;
    UIView* atomContainer;
    UIView* atomDiamondContainer;
    UIView* atomHandContainer;
    UIView* atomRingContainer;
    UIView* lastContainer;
    BOOL workComplete;
    CADisplayLink* displayLink;
    NSMutableArray* atoms;
    CGPoint savedLocation;
    NSMutableArray* images;
    iCarousel* carouselContainer;
    
}

@end
