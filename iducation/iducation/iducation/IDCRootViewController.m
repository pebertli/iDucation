//
//  IDCRootViewController.m
//  iducation
//
//  Created by pebertli on 14/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCRootViewController.h"
#import "IDCSlide.h"
#import "IDCIndexCell.h"
#import "IDCConstants.h"

@interface IDCRootViewController ()

@end

@implementation IDCRootViewController

@synthesize indexController;
@synthesize noteViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        slides = [NSMutableArray array];
        noteButtons = [NSMutableArray array];
        
        existSlideChangeTimer = NO;
        
        lockNextButton = NO;
        lockPreviousButton = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setWantsFullScreenLayout:YES];
    
    //Load slides, but not allocate their viewControllers
    [self loadSlides];
    //alloc, init and show the first slide
    if([slides count]>0)
    {
        IDCSlide* slide = [slides objectAtIndex:0];
        [slide allocateAndInitController];
        [self.view insertSubview:slide.viewController.view belowSubview:self.indexButton];
        currentSlideIndex = 0;
        
        
    }
    isMenuShowing = NO;
    isIndexShowing = NO;
    isNoteViewShowing = NO;
    self.indexButton.alpha = 0;
    
    //manual button positioning
    //    self.menuButton.frame = CGRectMake((WIDTH_IPAD/2)-(WIDTH_NAVIGATION_BUTTON_IPAD/2), HEIGHT_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
    //    self.indexButton.frame = CGRectMake((WIDTH_IPAD/2)-(WIDTH_NAVIGATION_BUTTON_IPAD/2), HEIGHT_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
    //    self.previousButton.frame = CGRectMake((WIDTH_IPAD/2)-(WIDTH_NAVIGATION_BUTTON_IPAD/2)-X_OFFSET_NAVIGATION_BUTTON_IPAD, HEIGHT_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
    //    self.nextButton.frame = CGRectMake((WIDTH_IPAD/2)-(WIDTH_NAVIGATION_BUTTON_IPAD/2)+X_OFFSET_NAVIGATION_BUTTON_IPAD, HEIGHT_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
    
    [self rotateInterfaceToOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    
    //load index controller
    indexController = [[IDCIndexViewController alloc] initWithNibName:@"IDCIndexViewController" bundle:nil rootController:self];
    indexController.view.frame = CGRectMake(0, HEIGHT_IPAD, WIDTH_IPAD, HEIGHT_IPAD);
    
    //load note view controller
    noteViewController = [[IDCNoteViewController alloc] initWithNoteViewFrame:CGRectMake(0, 0, WIDTH_NOTE_VIEW_IPAD, HEIGHT_NOTE_VIEW_IPAD)];
    
    //load paint view controller
    paintViewController = [[IDCPaintViewController alloc] initWithNibName:@"IDCPaintViewController" bundle:nil];
    
    //load topBar
    topBar = [[IDCTopBar alloc] initWithFrame:CGRectMake(0,-30, 768, 30)];
    [topBar.textSelection addTarget:self
                             action:@selector(pressedButtonTextSelection:)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:topBar aboveSubview:self.menuButton];
    
    //Gesture for previous/next action in menu button
    //Pan
    //    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMenu:)];
    //    [panGesture setMaximumNumberOfTouches:2];
    //    [panGesture setDelegate:self];
    //    [self.menuButton addGestureRecognizer:panGesture];
    //diferente gestures for 3 directions of swipe
    //    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMenu:)];
    //    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    //    [swipeGesture setDelegate:self];
    //    [self.menuButton addGestureRecognizer:swipeGesture];
    //
    //    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMenu:)];
    //    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    //    [swipeGesture setDelegate:self];
    //    [self.menuButton addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeMenu:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeGesture setDelegate:self];
    [self.menuButton addGestureRecognizer:swipeGesture];
    
    //    UILongPressGestureRecognizer* longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longNavigation:)];
    //    [longGesture setDelegate:self];
    //    [self.previousButton addGestureRecognizer:longGesture];
    //    [self.nextButton addGestureRecognizer:longGesture];
    
    [self registerForKeyboardNotifications];
}

- (void) setMenuPositionForOrientation:(UIInterfaceOrientation) orientation
{
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        [UIView animateWithDuration:LONG_TIME_INTERVAL animations:^{
            self.indexButton.frame = CGRectMake(HEIGHT_IPAD-X_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD, WIDTH_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-WIDTH_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
            
            self.menuButton.frame = CGRectMake(HEIGHT_IPAD-X_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD, WIDTH_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-WIDTH_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
            
            self.nextButton.frame = CGRectMake(HEIGHT_IPAD-X_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD+X_OFFSET_NAVIGATION_BUTTON_IPAD, WIDTH_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD);
            
            self.previousButton.frame = CGRectMake(HEIGHT_IPAD-X_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD - (HEIGHT_NAVIGATION_BUTTON_IPAD*2)-X_OFFSET_NAVIGATION_BUTTON_IPAD, WIDTH_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD);

        }];
        
        
    }
    else
    {
         [UIView animateWithDuration:LONG_TIME_INTERVAL animations:^{
        self.indexButton.frame = CGRectMake(WIDTH_IPAD-X_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
        
        self.menuButton.frame = CGRectMake(WIDTH_IPAD-X_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
        
        self.nextButton.frame = CGRectMake(WIDTH_IPAD-X_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD+X_OFFSET_NAVIGATION_BUTTON_IPAD, HEIGHT_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
        
        self.previousButton.frame = CGRectMake(WIDTH_IPAD-X_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD - (WIDTH_NAVIGATION_BUTTON_IPAD*2)-X_OFFSET_NAVIGATION_BUTTON_IPAD, HEIGHT_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
         }];
    }
}

- (void)registerForKeyboardNotifications
{
    //delegate callbacks for keyboard show/hidden
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) closePaintViewClicked
{
    [self showPaintView:NO animated:YES];
    topBar.textSelection.selected = NO;
    isTextSelecionEnable = NO;
}


- (void) animateView:(UIView*) view withFrame: (CGRect) newFrame withAlpha: (float) newAlpha withDuration:(float) duration removeWhenComplete:(UIView*) remove
{
    [UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.frame = newFrame;
                         view.alpha = newAlpha;
                     }
                     completion:^(BOOL finished){
                         if(remove)
                             [remove removeFromSuperview];
                     }];
    
}

- (void)panMenu:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    
    //If the pan process ended, animate menu button back to original position and return from method
    if([gestureRecognizer state] == UIGestureRecognizerStateEnded || [gestureRecognizer state] == UIGestureRecognizerStateCancelled || [gestureRecognizer state] == UIGestureRecognizerStateFailed)
    {
        existSlideChangeTimer = false;
        if(slideChangeTimer)
        {
            [slideChangeTimer invalidate];
            slideChangeTimer = nil;
        }
        
        CGRect newFrame = CGRectMake((WIDTH_IPAD/2)-(WIDTH_NAVIGATION_BUTTON_IPAD/2), HEIGHT_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
        [self animateView:self.menuButton withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
        
        return;
    }
    
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged || [gestureRecognizer state]==UIGestureRecognizerStateRecognized) {
        
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        CGPoint newCenter = CGPointMake([piece center].x + translation.x, [piece center].y);
        //Limits for pan menu button
        if(newCenter.x>X_LIMIT_CENTER_MENU_BUTTON_IPAD
           && newCenter.x<WIDTH_IPAD-X_LIMIT_CENTER_MENU_BUTTON_IPAD)
        {
            if(existSlideChangeTimer)
                existSlideChangeTimer = false;
            if(slideChangeTimer){
                [slideChangeTimer invalidate];
                slideChangeTimer = nil;
            }
            
            [piece setCenter:newCenter];
            [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
            
        }
        else{
            //if the button is in the right limit, the call next slide
            if(newCenter.x>=WIDTH_IPAD-X_LIMIT_CENTER_MENU_BUTTON_IPAD && !existSlideChangeTimer)
            {
                
                existSlideChangeTimer = YES;
                slideChangeTimer = [NSTimer scheduledTimerWithTimeInterval:SHORT_TIME_INTERVAL target:self selector:@selector(pressedButtonNextSlide:) userInfo:nil repeats:YES];
                [piece setCenter:CGPointMake(WIDTH_IPAD-X_LIMIT_CENTER_MENU_BUTTON_IPAD, newCenter.y)];
                
            }
            //if the button is in the left limit, the call previous slide
            if(newCenter.x<=X_LIMIT_CENTER_MENU_BUTTON_IPAD && !existSlideChangeTimer)
            {
                existSlideChangeTimer = YES;
                slideChangeTimer = [NSTimer scheduledTimerWithTimeInterval:SHORT_TIME_INTERVAL target:self selector:@selector(pressedButtonPreviousSlide:) userInfo:nil repeats:YES];
                [piece setCenter:CGPointMake(X_LIMIT_CENTER_MENU_BUTTON_IPAD, newCenter.y)];
            }
            
            
        }
    }
}

- (void)swipeMenu:(UISwipeGestureRecognizer *)gestureRecognizer
{
    //call the right message for each direction
    //    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
    //        [self pressedButtonPreviousSlide:self.previousButton];
    //    }
    //    else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
    //    {
    //        [self pressedButtonNextSlide:self.nextButton];}
    //
    //    else
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self pressedButtonIndex:self.indexButton ];
    }
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //    if (gestureRecognizer.view == self.menuButton && gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]
    //        && otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class] )
    
    //reconize any combination of multiple gestures
    return YES;
}

- (void)loadSlides
{
    //Manual load, maybe a xml load would be better
    
    
    
//    slides = [[NSMutableArray alloc] initWithObjects:[[IDCSlide alloc] init],[[IDCSlide alloc] init],
//              [[IDCSlide alloc] init], [[IDCSlide alloc] init], [[IDCSlide alloc] init],[[IDCSlide alloc] init],[[IDCSlide alloc] init], nil];
    
    slides = [[NSMutableArray alloc] init];
    
    IDCSlide* slide;
    for(int i = 0; i<17; i++)
    {
        
        slide = [[IDCSlide alloc] init];
        slide.nibName = @"IDCSlide1";
        slide.label = [NSString stringWithFormat:@"Slide %d",i+1];
        slide.pageNumber = i+1;
        
        [slides addObject:slide];
    }
    
    ////seven
    slide = [slides objectAtIndex:0];
    slide.className = @"Slide1ViewController";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    for(int i = 0; i<[slides count];i++){
        if(i!=currentSlideIndex)
        {
            IDCSlide* slide = [slides objectAtIndex:i];
            slide.viewController = nil;
        }
    }
}

- (void)showMenuAnimated:(BOOL) show{
    
    
    //show/hide system status bar
    [[UIApplication sharedApplication] setStatusBarHidden:!show withAnimation:UIStatusBarAnimationSlide];
    
    
    if(show)
    {
        //Show Menu
        // Fade in the view right away
        //        CGRect newFrame = self.previousButton.frame;
        //        newFrame.origin.x -= X_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD;
        //        [self animateView:self.previousButton withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
        //
        //        newFrame = self.nextButton.frame;
        //        newFrame.origin.x += X_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD;
        //        [self animateView:self.nextButton withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
        
        CGRect newFrame = self.indexButton.frame;
        newFrame.origin.y -= Y_OFFSET_CENTER_INDEX_BUTTON_IPAD+newFrame.size.height;
        [self animateView:self.indexButton withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
        
                newFrame = topBar.frame;
                newFrame.origin.y = 20;
                [self animateView:topBar withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
        
    }
    else
    {
        // Fade out the view right away
        //        CGRect newFrame = CGRectMake((WIDTH_IPAD/2)-(WIDTH_NAVIGATION_BUTTON_IPAD/2)-X_OFFSET_NAVIGATION_BUTTON_IPAD, HEIGHT_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
        //        [self animateView:self.previousButton withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
        //
        //        newFrame = CGRectMake((WIDTH_IPAD/2)-(WIDTH_NAVIGATION_BUTTON_IPAD/2)+X_OFFSET_NAVIGATION_BUTTON_IPAD, HEIGHT_IPAD-HEIGHT_NAVIGATION_BUTTON_IPAD-Y_OFFSET_CENTER_NAVIGATION_BUTTON_IPAD, WIDTH_NAVIGATION_BUTTON_IPAD, HEIGHT_NAVIGATION_BUTTON_IPAD);
        //        [self animateView:self.nextButton withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
        
        CGRect newFrame = self.indexButton.frame;
        newFrame.origin.y +=Y_OFFSET_CENTER_INDEX_BUTTON_IPAD+newFrame.size.height;
        [self animateView:self.indexButton withFrame:newFrame withAlpha:0.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
        
                newFrame = topBar.frame;
                newFrame.origin.y = -Y_OFFSET_CENTER_TEXT_SELECTION_BUTTON_IPAD;
                [self animateView:topBar withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
        
        
    }
    
    
}

- (void)pressedButtonMenu:(id)sender
{
    //animate menu
    [self showMenuAnimated:!isMenuShowing];
    isMenuShowing=!isMenuShowing;
    //hide index
    [self showIndexView:NO];
    isIndexShowing=NO;
    
}


- (void)pressedButtonIndex:(id)sender{
    //animate index
    [self showIndexView:!isIndexShowing];
    isIndexShowing=!isIndexShowing;
    //hide menu
    [self showMenuAnimated:NO];
    isMenuShowing=NO;
    [self showPaintView:NO animated:NO];
}

- (void)showIndexView:(BOOL) show
{
    if(indexController && indexController.view)
    {
        IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
        
        if(show)
        {
            
            CGRect newFrame = indexController.view.frame;
            newFrame.origin.y = 0;
            [self animateView:self.indexController.view withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
            
            [self.view insertSubview:indexController.view aboveSubview:currentSlide.viewController.view];
            [self.view insertSubview:currentSlide.viewController.view belowSubview:indexController.view];
        }
        else{
            
            CGRect newFrame = indexController.view.frame;
            newFrame.origin.y = HEIGHT_IPAD;
            [self animateView:self.indexController.view withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:self.indexController.view];
            
        }
        
    }
}

- (void)showNoteView:(BOOL) show withPosition:(CGPoint) position
{
    if(noteViewController && noteViewController.view)
    {
        if(show)
        {
            CGRect newFrame = noteViewController.containerView.frame;
            newFrame.origin = position;
            [self animateView:noteViewController.containerView withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
            newFrame = noteViewController.view.frame;
            [self animateView:noteViewController.view withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:nil];
            
        }
        else{
            CGRect newFrame = noteViewController.containerView.frame;
            newFrame.origin = position;
            [self animateView:noteViewController.containerView withFrame:newFrame withAlpha:0.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:noteViewController.view];
        }
        
    }
}

- (void) showSlideAtIndex:(NSUInteger) index{
    if(index< [slides count])
    {
        IDCSlide* targetSlide = [slides objectAtIndex:index];
        IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
        
        //allocate and init if the memory managemente dispose that before or if it is the first time showing
        if(targetSlide.viewController == nil)
        {
            [targetSlide allocateAndInitController];
            
        }
        //show the slide
        currentSlideIndex = index;
        [UIView transitionFromView:currentSlide.viewController.view toView:targetSlide.viewController.view duration:FAIR_TIME_INTERVAL options:UIViewAnimationOptionTransitionCurlDown completion:^(BOOL finished)
         {
             [self bringNavigationToFront];
         }];
        
        //hide index
        [self showIndexView:NO];
        isIndexShowing=NO;
        
        //update notes for new slide
        if(isTextSelecionEnable)
        {
            [self showNoteButtons:NO];
            [self showNoteButtons:YES];
            
        }
        
    }
}

- (void) bringNavigationToFront
{
    [self.view bringSubviewToFront:self.previousButton];
    [self.view bringSubviewToFront:self.nextButton];
    [self.view bringSubviewToFront:self.menuButton];
    [self.view bringSubviewToFront:self.indexButton];
}


- (void) previousSlide
{
    //If is not the first slide
    if(currentSlideIndex>0)
    {
        IDCSlide* previousSlide = [slides objectAtIndex:currentSlideIndex-1];
        IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
        
        currentSlideIndex--;
        
        //allocate and init
        if(previousSlide.viewController == nil)
        {
            [previousSlide allocateAndInitController];
            
        }
        //show the slide
        
        
        CGRect newFrame = previousSlide.viewController.view.frame;
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        {
            newFrame.origin.x = -HEIGHT_IPAD;
            
        }
        else
        {
            newFrame.origin.x = -WIDTH_IPAD;
        }
        
        [previousSlide.viewController changeOrientationTo:interfaceOrientation withAnimation:NO];

        previousSlide.viewController.view.frame = newFrame;
        [self.view insertSubview:previousSlide.viewController.view aboveSubview:currentSlide.viewController.view];
        newFrame.origin.x = 0.0;
        //        [self animateView:previousSlide.viewController.view withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:currentSlide.viewController.view];
        //
        //
        //        [self.view insertSubview:previousSlide.viewController.view aboveSubview:currentSlide.viewController.view];
        
        [UIView animateWithDuration:SHORT_TIME_INTERVAL delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             previousSlide.viewController.view.frame = newFrame;
                             previousSlide.viewController.view.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             
                             lockPreviousButton = NO;
                             [self bringNavigationToFront];
                             //consider remove from superview
                             
                         }];
        
        
        //hide index
        [self showIndexView:NO];
        isIndexShowing=NO;
        
        //update notes for new slide
        if(isTextSelecionEnable)
        {
            [self showNoteButtons:NO];
            [self showNoteButtons:YES];
            
        }
        
        [self showPaintView:NO animated:NO];
        topBar.textSelection.selected = NO;
        isTextSelecionEnable = NO;
        
    }
    else
        lockPreviousButton = NO;
    
}



- (void) nextSlide
{
    //If is not the last slide
    if([slides count]>currentSlideIndex+1)
    {
        IDCSlide* nextSlide = [slides objectAtIndex:currentSlideIndex+1];
        IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
        
        currentSlideIndex++;
        
        //allocate and init
        if(nextSlide.viewController == nil)
        {
            [nextSlide allocateAndInitController];
        }
        //show the slide
        
        
        CGRect newFrame = nextSlide.viewController.view.frame;
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        {
            newFrame.origin.x = HEIGHT_IPAD;

        }
        else
        {
            newFrame.origin.x = WIDTH_IPAD;
        }
        
        [nextSlide.viewController changeOrientationTo:interfaceOrientation withAnimation:NO];
        nextSlide.viewController.view.frame = newFrame;
        [self.view insertSubview:nextSlide.viewController.view aboveSubview:currentSlide.viewController.view];
        newFrame.origin.x = 0.0;
        //[self animateView:nextSlide.viewController.view withFrame:newFrame withAlpha:1.0 withDuration:SHORT_TIME_INTERVAL removeWhenComplete:currentSlide.viewController.view];
        
        
        [UIView animateWithDuration:SHORT_TIME_INTERVAL delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             nextSlide.viewController.view.frame = newFrame;
                             nextSlide.viewController.view.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             
                             lockNextButton = NO;
                             [self bringNavigationToFront];
                             //consider remove from superview
                             //[nextSlide.viewController.view removeFromSuperview];
                         }];
        
        
        //        [self.view insertSubview:nextSlide.viewController.view aboveSubview:currentSlide.viewController.view];
        
        //hide index
        [self showIndexView:NO];
        isIndexShowing=NO;
        
        //update notes for new slide
        if(isTextSelecionEnable)
        {
            [self showNoteButtons:NO];
            [self showNoteButtons:YES];
            
        }
        
        [self showPaintView:NO animated:NO];
        topBar.textSelection.selected = NO;
        isTextSelecionEnable = NO;
        
    }
    else
        lockNextButton = NO;
    
}

- (void) cancelNavigationTimer
{
    if(existSlideChangeTimer)
        existSlideChangeTimer = false;
    if(slideChangeTimer){
        [slideChangeTimer invalidate];
        slideChangeTimer = nil;
    }
    
}

- (IBAction)pressedDownButtonNextSlide:(id)sender
{
    if(!lockPreviousButton && !lockNextButton)
    {
        lockNextButton = YES;
        
        [self nextSlide];
        
        existSlideChangeTimer = YES;
        if(!slideChangeTimer.isValid)
            slideChangeTimer = [NSTimer scheduledTimerWithTimeInterval:SHORT_TIME_INTERVAL target:self selector:@selector(nextSlide) userInfo:nil repeats:YES];
    }
    
}

- (IBAction)pressedUpInsideButtonNextSlide:(id)sender
{
    
    [self cancelNavigationTimer];
}

- (IBAction)pressedUpOutsideButtonNextSlide:(id)sender
{
    [self cancelNavigationTimer];
}


- (IBAction)pressedDownButtonPreviousSlide:(id)sender
{
    if(!lockNextButton  && !lockPreviousButton)
    {
        lockPreviousButton = YES;
        [self previousSlide];
        
        existSlideChangeTimer = YES;
        
        if(!slideChangeTimer.isValid)
            slideChangeTimer = [NSTimer scheduledTimerWithTimeInterval:SHORT_TIME_INTERVAL target:self selector:@selector(previousSlide) userInfo:nil repeats:YES];
    }
}

- (IBAction)pressedUpInsideButtonPreviousSlide:(id)sender
{
    [self cancelNavigationTimer];
}

- (IBAction)pressedUpOutsideButtonPreviousSlide:(id)sender
{
    [self cancelNavigationTimer];
}

- (void)pressedButtonTextSelection:(UIButton *)sender{
    
    //Alter states and button content
    isTextSelecionEnable = !isTextSelecionEnable;
    topBar.textSelection.selected = isTextSelecionEnable;
    
    //    //enable text selection in textviews from slides and consequently disable touch in next responder (next responder is this controller)
    //    for(IDCSlide* s in slides){
    //        [s setEnableTextSelection:isTextSelecionEnable];
    //    }
    //
    //    //add custom menu controller
    //    [self registerCustomMenuForTextSelection:isTextSelecionEnable];
    //
    //    //show note icons
    //    [self showNoteButtons:isTextSelecionEnable];
    
    [self showMenuAnimated:NO];
    [self showPaintView:isTextSelecionEnable animated:YES];
    
}

- (void) showPaintView:(BOOL) show animated:(BOOL) animate
{
    
    if(paintViewController && paintViewController.view)
    {
        if(show)
        {
            IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
            
            //set the slide name to save or load image
            paintViewController.slide = [NSString stringWithFormat:@"slide_%d",currentSlideIndex];
            [paintViewController.canvas paintWithImage:paintViewController.slide];
            
            
            //show and insert
            if(animate)
            {
                CGRect newFrame = paintViewController.view.frame;
                newFrame.origin.y = 0;
                [self animateView:paintViewController.view withFrame:newFrame withAlpha:1.0 withDuration:LONG_TIME_INTERVAL removeWhenComplete:nil];
            }
            
            [self.view insertSubview:paintViewController.view aboveSubview:currentSlide.viewController.view];
            [self.view insertSubview:currentSlide.viewController.view belowSubview:paintViewController.view];
            
            [paintViewController.closeButton addTarget:self action:@selector(closePaintViewClicked) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else
        {
            if(paintViewController.canvas.modified)
                [paintViewController.canvas saveImage:paintViewController.slide];
            
            //hide and remove
            CGRect newFrame = paintViewController.view.frame;
            if(animate)
            {
                
                [self animateView:paintViewController.view withFrame:newFrame withAlpha:0.0 withDuration:LONG_TIME_INTERVAL removeWhenComplete:paintViewController.view];
            }
            else
                [paintViewController.view removeFromSuperview];
            
        }
        
    }
    
}

- (void) registerCustomMenuForTextSelection:(BOOL) enable{
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if(enable){
        //Re-add custom Menu Controller
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle: @"Note" action: @selector(addNote:)];
        UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle: @"Mark" action: @selector(addMark:)];
        UIMenuItem *item3 = [[UIMenuItem alloc] initWithTitle: @"Unmark" action: @selector(removeMark:)];
        
        [menuController setMenuItems: [NSArray arrayWithObjects: item1,item2,item3,nil]];
        
    }
    else{
        [menuController setMenuItems:nil];
    }
}

- (void) addNote: (id) sender{
    IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
    CGRect frame = currentSlide.viewController.getFirstSelectedTextRange;
    
    //configure frame for note position
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y+(frame.size.height/2));
    desiredNoteViewPosition = frame.origin;
    lineSize = frame.size.height;
    
    //if exist a note in this position, then request this text
    IDCNote* n = [currentSlide searchNoteWithPosition:desiredNoteViewPosition rangePoints:lineSize];
    if (n==nil) {
        noteViewController.noteView.text = @"";
    }
    else{
        noteViewController.noteView.text = n.text;
    }
    
    //Insert subview but it`s totally transparent
    noteViewController.view.alpha = 0;
    [self.view insertSubview:noteViewController.view aboveSubview:currentSlide.viewController.view];
    //    [self.view insertSubview:currentSlide.viewController.view belowSubview:noteViewController.view];
    isNoteViewShowing = YES;
    
    //Show keyboard and begin editing
    [noteViewController.noteView becomeFirstResponder];
}

- (void) addMark:(id) sender{
    IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
    
    //paint mark
    IDCTextView* tv = [currentSlide.viewController getFirstSelectedTextView];
    //generate the colors for gradient
    UIColor* colorStart = [UIColor colorWithRed:R_COLOR_GRADIENT_START_MARK_TEXT_THEME_DEFAULT green:G_COLOR_GRADIENT_START_MARK_TEXT_THEME_DEFAULT blue:B_COLOR_GRADIENT_START_MARK_TEXT_THEME_DEFAULT alpha:A_COLOR_GRADIENT_START_MARK_TEXT_THEME_DEFAULT];
    UIColor* colorEnd = [UIColor colorWithRed:R_COLOR_GRADIENT_END_MARK_TEXT_THEME_DEFAULT green:G_COLOR_GRADIENT_END_MARK_TEXT_THEME_DEFAULT blue:B_COLOR_GRADIENT_END_MARK_TEXT_THEME_DEFAULT alpha:A_COLOR_GRADIENT_END_MARK_TEXT_THEME_DEFAULT];
    
    //add new range selection
    [currentSlide.viewController addMarkedRangeFromSelection];
    //get the rects for each line
    NSArray* selectedLines = currentSlide.viewController.getRectsForLines;
    
    //clear the marked areas and readd then.(lazy solution)
    if(tv)
    {
        [tv clearMarkedAreas];
        for(NSValue* l in selectedLines){
            CGRect frame = [l CGRectValue];
            [tv addMarkedArea:frame withStartColor:colorStart endColor:colorEnd];
        }
        //redraw the textview to show new marks
        [tv setNeedsDisplay];
    }
    
}

- (void) removeMark:(id) sender{
    IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
    IDCTextView* tv = [currentSlide.viewController getFirstSelectedTextView];
    //generate the colors for gradient
    UIColor* colorStart = [UIColor colorWithRed:R_COLOR_GRADIENT_START_MARK_TEXT_THEME_DEFAULT green:G_COLOR_GRADIENT_START_MARK_TEXT_THEME_DEFAULT blue:B_COLOR_GRADIENT_START_MARK_TEXT_THEME_DEFAULT alpha:A_COLOR_GRADIENT_START_MARK_TEXT_THEME_DEFAULT];
    UIColor* colorEnd = [UIColor colorWithRed:R_COLOR_GRADIENT_END_MARK_TEXT_THEME_DEFAULT green:G_COLOR_GRADIENT_END_MARK_TEXT_THEME_DEFAULT blue:B_COLOR_GRADIENT_END_MARK_TEXT_THEME_DEFAULT alpha:A_COLOR_GRADIENT_END_MARK_TEXT_THEME_DEFAULT];
    
    //remove range selected
    [currentSlide.viewController removeMarkedRangeFromSelection];
    //get the rects for each line
    NSArray* selectedLines = currentSlide.viewController.getRectsForLines;
    
    //clear the marked areas and readd then.(lazy solution)
    [tv clearMarkedAreas];
    for(NSValue* l in selectedLines){
        CGRect frame = [l CGRectValue];
        [tv addMarkedArea:frame withStartColor:colorStart endColor:colorEnd];
    }
    //redraw the textview to show new marks
    [tv setNeedsDisplay];
    
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]
                     CGRectValue].size;
    
    if(isNoteViewShowing){
        //Frame from note view with origin from selected text
        CGRect frame = noteViewController.containerView.frame;
        frame.origin = desiredNoteViewPosition;
        noteViewController.containerView.frame = frame;
        //test if keyboard will be above note view
        if(frame.origin.y+frame.size.height+OFFSET_NOTE_VIEW_IPAD>HEIGHT_IPAD-kbSize.height)
        {
            frame.origin.y = HEIGHT_IPAD-kbSize.height-HEIGHT_NOTE_VIEW_IPAD-OFFSET_NOTE_VIEW_IPAD;
        }
        //test if not will be in right margin
        if(frame.origin.x+frame.size.width+OFFSET_NOTE_VIEW_IPAD>WIDTH_IPAD)
        {
            frame.origin.x = WIDTH_IPAD-WIDTH_NOTE_VIEW_IPAD-OFFSET_NOTE_VIEW_IPAD;
        }
        
        [self showNoteView:YES withPosition:frame.origin];
    }
    
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //Frame from note view with origin from selected text
    CGRect frame = noteViewController.containerView.frame;
    frame.origin = desiredNoteViewPosition;
    [self showNoteView:NO withPosition:frame.origin];
    //save the note
    
    //alter a note in this slide
    IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
    [currentSlide addRemoveOrChangeNoteWithText:noteViewController.noteView.text toPoint:desiredNoteViewPosition withTolerance:lineSize];
    
    //update note buttons
    [self showNoteButtons:NO];
    [self showNoteButtons:YES];
    
    
}

- (void) showNoteButtons:(BOOL) show{
    if(show)
    {
        IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
        //iterate over notes of current slide
        for(int i = 0; i<[currentSlide.notes count];i++){
            IDCNote* n = [currentSlide.notes objectAtIndex:i];
            //create a UIButton representing the note
            UIButton* b = [[UIButton alloc] initWithFrame:CGRectMake(X_MARGIN_POST_IT_IPAD, n.origin.y, WIDTH_POST_IT_IPAD, HEIGHT_POST_IT_IPAD)];
            [b setImage:[UIImage imageNamed:@"post_it.png"] forState:UIControlStateNormal];
            //the new button reponds to "click"
            [b addTarget:self action:@selector(pressedNoteViewButton:) forControlEvents:UIControlEventTouchUpInside];
            //save the index in array in label for posterior retrieving
            b.titleLabel.text = [NSString stringWithFormat:@"%d",i];
            [noteButtons addObject:b];
            //visualize without animation
            [self.view addSubview:b];
        }
    }
    else{
        //remove all buttons from root view, memory and array
        for (int i = 0; i<[noteButtons count];i++) {
            UIButton* b = [noteButtons objectAtIndex:i];
            [b removeFromSuperview];
            b = nil;
        }
        [noteButtons removeAllObjects];
    }
    
}

- (void) pressedNoteViewButton:(id) sender{
    
    IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
    int index = [((UIButton*)sender).titleLabel.text intValue];
    //configure the note view to show the stored note
    desiredNoteViewPosition = ((IDCNote*)[currentSlide.notes objectAtIndex:index]).origin;
    noteViewController.noteView.text = ((IDCNote*)[currentSlide.notes objectAtIndex:index]).text;
    
    //user clicked in the note button from current note
    if (isNoteViewShowing) {
        //nested animation for a bump effect
        [UIView animateWithDuration:SHORT_TIME_INTERVAL/3 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = noteViewController.containerView.frame;
                             frame.origin.x+=20;
                             noteViewController.containerView.frame = frame;
                             
                             [UIView animateWithDuration:SHORT_TIME_INTERVAL/3 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  CGRect frame = noteViewController.containerView.frame;
                                                  frame.origin.x-=40;
                                                  noteViewController.containerView.frame = frame;
                                                  
                                                  
                                                  [UIView animateWithDuration:SHORT_TIME_INTERVAL/3 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                                                                   animations:^{
                                                                       CGRect frame = noteViewController.containerView.frame;
                                                                       
                                                                       frame.origin.x+=20;
                                                                       noteViewController.containerView.frame = frame;
                                                                       
                                                                       
                                                                   }
                                                                   completion:nil];
                                                  
                                                  
                                              }
                                              completion:nil];
                             
                             
                         }
                         completion:nil];
        
    }
    else
    {
        //Insert subview but it`s totally transparent
        noteViewController.view.alpha = 0;
        [self.view insertSubview:noteViewController.view aboveSubview:currentSlide.viewController.view];
        //    [self.view insertSubview:currentSlide.viewController.view belowSubview:noteViewController.view];
        isNoteViewShowing = YES;
        
        //Show keyboard and begin editing
        [noteViewController.noteView becomeFirstResponder];
    }
    
}

//user clicked in self.view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //hide menu
    if(isMenuShowing)
    {
        [self showMenuAnimated:NO];
        isMenuShowing = NO;
    }
    //hide keyboard and chain to hide note view
    if(isNoteViewShowing)
    {
        [noteViewController.noteView resignFirstResponder];
        isNoteViewShowing = NO;
    }
    //hide index
    if(isIndexShowing){
        [self showIndexView:NO];
        isIndexShowing = false;
    }
}

#pragma mark -
#pragma mark Text View Data Source Methods

- (void)textViewDidChange:(UITextView *)textView{
    
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //number of slides
    return [slides count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* simpleTableIndentifier = @"IDCIndexCellIdentifier";
    
    //try to get a recycled cell
    IDCIndexCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIndentifier];
    //create a new cell if the attempt to get the recycled failed
    if (cell==nil) {
        cell = [[IDCIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIndentifier];
    }
    
    NSUInteger rowIndex = [indexPath row];
    
    //cofigure cells according to Slide
    cell.titleView.text = [(IDCSlide*)[slides objectAtIndex:rowIndex] label] ;
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger rowIndex = indexPath.row;
    
    //if you trying selecting the current page, just hide the index
    if(rowIndex==currentSlideIndex)
    {
        [self showIndexView:NO];
        isIndexShowing=NO;
    }
    else
        if(rowIndex<[slides count])
        {
            [self showSlideAtIndex:rowIndex];
        }
    //remove selection after touch
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark Orientation

- (BOOL)shouldAutorotate
{
    return YES;
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//   
//}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
     [self rotateInterfaceToOrientation:toInterfaceOrientation];
}

- (void) rotateInterfaceToOrientation:(UIInterfaceOrientation) toInterfaceOrientation
{
    IDCSlide* currentSlide = [slides objectAtIndex:currentSlideIndex];
    [currentSlide.viewController changeOrientationTo:toInterfaceOrientation withAnimation:YES];
    [self setMenuPositionForOrientation:toInterfaceOrientation];
}


@end
