//
//  F001_amber.h
//  F001_amber
//
//  Created by User on 13/06/13.
//  Copyright (c) 2013 iDucation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HVCustomizedViews.h"
#import "HVGeometry.h"
#import "HVUtils.h"
#import "HVToolbar.h"



@interface HVBalloon : HVAnimatedAlphaView{
    float paddingLeft;
    float paddingRight;
    float paddingTop;
    float paddingBottom;
    UIView * refView;
    HVView * internalView;
    NSMutableArray * viewsToFit;
    HVBezier * balloonBezier;
    id targetBalloonAction;
    SEL onCloseBalloon;
    SEL onShowBalloon;
}

@property CGPoint vectorBalloon;
@property CGPoint vectorRefView;
@property BOOL autoHide;
@property UIColor * bgColor;
@property UIColor * borderColor;
@property float borderWidth;

+ (HVBalloon *)balloonToView:(UIView *)_refView;
- (void)addSubview:(UIView *)view hasToFit:(BOOL)_fit;
- (void)showBalloon;
- (void)setAction:(id)_target onShowBalloon:(SEL)_show onCloseBalloon:(SEL)_close;

@end

@class F001_amberContainer;

@interface F001_amberLeaf : HVImageMatrix{
    CFTimeInterval fallDuration;
    @public
    CGPoint end;
    CGPoint direction;
    F001_amberContainer * container;
}

+ (F001_amberLeaf *) leaf;
- (void) updateAnimation;

@end

enum F001_amberContainerState {
    F001_amberContainerStateStopped,
    F001_amberContainerStateFallingLeaves,
    F001_amberContainerStateAmberDischarged,
    F001_amberContainerStateAmberCharged
    };

@interface F001_amberContainer : HVView{
    NSMutableArray * leaves;
    @public
    enum F001_amberContainerState state;
    CADisplayLink * displayLink;
    CFTimeInterval fallDuration;
    CFTimeInterval timestampAnimationStart;
    float topY;
    float baseY;
}

+ (F001_amberContainer *) fastCreationSettingParent:(UIView *)parent;
- (void)prepareToLeavesFall;
- (void)fallLeaves;

@end

@class F001_amberStone;

@interface F001_amberScene: HVView{
    CGPoint lineTie;
    float lineLength;
    float sphereLimit;
    @public
    UIImageView * line;
    F001_amberStone * stone;
    HVImageMatrix * sphere;
    CADisplayLink * displayLink;
    HVGesturesArea * stoneGA;
}

+ (F001_amberScene *)amberSceneAt:(CGPoint)_position inView:(UIView *)_parent;
- (void)setSphereProgress:(double)progress;


@end

enum F001_amberStoneState {
    F001_amberStoneInitial,
    F001_amberStoneFriction,
    F001_amberStoneDrag
};

@interface F001_amberStone: HVView{
    UIProgressView * chargeProgress;
    HVAnimatedAlphaView * bar;
    HVGesturesArea * GA;
    CFTimeInterval lastFriction;
    HVBalloon * balloon;
    HVShineView * shine;
    HVShineView * glow;
    HVShineView * shineButton3;
    HVShineView * shineButton2;
    enum F001_amberStoneState state;
    BOOL barIsVisible;
    @public
    F001_amberScene * scene;
    HVDrag * drag;
}

@property (nonatomic) double electriccharge;

+ (F001_amberStone *)amberStoneAt:(CGPoint)_pt inScene:(F001_amberScene *)_scene;
- (void)processTouchesAndCharge;

@end


