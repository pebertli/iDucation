//
//  IDCViewController.m
//  reveal_atom
//
//  Created by pebertli on 5/2/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCViewController.h"

float const ATOM_SIZE = 12;


@interface IDCViewController ()

@end

@implementation IDCViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    lastScale = 1.0;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
//    savedLocation = CGPointZero;
//    NSString* diamondFileName = @"diamond";
    //    diamond = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"diamond.png"]];
//    SVGKImage* im = [SVGKImage imageNamed:@"Anel de ouro.svg"];
//    im.size = CGSizeMake(250, 175);
//    diamond = [[SVGKLayeredImageView alloc] initWithSVGKImage:im ];
    
    UIImage* im = [UIImage imageNamed:@"diamond.png"];
//    im.scale  size = CGSizeMake(250, 175);
    diamond = [[UIImageView alloc] initWithImage:im ];
    diamond.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    diamond.frame = CGRectMake(0, 0, diamond.image.size.width, diamond.image.size.height);
    //diamond.center = CGPointMake(768/2, 1024/2);
    
    im = [UIImage imageNamed:@"hand.png"];
    hand = [[UIImageView alloc] initWithImage:im ];
    hand.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    hand.frame = CGRectMake(0, 0, hand.image.size.width/2.5, hand.image.size.height/2.5);
    //hand.center = CGPointMake(768/2, 1024/2);

    im = [UIImage imageNamed:@"ring.png"];
    ring = [[UIImageView alloc] initWithImage:im ];
    ring.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    ring.frame = CGRectMake(0, 0, ring.image.size.width/2.5, ring.image.size.height/2.5);
    //ring.center = CGPointMake(768/2, 1024/2);

    
//    [self.view addSubview: diamond];
    //    self->diamond.disableAutoRedrawAtHighestResolution = YES;
    //    self->diamond.tileRatio = CGSizeMake(0, 0);
    
    
    //    diamond = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"diamond.png"]];
//    SVGKImage* im2 = [SVGKImage imageNamed:diamondFileName];
//    im2.size = CGSizeMake(250, 175);
//     hand = [[SVGKLayeredImageView alloc] initWithSVGKImage:im2 ];
    
    //    UIImage* im = [UIImage imageNamed:@"diamond.png"];
    ////    im.scale  size = CGSizeMake(250, 175);
    //    diamond = [[UIImageView alloc] initWithImage:im ];
    
//    hand.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //    diamond.frame = CGRectMake(0, 0, 350, 275);
//    hand.center = CGPointMake(768/2, 1024/2);
//    
//    SVGKImage* im3 = [SVGKImage imageNamed:diamondFileName];
//    im3.size = CGSizeMake(250, 175);
//    ring = [[SVGKLayeredImageView alloc] initWithSVGKImage:im3 ];
//    
//    //    UIImage* im = [UIImage imageNamed:@"diamond.png"];
//    ////    im.scale  size = CGSizeMake(250, 175);
//    //    diamond = [[UIImageView alloc] initWithImage:im ];
//    
//    ring.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    //    diamond.frame = CGRectMake(0, 0, 350, 275);
//    ring.center = CGPointMake(768/2, 1024/2);

    
    images = [[NSMutableArray alloc] init];
    [images addObject:diamond];
    [images addObject:hand];
    [images addObject:ring];
    
    zoomContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 75)];
    [[zoomContainer layer] setCornerRadius:50];
    [[zoomContainer layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[zoomContainer layer] setBorderWidth:1.0];
    zoomContainer.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    zoomContainer.clipsToBounds = YES;
    zoomContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    CGAffineTransform transform = self.view.transform;
    //zoomContainer.transform = CGAffineTransformScale(transform,0, 0);
    zoomContainer.userInteractionEnabled = NO;
    zoomContainer.alpha = 0.0;
   
    [[self view] addSubview:zoomContainer];
    
     atomContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    atomContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    CGAffineTransform transform2 = self.view.transform;
//    atomContainer.transform = CGAffineTransformScale(transform2,0, 0);
    atomContainer.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    //atomContainer.center = CGPointMake((768/2), (1024/2));
    [zoomContainer addSubview:atomContainer];
   
    diamond.userInteractionEnabled = YES;
    hand.userInteractionEnabled = YES;
    ring.userInteractionEnabled = YES;
    
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
    twoFingerPinch.delegate = self;
    [diamond addGestureRecognizer:twoFingerPinch];
    
    twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
    twoFingerPinch.delegate = self;
    [hand addGestureRecognizer:twoFingerPinch];
    
    twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
    twoFingerPinch.delegate = self;
    [ring addGestureRecognizer:twoFingerPinch];
    
    atoms = [NSMutableArray array];
    
    atomDiamondContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    atomDiamondContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    CGAffineTransform transform2 = self.view.transform;
    //    atomContainer.transform = CGAffineTransformScale(transform2,0, 0);
    atomDiamondContainer.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    //atomContainer.center = CGPointMake((768/2), (1024/2));
    [atomContainer addSubview:atomDiamondContainer];
    
    atomHandContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    atomHandContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    CGAffineTransform transform2 = self.view.transform;
    //    atomContainer.transform = CGAffineTransformScale(transform2,0, 0);
    atomHandContainer.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    //atomContainer.center = CGPointMake((768/2), (1024/2));
//    [atomContainer addSubview:atomHandContainer];
    
    atomRingContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    atomRingContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    CGAffineTransform transform2 = self.view.transform;
    //    atomContainer.transform = CGAffineTransformScale(transform2,0, 0);
    atomRingContainer.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    //atomContainer.center = CGPointMake((768/2), (1024/2));
//    [atomContainer addSubview:atomRingContainer];
    
    lastContainer = atomDiamondContainer;
//
    HVPixelatedImage* pi = [[HVPixelatedImage alloc] initWithImage:@"diamond_mask.png" withFrame:CGRectMake((768/2)-(diamond.image.size.width/2), (1024/2)-(diamond.image.size.height/2), diamond.image.size.width, diamond.image.size.height)];
    NSArray* atomsPosition = [pi getPixelsCenter:ATOM_SIZE];
    for (HVPoint* p in atomsPosition) {
        IDCAtom* a = [[IDCAtom alloc] initWithArt:@"diamond_atom.png" withSize:CGSizeMake(ATOM_SIZE, ATOM_SIZE)]  ;
        [atoms addObject:a];
        [atomDiamondContainer addSubview:a];
        a.center = [p point];
        a.desiredPoint = [p point];
    }

    pi = [[HVPixelatedImage alloc] initWithImage:@"hand_mask.png" withFrame:CGRectMake((768/2)-(hand.image.size.width/5), (1024/2)-(hand.image.size.height/5), hand.image.size.width/2.5, hand.image.size.height/2.5)];
    atomsPosition = [pi getPixelsCenter:ATOM_SIZE];
    for (HVPoint* p in atomsPosition) {
        IDCAtom* a = [[IDCAtom alloc] initWithArt:@"hand_atom.png" withSize:CGSizeMake(ATOM_SIZE, ATOM_SIZE)]  ;
        [atoms addObject:a];
        [atomHandContainer addSubview:a];
        a.center = [p point];
        a.desiredPoint = [p point];
    }
    
    pi = [[HVPixelatedImage alloc] initWithImage:@"ring_mask.png" withFrame:CGRectMake((768/2)-(ring.image.size.width/5), (1024/2)-(ring.image.size.height/5), ring.image.size.width/2.5, ring.image.size.height/2.5)];
    atomsPosition = [pi getPixelsCenter:ATOM_SIZE];
    for (HVPoint* p in atomsPosition) {
        IDCAtom* a = [[IDCAtom alloc] initWithArt:@"ring_atom.png" withSize:CGSizeMake(ATOM_SIZE, ATOM_SIZE)]  ;
        [atoms addObject:a];
        [atomRingContainer addSubview:a];
        a.center = [p point];
        a.desiredPoint = [p point];
    }
    
//    HVPixelatedImage* pi = [[HVPixelatedImage alloc] initWithImage:@"diamond_mask.png" withFrame:CGRectMake((768/2)-(474/2), (1024/2)-(373/2), 474, 373)];
//    NSArray* atomsPosition = [pi getPixelsCenter:10];
//    for (HVPoint* p in atomsPosition) {
//        IDCAtom* a = [[IDCAtom alloc] initWithArt:@"diamond_atom.png" withSize:CGSizeMake(10, 10)]  ;
//        [atoms addObject:a];
//        [atomContainer addSubview:a];
//        a.center = [p point];
//        a.desiredPoint = [p point];
//    }
    
//    BOOL can = arrangeViews(atoms ,CGRectMake((768/2)-(500/2), (1024/2)-(350/2), 500, 350), rows, cols ,2, 0.0000001);
//    if(can)
//    //set new positions
//    for (IDCAtom* a in atoms) {
//        
//        //[atomContainer addSubview:a];
//        [a setNeedsDisplay];
//        a.desiredPoint = a.self.frame.origin;
//    }
    
    workComplete = YES;
    //a callback for frame update
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCalled)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //display refresh rate
    [displayLink setFrameInterval:1];
    
    carouselContainer = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    carouselContainer.delegate = self;
    carouselContainer.dataSource = self;
    carouselContainer.type = iCarouselTypeCustom;
    carouselContainer.scrollSpeed = 0.5f;
    carouselContainer.decelerationRate = 0.98f;
    [self.view addSubview:carouselContainer];
    
    [self.view sendSubviewToBack:carouselContainer];
    
    

}

-(void)displayLinkCalled
{
    //update display
//    timeSinceLastUpdate = [displayLink timestamp]-lastTimeStamp;
//    lastTimeStamp = [displayLink timestamp];
    if (workComplete){
        workComplete = false;
        @try {
            [self updateScene];
            workComplete = true;
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception reason]);
            NSLog(@"%@", [exception userInfo]);
        } }
}

-(void) updateScene{
    for (IDCAtom* a in atoms) {
        [a doFloatAnimation:[displayLink timestamp]];
        [a setNeedsDisplay];
    }
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    CGPoint newLocation = [recognizer locationInView:self.view];
        
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        
        if(lastContainer != recognizer.view)
        {
            [atomDiamondContainer removeFromSuperview];
            [atomHandContainer removeFromSuperview];
            [atomRingContainer removeFromSuperview];
            if(recognizer.view == diamond)
                [atomContainer addSubview:atomDiamondContainer];
            else if(recognizer.view == hand)
                [atomContainer addSubview:atomHandContainer];
            else if(recognizer.view == ring)
                [atomContainer addSubview:atomRingContainer];

        }
        
     //        savedLocation = newLocation;
        CGRect f = atomContainer.frame;
        //f.origin = CGPointMake((-768/2)+50,(-1024/2)+50);
        f.origin = [self.view convertPoint:CGPointZero toView:nil];
        //f.size
        atomContainer.frame = f;
        zoomContainer.alpha = 1.0;
    }
    
    CGFloat scale = recognizer.scale;
    
    //    self->diamond.transform = CGAffineTransformIdentity; // this alters view.frame! But *not* view.bounds
    //	self->diamond.bounds = CGRectApplyAffineTransform( self->diamond.bounds, CGAffineTransformMakeScale(scale, scale));
    //	[self->diamond setNeedsDisplay];
    
        CGAffineTransform transform = self.view.transform;
    if(scale>0.0)
    {
    recognizer.view.transform = CGAffineTransformScale(transform, scale, scale);
    if(scale>lastScale)
    zoomContainer.transform = CGAffineTransformScale(transform, scale-lastScale, scale-lastScale);
    atomContainer.transform = CGAffineTransformInvert(zoomContainer.transform);
    atomContainer.transform = CGAffineTransformScale(atomContainer.transform, scale, scale);
    }

    if(recognizer.numberOfTouches>=2)
    {
              
                
        zoomContainer.center = newLocation;
        atomContainer.center =  [self.view convertPoint:CGPointMake(768/2, 1024/2  ) toView:zoomContainer];

        
//        CGRect f = atomContainer.frame;
//        f.origin = CGPointMake(0,0);
//        atomContainer.frame = f;
        
//        savedLocation = newLocation;
        
    }
    
    
    //recognizer.scale=1;
    if (recognizer.state == UIGestureRecognizerStateEnded)  {
        [UIView animateWithDuration:0.5 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             recognizer.view.transform = CGAffineTransformScale(transform, 1, 1);
                             zoomContainer.center = CGPointMake(768/2, 1024/2);
                              atomContainer.center =  [self.view convertPoint:CGPointMake(768/2, 1024/2  ) toView:zoomContainer];
                             zoomContainer.transform = CGAffineTransformScale(transform, 0.1, 0.1);
                             
                         }
                         completion:^(BOOL finihshed){
                             //[diamond setNeedsDisplay];
                             lastScale = 1.0;
                             //savedLocation = CGPointZero;
                             zoomContainer.alpha = 0.0;
                         }];
        
        return;
    }
}

//-(BOOL)shouldAutorotate
//{
//    return NO;
//}
//- (BOOL)shouldAutomaticallyForwardRotationMethods
//{
//    return NO;
//}
//
//- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
//    return NO;
//}
//
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return  UIInterfaceOrientationMaskPortrait;
//}

//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationPortrait;
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [images count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
//    UILabel *label = nil;
//    
//    //create new view if no view is available for recycling
//    if (view == nil)
//    {
//        //don't do anything specific to the index within
//        //this `if (view == nil) {...}` statement because the view will be
//        //recycled and used with other index values later
//        view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)] autorelease];
//        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
//        view.contentMode = UIViewContentModeCenter;
//        
//        label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [label.font fontWithSize:50];
//        label.tag = 1;
//        [view addSubview:label];
//    }
//    else
//    {
//        //get a reference to the label in the recycled view
//        label = (UILabel *)[view viewWithTag:1];
//    }
//    
//    //set item label
//    //remember to always set any properties of your carousel item
//    //views outside of the `if (view == nil) {...}` check otherwise
//    //you'll get weird issues with carousel item content appearing
//    //in the wrong place in the carousel
//    label.text = [[items objectAtIndex:index] stringValue];
    
    return images[index];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionSpacing:
            return value * 0.7f;
            break;
         case iCarouselOptionAngle:
            return value*1.0f;
            break;
//        case iCarouselOptionFadeMax:
//            return 0.2f;
//            break;
//        case iCarouselOptionFadeMin:
//            return 0.0f;
//            break;
//        case iCarouselOptionFadeRange:
//            return 2.0f;
//            break;
        case iCarouselOptionWrap:
            return NO;
        default:
            break;
    }
    
    return value;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    const CGFloat centerItemZoom = 1.5;
    const CGFloat centerItemSpacing = 1.23;
    
    CGFloat spacing = [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:1.0f];
    CGFloat absClampedOffset = MIN(1.0, fabs(offset));
    CGFloat clampedOffset = MIN(1.0, MAX(-1.0, offset));
    CGFloat scaleFactor = 1.0 + absClampedOffset * (1.0/centerItemZoom - 1.0);
    offset = (scaleFactor * offset + scaleFactor * (centerItemSpacing - 1.0) * clampedOffset) * carousel.itemWidth * spacing;
    
    if (carousel.vertical)
    {
        transform = CATransform3DTranslate(transform, 0.0f, offset, -absClampedOffset);
    }
    else
    {
        transform = CATransform3DTranslate(transform, offset, 0.0f, -absClampedOffset);
    }
    
    transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1.0f);
    
    return transform;
}


@end
