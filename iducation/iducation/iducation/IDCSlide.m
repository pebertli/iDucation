//
//  IDCSlide.m
//  iducation
//
//  Created by pebertli on 15/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCSlide.h"
#import "IDCFormatTextParser.h"

@implementation IDCNote

@synthesize origin;
@synthesize text;

- (id) initWithText:(NSString*) content position:(CGPoint)point
{
    if(self = [super init])
    {
        origin = point;
        text = content;
    }
    return self;
}


@end


@implementation IDCSlide

@synthesize nibName;
@synthesize viewController;
@synthesize label;
@synthesize notes;
@synthesize className;
@synthesize textFileName;
@synthesize pageNumber;


- (id) init
{
    if(self = [super init])
    {
        className = @"IDCSlideViewController";
        isTextSelectionEnabled = NO;
        notes = [NSMutableArray array];
    }
    return self;
}

- (void)allocateAndInitController
{
    //Allocate and init the controller with nib. This is delayed because one controller can consume several memory
    Class c = NSClassFromString(className);
    //Allocation of the custom class or UIViewController by default
    self.viewController = [[c alloc] initWithNibName:self.nibName bundle:nil page:pageNumber];
    self.viewController.view.userInteractionEnabled = YES;
    //[self.viewController setPageNumber:pageNumber];
    
    //load formated text from file
    if([textFileName length]>0)
    {
        for(UIView* v in [self.viewController.view subviews])
        {
            if([v isKindOfClass:[UITextView class]])
            {
                UITextView* vAux = (UITextView*)v;
                vAux.attributedText = [[IDCFormatTextParser sharedInstance] parserAtributtedStringFromFile:textFileName];
                vAux.selectionAffinity = UITextStorageDirectionBackward;
            }
        }

    }
    
    //if it is a reallocate, call setEnableTextSelection: again
    [self setEnableTextSelection:isTextSelectionEnabled];
}


- (void)setEnableTextSelection:(BOOL)enable{
    isTextSelectionEnabled = YES;
    //Alter user selection for textView`s
    for(UIView* v in [self.viewController.view subviews])
    {
        if([v isKindOfClass:[UITextView class]])
            v.userInteractionEnabled = enable;
    }
}

//search an added note by its height position with a tolerance of bottomTolerance points below
- (IDCNote*) searchNoteWithPosition:(CGPoint) point rangePoints:(int) bottomTolerance
{
    for (IDCNote* n in notes) {
        CGPoint p = n.origin;
        //if the note is in range
        if(abs(point.y-p.y)<=bottomTolerance)
        {
            return n;
        }
    }
    
return nil;
}

- (void) addRemoveOrChangeNoteWithText:(NSString*) note toPoint:(CGPoint) point withTolerance:(int) tolerance{
    IDCNote* n = [self searchNoteWithPosition:point rangePoints:tolerance];
    if(n == nil)
    {
        //new note
        if([note length]>0)
        [notes addObject:[[IDCNote alloc] initWithText:note position:point]];
    }
    else//modify or remove (if there is no text) existing note
    {
        
        if([note length]>0)
            n.text = note;
        else{
            [notes removeObject:n];
            n = nil;
        }
    }
}

@end
