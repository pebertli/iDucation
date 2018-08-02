//
//  HVBezierEditorViewController.h
//  HVBezierEditor
//
//  Created by User on 03/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVCustomizedViews.h"
#import "HVGeometry.h"


@interface testeHVBezier : HVView{
    HVBezier * bezier;
    HVPolygon * points;
    @public
    double percentage;
}

+ (testeHVBezier *) criar;

@end

@interface HVBezierEditorViewController : UIViewController{
    @public
    UISlider * slider;
    testeHVBezier * teste;
}

@end

