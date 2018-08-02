//
//  IDCNature.m
//  dalton.combinations
//
//  Created by pebertli on 22/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCNature.h"
#import "IDCConstants.h"



@implementation IDCNature

@synthesize atoms;

- (id) init{
    
    self = [super init];
    if(self)
    {
        atoms = [NSMutableArray array];
        combinations = [NSMutableArray array];
    }
    
    return self;
}

- (void) addAtomnsOf: (NSString*) element withScale:(float) scale amount:(int) amount{
    //add an amount of atoms of one type
    for (int i = 0 ; i<amount; i++) {
        IDCAtom* a = [[IDCAtom alloc] initWithElement:element scale:scale];
        [atoms addObject:a];
    }
}

- (void) addCombination: (HVTree*) combination
{
    [combinations addObject:combination];
}

//return a combination that match with set of elements
- (NSArray*) matchedCombination:(NSArray*) setOfAtoms
{
    NSMutableArray* result = [NSMutableArray array];
    //add the firs element as nil. The first object must be the exactly match
    [result addObject:[NSNull null]];
    
    int amountSelected = [setOfAtoms count];
    if(amountSelected>0){
        //iterate over all combinations
        for(HVTree* combination in combinations)
        {
            NSMutableArray* allChildren = [[NSMutableArray alloc] initWithArray:[[[combination getAllChindren] valueForKey:@"value"] valueForKey:@"element"]];
            NSMutableArray* touched = [[NSMutableArray alloc] initWithArray:[setOfAtoms valueForKey:@"element"]];
            
            //only the potential combinations
            if([allChildren count]>=amountSelected)
            {
                
                BOOL contains = YES;
                for(NSString* a in touched)
                {
                    //if the possible combination contains the current atom, then remove it (the next search will not contain the already found atom) and continue search for next atoms
                    NSUInteger indexFound = [allChildren indexOfObject:a];
                    if(indexFound!=NSNotFound)
                        [allChildren removeObjectAtIndex:indexFound];
                    //else the combination is not candidate
                    else{
                        contains = NO;
                        break;
                    }
                }
                //contain more than touched atoms
                if(contains && [allChildren count]>0)
                    [result addObject:combination];
                //fit exactly the touched atoms
                else if(contains && [allChildren count]==0)
                    [result replaceObjectAtIndex:0 withObject:combination];
            }
        }
    }
    
    return result;
}

//set destination position values for atoms based on molecular combination and sizes rects of atoms involved
- (BOOL) prepareCombination:(HVTree*) combination withAtoms:(NSArray*) array
{
    //touched atoms sorted alphabetically by element symbol
    NSSortDescriptor *elementDescriptor = [[NSSortDescriptor alloc] initWithKey:@"element" ascending:YES];
    NSArray *sortDescriptors = @[elementDescriptor];
    array = [array sortedArrayUsingDescriptors:sortDescriptors ];
    
    //nodes from tree sorted by element symbol
    elementDescriptor = [[NSSortDescriptor alloc] initWithKey:@"value.element" ascending:YES];
    sortDescriptors = @[elementDescriptor];
    NSArray* allChildren = [[NSArray alloc] initWithArray:[[combination getAllChindren] sortedArrayUsingDescriptors:sortDescriptors]];
    
    //atach real atoms to combination
    for (int i = 0; i<[allChildren count]; i++) {
        HVTreeNode* current = [allChildren objectAtIndex:i];
        IDCAtomCombination* comb = current.value;
        comb.atom = [array objectAtIndex:i];
        
    }
    
    //get the correct position in combination for each atom recursively
    for (int i = 0; i<[allChildren count]; i++) {
        HVTreeNode* current = [allChildren objectAtIndex:i];
        IDCAtom* currentAtom = ((IDCAtomCombination*)current.value).atom;
       
        currentAtom.desiredPoint = centerToOrigin([self getDesiredCenterForAtomInNode:current], currentAtom.frame);
               
    }
    
    return YES;
}

//get the position of a atom in combination after that his parent be positioned
- (CGPoint) getDesiredCenterForAtomInNode:(HVTreeNode*) node
{
    IDCAtom* currentAtom = ((IDCAtomCombination*)node.value).atom;
    float currentAngle = ((IDCAtomCombination*)node.value).angle;
    HVTreeNode* parent = node.parent;
    IDCAtom* parentAtom = ((IDCAtomCombination*)parent.value).atom;
    
    //has a parent
    if(parent)
    {
        CGPoint centerParent = [self getDesiredCenterForAtomInNode:parent];
        float radiusParent = parentAtom.frame.size.width/2;
        float radiusCurrent = currentAtom.frame.size.width/2;
        
        return pointAround(centerParent, radiusCurrent+radiusParent, currentAngle);
        
    }
    //the root
    else{
        //center of ipad, change to center of custom rect
        return CGPointMake(WIDTH_IPAD/2, HEIGHT_IPAD/2);
    }
    
}

//return only atoms with the state s
- (NSMutableArray*) getAtomsWithState:(IDCAtomState) s
{
    NSMutableArray* result = [NSMutableArray array];
    for(IDCAtom* a in atoms)
    {
        if(a.state == s)
            [result addObject:a];
    }
    
    return result;
}

@end


@implementation IDCAtomCombination

@synthesize angle;
@synthesize element;
@synthesize atom;

- (id) initWithElement:(NSString*) e angle:(float) a
{
    self = [super init];
    
    if(self)
    {
        element = e;
        angle = a;
    }
    
    return self;
}

@end
