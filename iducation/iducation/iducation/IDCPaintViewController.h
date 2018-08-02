//
//  IDCPaintViewController.h
//  iducation
//
//  Created by pebertli on 11/09/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCPaintView.h"

@interface IDCPaintViewController : UIViewController
{
    IBOutlet UIButton *closeButton;
    IBOutlet IDCPaintView *canvas;
    NSString* slide;
}


@property (nonatomic, strong) NSString* slide;
@property (nonatomic, strong) IBOutlet IDCPaintView* canvas;
@property (nonatomic, strong) IBOutlet UIButton* closeButton;

- (IBAction)redButtonClick:(id)sender;
- (IBAction)eraserButtonClick:(id)sender;
- (IBAction)cleanButtonClick:(id)sender;


@end
