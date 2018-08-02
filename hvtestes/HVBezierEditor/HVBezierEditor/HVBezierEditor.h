//
//  HVBezierEditor.h
//  HVBezierEditor
//
//  Created by User on 03/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVCustomizedViews.h"
#import "HVGeometry.h"
#import "HVUtils.h"


enum HVBezierEditorState {
    HVBezierEditorStateMinimized,
    HVBezierEditorStateMaximized
};


@interface HVBezierGrid : HVView{
    int squareSize;
    CGColorRef lineColor;
}

+ (HVBezierGrid *) fastCreationSettingSquare:(int)square;

@end


@interface HVBezierEditor : HVView{
    enum HVBezierEditorState state;
    HVBezierGrid * grid;
    UIButton * btMinimize;
}

+ (HVBezierEditor *) fastCreationSettingParent:(UIView *)parent;

@end
