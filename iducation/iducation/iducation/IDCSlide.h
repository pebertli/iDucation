//
//  IDCSlide.h
//  iducation
//
//  Created by pebertli on 15/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCSlideViewController.h"

@interface IDCNote : NSObject{
CGPoint origin;
NSString* text;
}
@property (nonatomic) CGPoint origin;
@property (nonatomic) NSString* text;

@end

@interface IDCSlide : NSObject
{
    IDCSlideViewController* viewController;
    NSString* description;
    NSString* label;
    UIImage* thumbnail;
    NSString* nibName;
    NSString* className;
    NSString* textFileName;
    BOOL isTextSelectionEnabled;
    int pageNumber;
    
    NSMutableArray* notes;
    
}
@property (nonatomic) IDCSlideViewController* viewController;
@property (nonatomic) NSString* nibName;
@property (nonatomic) NSString* label;
@property (nonatomic) NSMutableArray* notes;
@property (nonatomic) NSString* className;
@property (nonatomic) NSString* textFileName;
@property int pageNumber;

- (void) allocateAndInitController;
- (void)setEnableTextSelection:(BOOL)enable;
- (void) addRemoveOrChangeNoteWithText:(NSString*) note toPoint:(CGPoint) origin withTolerance:(int) tolerance;
- (IDCNote*) searchNoteWithPosition:(CGPoint) point rangePoints:(int) bottomTolerance;

@end
