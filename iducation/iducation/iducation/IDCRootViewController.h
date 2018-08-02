//
//  IDCRootViewController.h
//  iducation
//
//  Created by pebertli on 14/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCIndexViewController.h"
#import "IDCNoteViewController.h"
#import "IDCTopBar.h"
#import "IDCPaintViewController.h"

@class IDCIndexViewController;
@class IDCNoteViewController;

@interface IDCRootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate>
{
    //Slides from book
    NSArray* slidesName;
    NSMutableArray* slides;
    NSMutableArray* noteButtons;
    int currentSlideIndex;
    BOOL isMenuShowing;
    BOOL isIndexShowing;
    BOOL isNoteViewShowing;
    BOOL isTextSelecionEnable;
    CGPoint desiredNoteViewPosition;
    CGPoint targetNoteViewPosition;
    int lineSize;
    IDCIndexViewController* indexController;
    IDCNoteViewController* noteViewController;
    IDCPaintViewController* paintViewController;
    IDCTopBar* topBar;
    BOOL existSlideChangeTimer;
    NSTimer* slideChangeTimer;
    
    BOOL lockPreviousButton;
    BOOL lockNextButton;
}

@property (strong, nonatomic) IBOutlet UIButton *previousButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *indexButton;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;

@property (nonatomic)   IDCIndexViewController* indexController;
@property (nonatomic)   IDCNoteViewController* noteViewController;

- (IBAction)pressedButtonMenu:(id)sender;

- (IBAction)pressedDownButtonPreviousSlide:(id)sender;
- (IBAction)pressedUpInsideButtonPreviousSlide:(id)sender;
- (IBAction)pressedUpOutsideButtonPreviousSlide:(id)sender;

- (IBAction)pressedDownButtonNextSlide:(id)sender;
- (IBAction)pressedUpInsideButtonNextSlide:(id)sender;
- (IBAction)pressedUpOutsideButtonNextSlide:(id)sender;

- (IBAction)pressedButtonIndex:(id)sender;
- (IBAction)pressedButtonTextSelection:(UIButton *)sender;

@end
