//
//  IDCSlideViewController.h
//  iducation
//
//  Created by pebertli on 16/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCTextView.h"

@interface RangeCursor : NSObject
{
	int point1;
	int point2;
}

@property (nonatomic) int point1;
@property (nonatomic) int point2;

@end


@interface IDCSlideViewController : UIViewController{
    NSMutableArray* markedRanges;
    UIImageView* backgroundImage;
    UILabel* pageNumber;
    int page;
}

@property (strong,nonatomic) NSMutableArray* markedRanges;

- (CGRect) getFirstSelectedTextRange;
- (IDCTextView*) getFirstSelectedTextView;
- (NSArray*) getRectsForLines;
- (void) addMarkedRangeFromSelection;
-(void) removeMarkedRangeFromSelection;

- (void) setPageNumber:(int) number;

- (void) changeOrientationTo:(UIInterfaceOrientation) orientation withAnimation:(BOOL) animate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil page:(int) number;

@end
