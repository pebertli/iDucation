//
//  IDCNature.h
//  dalton.combinations
//
//  Created by pebertli on 22/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HVUtils.h"
#import "IDCAtom.h"

@interface IDCNature : NSObject
{
    NSMutableArray* atoms;
    NSMutableArray* combinations;
}

@property (strong, nonatomic) NSMutableArray* atoms;

- (void) addAtomnsOf: (NSString*) element withScale:(float) scale amount:(int) amount;
- (void) addCombination:(HVTree*) combination;
- (NSArray*) matchedCombination:(NSArray*) setOfAtoms;
- (NSMutableArray*) getAtomsWithState:(IDCAtomState) s;
- (BOOL) prepareCombination:(HVTree*) combination withAtoms:(NSArray*) array;

@end

@interface IDCAtomCombination : NSObject
{
    NSString* element;
    float angle;
    IDCAtom* atom;
}

@property (strong, nonatomic) NSString* element;
@property (nonatomic) float angle;
@property (strong, nonatomic) IDCAtom* atom;

- (id) initWithElement:(NSString*) e angle:(float) a;

@end
