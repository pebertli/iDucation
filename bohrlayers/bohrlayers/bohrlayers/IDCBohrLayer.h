//
//  IDCBohrLayer.h
//  bohrlayers
//
//  Created by pebertli on 17/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCBohrLayer : UIView
{
    UIColor* color;
    BOOL isDashed;
    float lineWidth;
}

@property (nonatomic,strong) UIColor* color;
@property (nonatomic) BOOL isDashed;
@property (nonatomic) float lineWidth;


@end
