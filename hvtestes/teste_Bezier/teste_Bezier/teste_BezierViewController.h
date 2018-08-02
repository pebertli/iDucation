//
//  teste_BezierViewController.h
//  teste_Bezier
//
//  Created by User on 19/04/13.
//  Copyright (c) 2013 HandVerse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVGeometry.h"
#import "HVCustomizedViews.h"


@interface teste_Bezier : UIView{
    CGPoint A;
    CGPoint B;
    CGPoint Control;
    CGPoint linha;
    UISlider * percentage_slider;
    UISlider * percentage_slider2;
    UILabel * comprimento;
    UILabel * dist_intersecao;
    
    CGPoint P1,P1C,P2,P2C,P2C_,P3,P3C,X,Y,XC,YC;
    HVDot * dotControl;
    HVDot * dotA;
    HVDot * dotB;
    HVDot * dotX;
    HVDot * dotY;
    HVDot * dotXC;
    HVDot * dotYC;
    HVDot * dotP1;
    HVDot * dotP1C;
    HVDot * dotP2;
    HVDot * dotP2C;
    HVDot * dotP2C_;
    HVDot * dotP3;
    HVDot * dotP3C;
    HVDot * dotLinha;
}

+ (teste_Bezier *)fastCreation;

@end

@interface teste_BezierViewController : UIViewController

@end
