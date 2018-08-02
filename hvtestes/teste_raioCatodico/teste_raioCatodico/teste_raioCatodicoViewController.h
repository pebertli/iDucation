//
//  teste_raioCatodicoViewController.h
//  teste_raioCatodico
//
//  Created by User on 08/04/13.
//  Copyright (c) 2013 iDucation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVCustomizedViews.h"
#import "HVGeometry.h"

@interface teste_raioCatodicoView : HVView{
    CGPoint s;
    CGPoint e;
    CGPoint cp1;
    CGPoint cp2;
    
}

@end

@interface teste_raioCatodicoViewController : UIViewController{
    teste_raioCatodicoView * raio;
    UIView * estrelas;
    UIView * estrelas_container;
    double pos;
    CGPoint ref;
    CGSize tam;
    CALayer *_maskingLayer;
    CGPoint A;
    CGPoint B;
    
}

@end

@interface IDCRay : UIView{
    HVBezier * bezier;
}



@end
