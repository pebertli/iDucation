//
//  IDCNoteView.m
//  iducation
//
//  Created by pebertli on 23/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCNoteView.h"
#import <QuartzCore/QuartzCore.h>
#import "IDCConstants.h"

@implementation IDCNoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.6f alpha:1.0f];
        self.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:SIZE_FONT_NOTE_VIEW_IPAD];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect
{
    //Get the current drawing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Set the line color and width
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    //Start a new Path
    CGContextBeginPath(context);
    
    //Find the number of lines in our textView + add a bit more height to draw lines in the empty part of the view
    NSUInteger numberOfLines = (self.contentSize.height + self.bounds.size.height) / self.font.leading;
    
    //Set the line offset from the baseline. (I'm sure there's a concrete way to calculate this.)
    CGFloat baselineOffset = OFFSET_BASELINE_NOTE_VIEW_IPAD;
    
    //iterate over numberOfLines and draw each line
    for (int x = 0; x < numberOfLines; x++) {
        //0.5f offset lines up line with pixel boundary
        CGContextMoveToPoint(context, self.bounds.origin.x, self.font.leading*x + OFFSET_LETTER_LINE_NOTE_VIEW_IPAD + baselineOffset);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.font.leading*x + OFFSET_LETTER_LINE_NOTE_VIEW_IPAD + baselineOffset);
    }
    
    //Close our Path and Stroke (draw) it
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    //Vertical margin line
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.8f green:0.0f blue:0.0f alpha:0.2f].CGColor);
    CGContextMoveToPoint(context, self.bounds.origin.x+X_MARGIN_NOTE_VIEW_IPAD, 0);
    CGContextAddLineToPoint(context, self.bounds.origin.x+X_MARGIN_NOTE_VIEW_IPAD, self.font.leading*numberOfLines);
    
    //Close our Path and Stroke (draw) it
    CGContextClosePath(context);
    CGContextStrokePath(context);
    

}


- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    
if ( action == @selector( addNote: ) )
{
    return NO;
}
    return [super canPerformAction:action withSender:sender];
}

@end
