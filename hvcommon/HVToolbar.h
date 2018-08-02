//
//  HVToolbar.h
//  HVBezierEditor
//
//  Created by User on 03/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVCustomizedViews.h"

@class HVToolbarButton;

@interface HVToolbar : UIView{
    float imageScale;
    @public
    UIImage * image;
    CGSize buttonSize;
    float buttonMargin;
}

+ (HVToolbar *)fastCreationSettingImage:(UIImage *)img andButtonSize:(CGSize)size;
- (void)setImageScale:(float)_scale;
- (float)getImageScale;

@end

@interface HVToolbarGroup : UIView{
    @public
    HVToolbar * toolbar;
}

+ (HVToolbarGroup *)fastCreationInToolbar:(HVToolbar *)toolbar;
- (HVToolbarButton *)addButtonWithIconIndex:(int)iconIndex;

@end

@interface HVToolbarButton : HVImageMatrix{
    HVToolbarGroup * group;
    UITapGestureRecognizer * tapRecognizer;
    id tapTarget;
    SEL tap1Action;
    SEL tap2Action;
}

+ (HVToolbarButton *)fastCreationInGroup:(HVToolbarGroup *) group
                              imageIndex:(int)index;
- (void)setAction:(id)_target onSigleTap:(SEL)tap1 onDoubleTap:(SEL)tap2;

@end

@interface HVIconIndex : NSObject 
+ (int)pencil;
+ (int)bezierCurves;
+ (int)bezierVertexes;
+ (int)bezierPointAtPercentage;
+ (int)bezierColapsePoints;
+ (int)bezierExplodeIntoPoints;
+ (int)bezierSmoothPoint;
+ (int)bezierDisjunctPoint;
+ (int)bezierVertexPoint;
+ (int)dottedRect;
@end
