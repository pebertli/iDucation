//
//  teste_ToolbarViewController.h
//  teste_Toolbar
//
//  Created by User on 04/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVCustomizedViews.h"
#import "HVToolbar.h"

@interface teste_ToolbarViewController : UIViewController{
    HVDot * dot;
    HVToolbarButton * botao0;
}

- (IBAction)escalarDot;

@end
