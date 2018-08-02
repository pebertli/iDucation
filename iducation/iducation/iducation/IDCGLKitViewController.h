//
//  IDCGLKitViewController.h
//  iducation
//
//  Created by pebertli on 09/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "UtilityModelManager.h"
#import "UtilityModel.h"

@interface IDCGLKitViewController : GLKViewController <UIGestureRecognizerDelegate>
{
    UtilityModelManager* modelManager;
    UtilityModel* model;
    
    GLKVector3 cameraPosition;
    GLKVector3 cameraLookAt;
    
    CGPoint velocity;
    
    float slerpAnimationTime;
    float scalePinch;
    
    bool animation_back;
    bool animation_swipe;
    
    GLKQuaternion quaternion_base;
    GLKQuaternion quaternion_base_a;
    GLKQuaternion quaternion_base_o;
    
    CGRect originalFrame;
    NSString* list;
    NSArray* models;
    
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) UtilityModelManager* modelManager;
@property (strong, nonatomic) UtilityModel* model;

- (id) initWithFrame: (CGRect) frame modelList:(NSString*) listName modelNames:(NSArray*) array ;
@end
