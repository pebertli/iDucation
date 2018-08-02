//
//  teste_PixelColorsViewController.h
//  teste_PixelColors
//
//  Created by User on 22/04/13.
//  Copyright (c) 2013 HandVerse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVCustomizedViews.h"
#import "HVGeometry.h"

@interface HVImage : HVImageMatrix{
    UIView * cor;
    NSMutableArray * pontosDeInteresse;
    HVPolygon * polygon;
}

+ (HVImage *) fastCreation:(NSString *)imageName;
+ (NSMutableArray *)getPixels:(UIImage*)image
                    red:(double)r green:(double)g blue:(double)b alpha:(double)a
                    redRange:(double)rR
                    greenRange:(double)gR
                    blueRange:(double)bR
                    alphaRange:(double)aR
                    blockSearch:(int)block;

@end

@interface teste_PixelColorsViewController : UIViewController



@end
