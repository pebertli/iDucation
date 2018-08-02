//
//  HVToolbar.m
//  HVBezierEditor
//
//  Created by User on 03/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import "HVToolbar.h"
#import "HVGeometry.h"
#import "HVUtils.h"

@implementation HVIconIndex

+ (int)pencil                       { return 0; }
+ (int)bezierCurves                 { return 1; }
+ (int)bezierVertexes               { return 2; }
+ (int)bezierPointAtPercentage      { return 3; }
+ (int)bezierColapsePoints          { return 4; }
+ (int)bezierExplodeIntoPoints      { return 5; }
+ (int)bezierSmoothPoint            { return 6; }
+ (int)bezierDisjunctPoint          { return 7; }
+ (int)bezierVertexPoint            { return 8; }
+ (int)dottedRect                   { return 9; }

@end

@implementation HVToolbar

+ (HVToolbar *)fastCreationSettingImage:(UIImage *)img andButtonSize:(CGSize)size{
    HVToolbar * toolbar = [[HVToolbar alloc] init];
    [toolbar setBackgroundColor:[UIColor clearColor]];
    toolbar->image = img;
    toolbar->imageScale = 1;
    toolbar->buttonSize = size;
    toolbar->buttonMargin = 20;
    return toolbar;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) adjustToGroups{
    float m = buttonMargin;
    HVPoint * currentCenter = [HVPoint initWithCGPoint:CGPointMake(0, 0)];
    float maxHeight = 0;
    NSArray * children = [self subviews];
    for (id child in children) {
        if ([child isKindOfClass:[HVToolbarGroup class]]) {
            CGSize s = ((HVToolbarGroup *)child).frame.size;
            maxHeight = (s.height > maxHeight)?(s.height):maxHeight;
            ((HVToolbarGroup *)child).center =
            CGPointMake(currentCenter.point.x + s.width /2 + m, s.height /2);
            [currentCenter setX:(currentCenter.point.x + s.width)];
        }
    }
    
    [self setFrame:CGRectMake(0, 0, currentCenter.point.x, maxHeight)];
}

- (void)setImageScale:(float)_scale{
    imageScale = _scale;
}

- (float)getImageScale{
    return imageScale;
}

@end

@implementation HVToolbarGroup

+ (HVToolbarGroup *)fastCreationInToolbar:(HVToolbar *)toolbar{
    HVToolbarGroup * group = [[HVToolbarGroup alloc] init];
    [group setBackgroundColor:[UIColor clearColor]];
    group->toolbar = toolbar;
    [toolbar addSubview:group];
    return group;
}

- (void) adjustToButtons{
    float w = toolbar->buttonSize.width;
    float h = toolbar->buttonSize.height;
    float m = toolbar->buttonMargin;
    
    HVPoint * currentCenter = [HVPoint initWithCGPoint:CGPointMake(-m, h/2)];
    NSArray * children = [self subviews];
    for (id child in children) {
        if ([child isKindOfClass:[HVToolbarButton class]]) {
            [currentCenter sumX:(w/2)];
            [child setCenter:currentCenter.point];
            [currentCenter sumX:(w/2 + m)];
        }
    }
    
    [currentCenter sumY:(h/2)];
    [self setFrame:CGRectMake(0, 0,
                             currentCenter.point.x,
                             currentCenter.point.y)];
}

- (HVToolbarButton *) addButtonWithIconIndex:(int)iconIndex{
    HVToolbarButton * newButton = [HVToolbarButton fastCreationInGroup:self imageIndex:iconIndex];
    [self addSubview:newButton];
    [self adjustToButtons];
    [toolbar adjustToGroups];
    return newButton;
}

@end


@implementation HVToolbarButton

+ (HVToolbarButton *)fastCreationInGroup:(HVToolbarGroup *) group
                              imageIndex:(int)index{
    HVToolbarButton * button = [[HVToolbarButton alloc] init];
    button->group = group;
    [button config:group->toolbar->image];
    [button setImageScale:[button->group->toolbar getImageScale]];
    [button setMatrixCellWidth:group->toolbar->buttonSize.width
                     andHeight:group->toolbar->buttonSize.height];
    [button setIndex:index];
    UITapGestureRecognizer * tap =
    [[UITapGestureRecognizer alloc] initWithTarget:button
                                            action:@selector(didButtonTap:)];
    [tap setNumberOfTapsRequired:1];
    //UITapGestureRecognizer * tap2 =
    //[[UITapGestureRecognizer alloc] initWithTarget:button
      //                                      action:@selector(didButtonTap2:)];
    //[tap2 setNumberOfTapsRequired:2];
    button->tapRecognizer = tap;
    //button->tapRecognizer2 = tap2;
    [button addGestureRecognizer:button->tapRecognizer];
    //[button addGestureRecognizer:button->tapRecognizer2];
    //[tap1 requireGestureRecognizerToFail:tap2];
    [button setAnimLoops:1 interval:0.15 minAlpha:0.25 maxAlpha:1];
//    performSelector(button, @selector(onImageChanged));
    return button;
}

- (void)didButtonTap:(UITapGestureRecognizer *)tap{
    [self blink];
    HVlog(@"button tapped: ", currentIndex);
    performSelector(tapTarget, tap1Action);
}

//- (void)didButtonTap2:(UITapGestureRecognizer *)tap{
//    HVlog(@"duplo ", 0);
//}

- (void)setAction:(id)_target onSigleTap:(SEL)tap1 onDoubleTap:(SEL)tap2{
    tapTarget = _target;
    tap1Action = tap1;
    tap2Action = tap2;
}

@end
