//
//  Slide1ViewController.h
//  iducation
//
//  Created by pebertli on 09/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCSlideViewController.h"
#import "IDCGLKitViewController.h"
#import "HVThumbnail.h"
#import "IDCDaltonViewController.h"
#import "IDCBohrHeatViewController.h"
#import "IDCPaintView.h"

@interface Slide1ViewController : IDCSlideViewController
{
    IDCGLKitViewController* gl1Controller;
    IDCDaltonViewController* dc;
    IDCBohrHeatViewController* bh;
    IDCPaintView* paintView;
    
    
    
}

@end
