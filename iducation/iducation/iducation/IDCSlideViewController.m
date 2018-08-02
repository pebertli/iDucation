//
//  IDCSlideViewController.m
//  iducation
//
//  Created by pebertli on 16/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCSlideViewController.h"
#import "IDCConstants.h"


@implementation RangeCursor

@synthesize point1;
@synthesize point2;

- (id) initWithPoint1:(int) p1 Point2:(int)p2
{
    if(self = [super init])
    {
        point1 = p1;
        point2 = p2;
    }
    return self;
}


@end

@interface IDCSlideViewController ()

@end


@implementation IDCSlideViewController

@synthesize markedRanges;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil page:(int) number
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //Add in ascending cursor order
        markedRanges = [NSMutableArray array];
        page = number;
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"s_0%d_v_ipad_r.png",page]]];
    backgroundImage.frame = self.view.frame;
    [self.view addSubview:backgroundImage];
    
        
    
    [self.view sendSubviewToBack:pageNumber];
    [self.view sendSubviewToBack:backgroundImage];
    

    
    
}

- (void) setPageNumber:(int) number
{
    page = number;
//    if(!pageNumber)
//        pageNumber = [[UILabel alloc] initWithFrame:CGRectMake(600, 900, 30, 20)];
//    [self.view addSubview:pageNumber];
//
//    if(number<10)
//        pageNumber.text = [NSString stringWithFormat:@"0%d",number];
//    else
//        pageNumber.text = [NSString stringWithFormat:@"%d",number];
}

//get just the first line rect in text selected
- (CGRect) getFirstSelectedTextRange{
    
    //Iterate over all text view`s
    for(UIView* v in [self.view subviews])
    {
        if([v isKindOfClass:[UITextView class]]){
            UITextView* vAux = (UITextView*)v;
            //Get the selection range
            UITextRange * selectionRange = [vAux selectedTextRange];
            //If selectionRange is not nil and there is some text selected
            //return the rect range
            //else search in another textview
            if(selectionRange && [[vAux textInRange:selectionRange] length]>0)
                return  [vAux firstRectForRange:selectionRange];
            else
                continue;
        }
    }
    
    return CGRectZero;
}

- (NSMutableArray*) getRectsForLinesWithStart: (int)start end:(int)end
{
    
    NSMutableArray* array = [NSMutableArray array];
    IDCTextView* vAux = [self getFirstSelectedTextView];
    if(vAux){
        //Get the selection range
        //initial position in entire text
        UITextPosition* startPosEntire = [vAux positionFromPosition:vAux.beginningOfDocument offset:start];
        //end position in entire text
        UITextPosition* endPosEntire = [vAux positionFromPosition:startPosEntire offset:end-start];
        UITextRange * selectionRange = [vAux textRangeFromPosition:startPosEntire toPosition:endPosEntire];

            //interate over all lines in selected text
//            while(index < stringLength){
            while(!selectionRange.empty && selectionRange)
                        {
                //get the new index from next line
                //index = NSMaxRange([selectedText lineRangeForRange:NSMakeRange(index, 0)]);
                
                 UITextRange* range = [self getLastIndexFromLine:selectionRange inText:vAux];
                            if([range.end isEqual:selectionRange.end])
                                selectionRange  =nil;
                            else
                            selectionRange = [vAux textRangeFromPosition:[vAux positionFromPosition:range.end offset:1] toPosition:selectionRange.end];
                            
                            
                
                //initial position of the line of the selected text, relative to entire text view
//                UITextPosition* startPos = [vAux positionFromPosition:selectionRange.start offset:lastIndex];
//                //end position of the line of the selected text, relative to entire text view
//                UITextPosition* endPos = [vAux positionFromPosition:startPos offset:index-lastIndex-1];
//                //correction for range when it`s the last line
//                if(index==stringLength)
//                    endPos=[vAux positionFromPosition:startPos offset:index-lastIndex];
//                //get the range
//                UITextRange* range = [vAux textRangeFromPosition:startPos toPosition:endPos];
                
                //get all rects for this line. If there are multiples font formats in that line, then there are mutiples rects too. One rect for each distinct font format
                NSArray* rects = [vAux selectionRectsForRange:range];
                //store the first rect for union
                            if([rects count]>0)
                            {
                UITextSelectionRect* firstRect = [rects objectAtIndex:0];
                CGRect rect = firstRect.rect;
                //union all rects in line for mark the entire line
                for(int count = 1 ; count<[rects count];count++)
                {
                    UITextSelectionRect* r2 = [rects objectAtIndex:count];
                    rect = CGRectUnion(rect, r2.rect);
                }
                
                //rect = [vAux convertRect:rect toView:vAux];
                //add to return array
                [array addObject:[NSValue valueWithCGRect:rect] ];
                            }
                //update the last index
                //lastIndex = index;
            }
    }
    
    return array;
    
}

- (UITextRange*) getLastIndexFromLine: (UITextRange*) range inText:(UITextView*) view
{
    UITextPosition* currentPosition = range.start;
    //text from selection
    NSString *selectedText = [view textInRange:range];
    int lenght = selectedText.length;
    int index = 0;
    while (index<lenght)
    {
        UITextPosition* nextPosition = [view positionFromPosition:currentPosition offset:1];
        
        float xCurrent = [view caretRectForPosition:currentPosition].origin.y;
        float xNext = [view caretRectForPosition:nextPosition].origin.y;
//        NSLog(@"%f %f",xCurrent, xNext);
        if(xCurrent!=xNext)
        {
            return [view textRangeFromPosition:range.start toPosition:currentPosition];
        }
        
        currentPosition = nextPosition;
        index++;
    }
    return range;
}

//get all rects for lines, considering trim text and multiples ranges in the same line
- (NSArray*) getRectsForLines{
    NSMutableArray*  ret = [NSMutableArray array];
    UITextView* vAux = [self getFirstSelectedTextView];
    if(vAux)
        for(RangeCursor* range in markedRanges)
        {
            [ret addObjectsFromArray:[self getRectsForLinesWithStart:range.point1 end:range.point2]];
        }
    
    return ret;
}

- (IDCTextView*) getFirstSelectedTextView{
    
    //Iterate over all text view`s
    for(UIView* v in [self.view subviews])
    {
        if([v isKindOfClass:[IDCTextView class]]){
            IDCTextView* vAux = (IDCTextView*)v;
            //Get the selection range
            UITextRange * selectionRange = [vAux selectedTextRange];
            //If selectionRange is not nil and there is some text selected
            //return the position of curson in the beginning of range
            //else searche in another textview
            if(selectionRange && [[vAux textInRange:selectionRange] length]>0)
                return  vAux;
            else
                continue;
        }
    }
    
    return nil;
}

-(void) addMarkedRangeFromSelection{
    IDCTextView* vAux = [self getFirstSelectedTextView];
    
    if(vAux){
        //range of selected text
        UITextRange* range =  [vAux selectedTextRange];
        int start = [vAux offsetFromPosition:vAux.beginningOfDocument toPosition:range.start];
        int end = [vAux offsetFromPosition:range.start toPosition:range.end]+start;
        
        //iterate over ranges until find a place to add or merge new range
        for(int count = 0;count<[markedRanges count];count++)
        {
            RangeCursor* r = [markedRanges objectAtIndex:count];
            
             //left part of new range touches the current range
             if((start<=r.point2 && start>=r.point1)){
                 start = r.point1;
                }
             //the end of new range touches the current range
             if(end>=r.point1 && end<=r.point2){
                 end = r.point2;
                }
        }
        
        int indexRemoveStart = 0;
        int indexRemoveOffset = 0;
        //iterate over ranges searching for marks to remove, because of new range is over them
        for(int count = 0;count<[markedRanges count];count++)
        {
            RangeCursor* r = [markedRanges objectAtIndex:count];

            //new range is over the current range, then mark the current range for deletion
            if(start<r.point2 && end>r.point1)
                indexRemoveOffset++;

            //where the new range will be inserted
            if(start>r.point2)
                indexRemoveStart=count+1;
        }
        
        [markedRanges insertObject:[[RangeCursor alloc] initWithPoint1:start Point2:end] atIndex:indexRemoveStart];
        
        while (indexRemoveOffset>0) {
            [markedRanges removeObjectAtIndex:indexRemoveStart+indexRemoveOffset];
            indexRemoveOffset--; 
            
        }
        
    
    }
    
}

-(void) removeMarkedRangeFromSelection{
    IDCTextView* vAux = [self getFirstSelectedTextView];
    
    if(vAux){
        //range of selected text
        UITextRange* range =  [vAux selectedTextRange];
        int start = [vAux offsetFromPosition:vAux.beginningOfDocument toPosition:range.start];
        int end = [vAux offsetFromPosition:range.start toPosition:range.end]+start;
        
        int indexRemoveStart = -1;
        int indexRemoveOffset = 0;
        //iterate over ranges searching for marks to remove, because of selected range is over them
        for(int count = 0;count<[markedRanges count];count++)
        {
            RangeCursor* r = [markedRanges objectAtIndex:count];
            
            //selected range touches current range
            if(end>=r.point1&&start<=r.point2)
            {
                indexRemoveOffset++;
                if(indexRemoveStart==-1)
                    indexRemoveStart=count;
            }
        }
        
        while (indexRemoveOffset>0) {
            [markedRanges removeObjectAtIndex:indexRemoveStart];
            indexRemoveOffset--;
        }
        
        
    }
    
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    return [super canPerformAction: action withSender: sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //pass touch to next responder
    [self.nextResponder touchesBegan:touches withEvent:event];
}


#pragma mark Orientation

- (void) changeOrientationTo:(UIInterfaceOrientation) orientation withAnimation:(BOOL) animate
{
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        if(page<10)
            backgroundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"s_0%d_h_ipad_r.png",page]];
        else
            backgroundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"s_%d_h_ipad_r.png",page]];

        if(animate)
        [UIView animateWithDuration:LONG_TIME_INTERVAL animations:^{
            backgroundImage.frame = CGRectMake(0, 0, HEIGHT_IPAD, WIDTH_IPAD);
               }];
        else
            backgroundImage.frame = CGRectMake(0, 0, HEIGHT_IPAD, WIDTH_IPAD);
    }
    else
    {
        if(page<10)
            backgroundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"s_0%d_v_ipad_r.png",page]];
        else
            backgroundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"s_%d_v_ipad_r.png",page]];
        if(animate)
        [UIView animateWithDuration:LONG_TIME_INTERVAL animations:^{
         backgroundImage.frame = CGRectMake(0, 0, WIDTH_IPAD, HEIGHT_IPAD);
        }];
        else
            backgroundImage.frame = CGRectMake(0, 0, WIDTH_IPAD, HEIGHT_IPAD);
            
    }
}

//- (BOOL)shouldAutorotate
//{
//    return YES;
//}

@end
