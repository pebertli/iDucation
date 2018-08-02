//
//  IDCTextViewController.h
//  iducation
//
//  Created by pebertli on 2/25/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCNoteView.h"

@interface IDCNoteViewController : UIViewController <UITextViewDelegate>
{
    IDCNoteView* noteView;
    UIView* containerView;
}

@property (nonatomic) IDCNoteView* noteView;
@property (nonatomic) UIView* containerView;

- (id)initWithNoteViewFrame:(CGRect) frame;

@end
