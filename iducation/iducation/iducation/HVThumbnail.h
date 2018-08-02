//
//  HVThumbnail.h
//  iducation
//
//  Created by pebertli on 11/07/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "HVCustomizedViews.h"

typedef enum {
    HVTHUMBNAIL_STATE_MINIMIZED,
    HVTHUMBNAIL_STATE_MAXIMIZED
} HVThumbnailState;


@interface HVThumbnail : UIView
{
    UIImageView* thumbnail;
    UIView* mainView;
    CGRect mainViewFrame;
    CGRect thumbnailViewFrame;
    HVThumbnailState state;
    UIButton* returnButton;
}

- (id)initWithFrame:(CGRect)frame thumbnail:(NSString*) file;
- (void) setMainViewWithView:(UIView*) view frame:(CGRect) rect;

@end
