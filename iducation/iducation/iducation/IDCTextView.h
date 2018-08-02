//
//  IDCTextView.h
//  iducation
//
//  Created by pebertli on 23/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCTextHighlight.h"

@interface IDCTextView : UITextView
{
    NSMutableArray* markedAreas;
}

- (void) addMarkedArea:(CGRect) rect withStartColor:(UIColor*) startColor endColor:(UIColor*) endColor;
- (void) clearMarkedAreas;

@end
