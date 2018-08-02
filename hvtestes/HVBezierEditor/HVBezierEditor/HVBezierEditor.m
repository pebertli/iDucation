//
//  HVBezierEditor.m
//  HVBezierEditor
//
//  Created by User on 03/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import "HVBezierEditor.h"

@implementation HVBezierGrid

+ (HVBezierGrid *) fastCreationSettingSquare:(int)square{
    HVBezierGrid * grid =
    [[HVBezierGrid alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    grid->squareSize = square;
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.5, 0.5, 0.5, 0.35};
    grid->lineColor = CGColorCreate(colorspace, components);
    return grid;
}

- (void) drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, lineColor);
    int cols = rect.size.width / squareSize;
    int rows = rect.size.height / squareSize;
    for (int i=1; i<=cols; i++) {
        drawLine(context,
                 CGPointMake(i*squareSize, 0),
                 CGPointMake(i*squareSize, rect.size.height));
    }
    for (int i=1; i<=rows; i++) {
        drawLine(context,
                 CGPointMake(0, i*squareSize),
                 CGPointMake(rect.size.width,i*squareSize));
    }
    CGContextStrokePath(context);
}

@end

@implementation HVBezierEditor

+ (HVBezierEditor *) fastCreationSettingParent:(UIView *)parent{
    HVBezierEditor * editor = [[HVBezierEditor alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [editor config];
    [parent addSubview:editor];
    [editor adjustToParent];
    return editor;
}

- (void) config{
    state = HVBezierEditorStateMinimized;
    grid = [HVBezierGrid fastCreationSettingSquare:50];
    [self addSubview:grid];
    [grid adjustToParent];
    btMinimize = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btMinimize addTarget:self action:@selector(minMax)
     forControlEvents:UIControlEventTouchDown];
//    [btMinimize setTitle:@"Minimize" forState:UIControlStateNormal];
    btMinimize.frame = CGRectMake(20.0, 20.0, 80.0, 40.0);
    [self addSubview:btMinimize];
}

- (void) adjustToParent{
    [super adjustToParent];
    [self minMax];
    
}

- (void) minMax{
    if (state == HVBezierEditorStateMinimized) {
        state = HVBezierEditorStateMaximized;
        CGSize sz = self.frame.size;
        maximizeViewToFrame(grid,
                            CGPointMake(sz.width/2, sz.height/2),
                            0.5);
        [grid adjustToParent];
        [btMinimize setTitle:@"MIN" forState:UIControlStateNormal];
    }else if (state == HVBezierEditorStateMaximized) {
        state = HVBezierEditorStateMinimized;
        minimizeViewToPoint(grid, btMinimize.center, 0.75);
        [btMinimize setTitle:@"MAX" forState:UIControlStateNormal];
        
    }
}

@end
