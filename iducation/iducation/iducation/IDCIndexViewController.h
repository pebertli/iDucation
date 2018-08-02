//
//  IDCIndexViewController.h
//  iducation
//
//  Created by pebertli on 20/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCRootViewController.h"

@class IDCRootViewController;

@interface IDCIndexViewController : UIViewController
{
    IDCRootViewController* rootController;
}
@property (strong, nonatomic) IBOutlet UITableView *tableSlides;
@property (strong, nonatomic) IBOutlet UIView *viewForTable;

@property (strong, nonatomic) IDCRootViewController* rootController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rootController:(IDCRootViewController*) root;

@end
