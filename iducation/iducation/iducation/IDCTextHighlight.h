//
//  IDCTextCategory.h
//  iducation
//
//  Created by pebertli on 04/07/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCConstants.h"


@interface IDCMarkedArea : UIView{
    CGRect area;
    UIColor* startColor;
    UIColor* endColor;
}
@property (nonatomic) CGRect area;
@property (nonatomic) UIColor* startColor;
@property (nonatomic) UIColor* endColor;

- (id) initWithArea:(CGRect) rect startColor:(UIColor*)pStartColor encColor:(UIColor*) pEndColor;

@end
