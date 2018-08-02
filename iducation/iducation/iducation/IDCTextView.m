//
//  IDCTextView.m
//  iducation
//
//  Created by pebertli on 23/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCTextView.h"
#import "IDCConstants.h"

@implementation IDCTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        markedAreas = [NSMutableArray array];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        markedAreas = [NSMutableArray array];
    }
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    //multiples format fonts with attributedString
    if (self) {
        markedAreas = [NSMutableArray array];
    }
    return self;
    
}


- (void) addMarkedArea:(CGRect) rect withStartColor:(UIColor*) startColor endColor:(UIColor*) endColor
{
    IDCMarkedArea* m = [[IDCMarkedArea alloc] initWithArea:rect startColor:startColor encColor:endColor];
    [markedAreas addObject:m];
    
    for(IDCMarkedArea* m in markedAreas){
        [self insertSubview:m atIndex:0];
    }
    
}

- (void) clearMarkedAreas{
    for(UIView* v in markedAreas)
        [v removeFromSuperview];
    [markedAreas removeAllObjects];
    
}



@end
