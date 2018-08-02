//
//  TestesGesturesViewController.h
//  testeGestures
//
//  Created by User on 07/03/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../../../HVCommon/HVCustomizedViews.h"


@interface ViewComReconhecimentoDeGestures : HVView{
    UIBezierPath * path;
    NSMutableArray * vertexes;
    NSMutableArray * points;
    int currentVertex;
    double accuracy, rot, escala;
    CGRect retangulo_escala;
    CGPoint testA, testB, testC, testD, testVertex, testE, testF;
    BOOL movingTestVertex;
    @public
        HVGesturesArea * testGesturesArea;
}

- (void)pan:(UIPanGestureRecognizer *)pan;
- (void)tap:(UITapGestureRecognizer *)tap;
+ (ViewComReconhecimentoDeGestures *)fastCreation;
+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point radius:(double)radius;
- (void)becomeActive:(UIApplication *)application;


@end

@interface TestesGesturesViewController : UIViewController{

    ViewComReconhecimentoDeGestures * view;
    HVGesturesArea * gesturesArea;
    HVImageMatrix * avisos;
}

@end
