//
//  IDCDaltonViewController.m
//  dalton.combinations
//
//  Created by pebertli on 22/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCDaltonViewController.h"
#import "IDCAtom.h"
#import "IDCConstants.h"

@interface IDCDaltonViewController ()

@end

@implementation IDCDaltonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
               
        

    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    combinating = NO;
    
    lastTimeStamp = 0.0;
    timeSinceLastUpdate = 0.0;
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.view.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    
    //set of atoms
    nature = [[IDCNature alloc] init];
    [nature addAtomnsOf:@"C" withScale:1 amount:1];
    [nature addAtomnsOf:@"O" withScale:0.75 amount:4];
    [nature addAtomnsOf:@"S" withScale:1.25 amount:2];
    [nature addAtomnsOf:@"H" withScale:0.5 amount:4];
    
    
    //distribute atoms in a 1024x768 with a auto scale
    randomizeViews([nature atoms], CGRectMake(0, 0, 768, 1024) , 0.00001);
    //set new positions
    for (IDCAtom* a in [nature atoms]) {
        [a setNeedsDisplay];
        [self.view addSubview:a];
        a.desiredPoint = CGPointMake(a.frame.origin.x, a.frame.origin.y);
        a.originalPoint = CGPointMake(a.frame.origin.x, a.frame.origin.y);
        
        //Pan
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [panGesture setMaximumNumberOfTouches:1];
        [panGesture setDelegate:self];
        [a addGestureRecognizer:panGesture];
    }
    workComplete = YES;
    //a callback for frame update
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCalled)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //display refresh rate
    [displayLink setFrameInterval:1];
    
    //set combinations
    HVTree* t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"C" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(0.0)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(180.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"C" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(30)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(90.0)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(150.0)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(270.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"C" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"S" angle:eulerToRadians(0.0)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"S" angle:eulerToRadians(180.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"S" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(270.0)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(30.0)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(150.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"S" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(30.0)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(150.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"C" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(0.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"S" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(150.0)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(30.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"O" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(150.0)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(30.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"H" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(180.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"S" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(270.0)]];
    HVTreeNode* c1 = [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(30.0)]];
    HVTreeNode* c2 = [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(150.0)]];
    [c1 addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(0.0)]];
    [c2 addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(180.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"C" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(270.0)]];
    c1 = [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(30.0)]];
    c2 = [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(150.0)]];
    [c1 addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(0.0)]];
    [c2 addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(180.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"O" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(180.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"O" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(180.0)]];
    c1 = [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(0.0)]];
    [c1 addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(0.0)]];
    [nature addCombination:t];
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"S" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(270.0)]];
    c1 = [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(30.0)]];
    c2 = [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(150.0)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(90.0)]];
    [c1 addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(0.0)]];
    [c2 addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"H" angle:eulerToRadians(180.0)]];
    [nature addCombination:t];
    
    
    t = [[HVTree alloc] init];
    t.root.value = [[IDCAtomCombination alloc] initWithElement:@"O" angle:0];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(30.0)]];
    [t.root addChildWithValue: [[IDCAtomCombination alloc] initWithElement:@"O" angle:eulerToRadians(150.0)]];
    [nature addCombination:t];
    
    //double tap gesture
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [doubleTapGesture setDelegate:self];
    [self.view addGestureRecognizer:doubleTapGesture];
    
    fadeView = [[UIView alloc] initWithFrame:self.view.frame];
    fadeView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1.0];
    fadeView.alpha = 0.0;
    
    cross = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross_red.png"]];
    cross.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cross.alpha = 0.0;
    [self.view addSubview:cross];
    
    [self.view addSubview:fadeView];
    
    flash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flash.png"]];
    flash.frame = CGRectMake(0 , 0, 100, 100);
    flash.center = CGPointMake(768/2, 1024/2);
    flash.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    flash.alpha = 0.0;
    flash.userInteractionEnabled = NO;
    [self.view addSubview:flash];
    
    
    //sphrere surface
    /*
     NSMutableArray* points = [[NSMutableArray alloc] init];
     double phi = ((double) arc4random()/RAND_MAX)*((2*M_PI)-0)+0;
     for (int i = 0; i<40; i++) {
     //        UIImage* im = [UIImage imageNamed:@"energy.png"];
     //        UIImageView* e = [[UIImageView alloc] initWithFrame:CGRectMake(768/2, 1024/2, 60, 60)];
     //        e.image = im;
     //        [self.view addSubview:e];
     
     double r = 200.0;
     double z = randomBetween(-r/7, r );
     double theta = asin(z/r);
     
     double x = r*cos(theta) * cos(phi);
     double y = r*cos(theta) * sin(phi);
     phi += ((double) arc4random()/RAND_MAX)*((phi/900)-0)+0;
     
     [points addObject:[[HV3DPoint alloc] initWithX:x Y:y Z:z] ];
     
     //        CATransform3D transform = e.layer.transform;
     //        transform.m34 = -1.0f/400.0f;
     //        transform = CATransform3DTranslate(transform,x,y,z);
     //        e.layer.transform = transform;
     
     }
     */

    
}

- (void) resetCombinations{
    
    //return fade view to original state
    [UIView animateWithDuration:FAIR_TIME_INTERVAL delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         fadeView.alpha = 0.0;
                     }
                     completion:^(BOOL finihshed){
                         alphaAnimation = NO;
                     }];
    
    
    
    NSMutableArray* combinatedAtoms = [nature getAtomsWithState:IDCAtomStateCombinated];
    [combinatedAtoms addObjectsFromArray:[nature getAtomsWithState:IDCAtomStateCombinating]];
    //put the combinated and combinating atoms to original position
    for (IDCAtom* a in combinatedAtoms) {
        a.currentAnimationTime = 0.0;
        a.desiredPoint = a.originalPoint;
        a.glowView.alpha = 0.0;
    }
    
    //also reset touched atoms
    NSArray* touchedAtoms = [nature getAtomsWithState:IDCAtomStateTouched];
    for (IDCAtom* a in touchedAtoms) {
        a.state = IDCAtomStateNormal;
        a.glowView.alpha = 0.0;
        [a.energizedSound stopWithCrossfade:0.5];
        [a pauseEnergyParticles:YES];
    }
    
}

- (void)doubleTap:(UITapGestureRecognizer *)gestureRecognizer{
    
    [self resetCombinations];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateChanged || [gestureRecognizer state]==UIGestureRecognizerStateEnded) {
        
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        CGPoint newCenter = CGPointMake([piece center].x + translation.x, [piece center].y+translation.y);
        //Limits for pan menu button
        if(newCenter.x<WIDTH_IPAD && newCenter.x>0 && newCenter.y<HEIGHT_IPAD && newCenter.y>0)
        {
            [piece setCenter:CGPointMake(newCenter.x, newCenter.y)];
            [gestureRecognizer setTranslation:CGPointZero inView:piece.superview];
            IDCAtom* a = (IDCAtom*)piece;
            a.originalPoint = centerToOrigin(newCenter, a.frame);
        }
    }
}

-(void)displayLinkCalled
{
    //update display
    timeSinceLastUpdate = [displayLink timestamp]-lastTimeStamp;
    lastTimeStamp = [displayLink timestamp];
    if (workComplete){
        workComplete = false;
        @try {
            [self updateScene];
            workComplete = true; }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception reason]);
            NSLog(@"%@", [exception userInfo]);
        } }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) endTimer
{
    //non loop timer
    [atomTouchedTimer invalidate];
}

-(void) updateScene
{
    NSArray* touchedAtoms = [nature getAtomsWithState:IDCAtomStateTouched];
    NSArray* possibleMatches = [nature matchedCombination:touchedAtoms];
    HVTree* tree = [possibleMatches objectAtIndex:0];
    
    //if there is no a exactly match and no one possible matches
    if([tree isKindOfClass:[NSNull class] ] && [possibleMatches count]==1)
    {
        //wrong feedback with red cross
        NSArray* touchedAtoms = [nature getAtomsWithState:IDCAtomStateTouched];
        [self.view bringSubviewToFront:cross];
        for (IDCAtom* a in touchedAtoms) {
            [UIView animateWithDuration:FAIR_TIME_INTERVAL delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cross.alpha = 1.0;                             }
                             completion:^(BOOL finihshed){
                                 [UIView animateWithDuration:FAIR_TIME_INTERVAL delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      cross.alpha = 0.0;                             }
                                                  completion:^(BOOL finihshed){
                                                  }];
                                 
                             }];
            
            
            
            a.state = IDCAtomStateNormal;
                    [a.energizedSound stopWithCrossfade:0.5];
            [a pauseEnergyParticles:YES];
            a.glowView.alpha = 0.0;
        }
        
    }
    
    //if there is a exactly match and another possible matches
    if([tree isKindOfClass:[HVTree class] ] && [possibleMatches count]>1)
    {
        for (IDCAtom* a in touchedAtoms) {
            //start a timer to wait user choose another possible match
            if(a.touch)
            {
                [atomTouchedTimer invalidate];
                atomTouchedTimer = [NSTimer scheduledTimerWithTimeInterval:LONG_TIME_INTERVAL*2 target:self selector:@selector(endTimer) userInfo:nil repeats:NO];
            }
            //consume touch
            a.touch = false;
        }
    }
    //there is a exactly match and timer for another possible matches was expired
    if([tree isKindOfClass:[HVTree class] ] && ![atomTouchedTimer isValid] ){
        //set position for atom in combinations
        [nature prepareCombination:tree withAtoms:touchedAtoms];
        
        
        [self.view bringSubviewToFront:fadeView];
        for (IDCAtom* a in touchedAtoms)
        {
            a.state = IDCAtomStateCombinating;
            [a.energizedSound stopWithCrossfade:0.5];
            a.currentAnimationTime = 0.0;
            a.glowView.alpha = 0.0;
            [a pauseEnergyParticles:YES];
            [a resetImageAtCenter];
            [self.view bringSubviewToFront:a];
        }
        
        //animation for fade view
        [UIView animateWithDuration:FAIR_TIME_INTERVAL delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             fadeView.alpha = 0.8;
                         }
                         completion:^(BOOL finihshed){
                         }];
        
        //touched atoms now are combinated atoms
        combinating = NO;
        
    }
    
    
    //choose animation according state of the atom
    for (IDCAtom* a in [nature atoms]) {
        if(a.state == IDCAtomStateTouched)
        {
            [a doShakeAnimation:[displayLink timestamp]];
            [a doEnergyAnimation:[displayLink timestamp]];
            [a doGlowingAnimation:[displayLink timestamp]];
        }
        else if(a.state == IDCAtomStateNormal)
        {
            [a doFloatAnimation:[displayLink timestamp]];
        }
        else if(a.state == IDCAtomStateCombinated || a.state == IDCAtomStateCombinating)
        {
            [a doCombinationAnimation:timeSinceLastUpdate];
            
            //if just combinate, flash animation
            if(a.state == IDCAtomStateCombinated && !combinating)
            {
                combinating = YES;
                [self.view bringSubviewToFront:flash];
                [UIView animateWithDuration:FAIR_TIME_INTERVAL delay: 0.0 options: 0
                                 animations:^
                 {
                     flash.alpha = 1.0;
                     CGAffineTransform t = self.view.transform;
                     t = CGAffineTransformScale(t, 100, 100);
                     flash.transform = t;
                 }
                                 completion:^(BOOL finihshed)
                 {
                     
                     [UIView animateWithDuration:FAIR_TIME_INTERVAL delay: 0.1 options: 0
                                      animations:^
                      {
                          flash.alpha = 0.0;
                          CGAffineTransform t = self.view.transform;
                          t = CGAffineTransformScale(t, 1, 1);
                          flash.transform = t;
                          
                          //fadeView.alpha = 0.8;
                      }
                                      completion:^(BOOL finihshed)
                      {
                          
                      }];
                     
                 }];
            }
        }
        //
        //[a setNeedsDisplay];
    }
    
}

@end
