//
//  IDCViewController.m
//  bohrlayers
//
//  Created by pebertli on 17/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCViewController.h"
#import "IDCConstants.h"
#import "HVGeometry.h"
#import "HVUtils.h"

@interface IDCViewController ()

@end

@implementation IDCViewController

static CGFloat const LINE_WIDHT_LAYER     = 2.0f;
static CGFloat const SIZE_FIRST_LAYER           = 150.0f;
static CGFloat const SPACE_LAYER   = 100;
static CGFloat const ACCELERATION_ELETRON   = 2;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //    currentAnimationTime = 0.0;
    //    lastTeta = 0;
    //    lastVelocity = 2;
    
    eletronState = kStable;
    eletronShakePoint = CGPointZero;
    currentLayer = 0;
    lastLayer = 0;
    timeInitialTouch = 0;
    
    velocityUpdater1 = [[HVVelocity alloc] initWithInitialPosition:0 initialVelocity:2 acceleration:0 finalVelocity:0];
    velocityUpdater2 = [[HVVelocity alloc] initWithInitialPosition:0 initialVelocity:0 acceleration:6 finalVelocity:2];
    
    //trailView = [[PaintView alloc] initWithFrame:self.view.frame];
    //trailView.userInteractionEnabled = YES;
    //[self.view addSubview:trailView];

    
    for(int i = 0; i<3; i++)
    {
        float sizeLayer = (((i*SPACE_LAYER)+SIZE_FIRST_LAYER)*2)+LINE_WIDHT_LAYER;
        IDCBohrLayer* l = [[IDCBohrLayer alloc] initWithFrame:rectWithCenterAndSize(WIDTH_IPAD/2, HEIGHT_IPAD/2,sizeLayer, sizeLayer)];
        l.userInteractionEnabled = NO;
        l.isDashed = YES;
        l.color = [UIColor blackColor];
//        switch (i) {
//            case 0:
//                l.isDashed = NO;
//                l.color = [UIColor blackColor];
//                break;
//            case 1:
//                l.color = [UIColor blackColor];
//                break;
//            case 2:
//                l.color = [UIColor blackColor];
//                break;
//            case 3:
//                l.color = [UIColor yellowColor];
//                break;
//            default:
//                break;
//        }
        [self.view addSubview:l];
    }
    
        
    UIImage* image = [UIImage imageNamed:@"nucleus.png"];
    nucleus = [[UIImageView alloc] initWithImage:image];
    nucleus.center = CGPointMake(WIDTH_IPAD/2, HEIGHT_IPAD/2);
    nucleus.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.view addSubview:nucleus];
    
    image = [UIImage imageNamed:@"eletron.png"];
    eletron1 = [[UIImageView alloc] initWithImage:image];
    eletron1.center = pointAround(CGPointMake(WIDTH_IPAD/2, HEIGHT_IPAD/2), SIZE_FIRST_LAYER, eulerToRadians(0));
    //eletron1.frame = CGRectMake(eletron1.center.x, eletron1.center.y, 100, 100);
    //eletron1.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1 ];
//    eletron1.contentMode = UIViewContentModeCenter;
//    eletron1.layer.shouldRasterize = YES;
    
    image = [UIImage imageNamed:@"eletron.png"];
    eletron2 = [[UIImageView alloc] initWithImage:image];
    eletron2.center = pointAround(CGPointMake(WIDTH_IPAD/2, HEIGHT_IPAD/2), SIZE_FIRST_LAYER+SPACE_LAYER, eulerToRadians(0));
    eletron2.alpha = 0;
    
    
    eletron1.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.view addSubview:eletron1];
    
    eletron2.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.view addSubview:eletron2];
    
    
    eletronAnimated1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 313, 97)];
    eletronAnimated1.center = pointAround(CGPointMake(WIDTH_IPAD/2, HEIGHT_IPAD/2), 150, eulerToRadians(0));
    eletronAnimated1.animationDuration = 1.6;
    eletronAnimated1.animationRepeatCount = 1;
    eletronAnimated1.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    eletronAnimated2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 313, 97)];
    eletronAnimated2.center = pointAround(CGPointMake(WIDTH_IPAD/2, HEIGHT_IPAD/2), SIZE_FIRST_LAYER+SPACE_LAYER, eulerToRadians(0));
    eletronAnimated2.animationDuration = 1.6;
    eletronAnimated2.animationRepeatCount = 1;
    eletronAnimated2.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    
    frames = [[NSMutableArray alloc] init];
    framesInvert = [[NSMutableArray alloc] init];
    for (int i = 1; i<=22; i++) {
        NSString* frameName = [NSString stringWithFormat:@"Frame%02d.png",i];
        UIImage* im = [UIImage imageNamed:frameName];
        [frames addObject:im];
        
        frameName = [NSString stringWithFormat:@"Frame%02d.png",22-i+1];
        im = [UIImage imageNamed:frameName];
        [framesInvert addObject:im];
        
    }
    
//    eletronAnimated1.alpha = 0;
//    eletronAnimated2.alpha = 0;
    eletronAnimated1.animationImages=frames;
    [self.view addSubview:eletronAnimated1];
    eletronAnimated2.animationImages=framesInvert;
    [self.view addSubview:eletronAnimated2];
    
    flareBlue = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flare_blue.png"]];
    flareBlue.frame = CGRectMake(0 , 0, 100, 100);
    flareBlue.center = CGPointMake(768/2, 1024/2);
    flareBlue.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    flareBlue.alpha = 0.0;
    flareBlue.userInteractionEnabled = NO;
    [self.view addSubview:flareBlue];
    
    flareRed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flare_red.png"]];
    flareRed.frame = CGRectMake(0 , 0, 100, 100);
    flareRed.center = CGPointMake(768/2, 1024/2);
    flareRed.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    flareRed.alpha = 0.0;
    flareRed.userInteractionEnabled = NO;
    [self.view addSubview:flareRed];
    
    
    
    workComplete = YES;
    //a callback for frame update
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCalled)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //display refresh rate
    [displayLink setFrameInterval:1];
    
    self.view.userInteractionEnabled = YES;
    
    particleTrail = [[IDCParticleTrail alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:particleTrail];
    [particleTrail setIsEmitting:NO];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayLinkCalled
{
    //update display
    [displayLink duration];
    [displayLink timestamp];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //trailView.alpha = 1;
//    UITouch *touch = [touches anyObject];
    
    [particleTrail setIsEmitting:YES];
    [particleTrail setEmitterPositionFromTouch:[touches anyObject]];

    //[trailView touchesBegan:[touch locationInView:trailView]];
    NSArray *touchesArray = [touches allObjects];
    if([touchesArray count]>0)
    {
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
        initialTouch = [touch locationInView:self.view];
        timeInitialTouch = [event timestamp];
        
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [particleTrail setEmitterPositionFromTouch:[touches anyObject]];
    
   // UITouch *touch = [touches anyObject];
    //[trailView touchesMoved:[touch locationInView:trailView]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [particleTrail setIsEmitting:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [particleTrail setIsEmitting:NO];

    NSArray *touchesArray = [touches allObjects];
    if([touchesArray count]>0)
    {
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:0];
        finalTouch = [touch locationInView:self.view];
        
        if(eletronState==kStable && segmentTouchesRect(4, initialTouch, finalTouch, nucleus.frame))
        {
           //change to layer x>0
            eletronState = kLeavingFirstLayer;
            //v=d/s;
            double swipeVelocity = distance(initialTouch, finalTouch)/([event timestamp]-timeInitialTouch);
            
            if(swipeVelocity>100 && swipeVelocity<1700)
                [self changetoLayer:1];
            else
                if(swipeVelocity>=1700)
                                    [self changetoLayer:2];
            
        }
        
    
//    [UIView animateWithDuration:LONG_TIME_INTERVAL delay: 0.0 options: 0
//                     animations:^
//     {
//         //trailView.alpha = 0;
//     }
//                     completion:^(BOOL finihshed)
//     {
//     }];

    }
}

- (void) changetoLayer: (int) newLayer
{
        //switch frames
        if(currentLayer<newLayer)
        {
        eletronAnimated2.animationImages = framesInvert;
            eletronAnimated1.animationImages = frames;
        }
    //to layer 0
        else
        {
            eletronAnimated2.animationImages = frames;
            eletronAnimated1.animationImages = framesInvert;
        }


        //to layer 0
        if(currentLayer>newLayer)
        {
        //update velocity of the newlayer
        [velocityUpdater1 resetWithInitialPosition:velocityUpdater2.currentPosition initialVelocity:2 acceleration:6 finalVelocity:2];
        //change aceleration of the first layer (until stop)
        //velocityUpdater2.acceleration = -3;
            
            eletron2.alpha = 0;
            
            //wait to show of the eletron at the new layer after the dash animation
            [UIView animateWithDuration:0 delay:1.6 options:0 animations:^
             {
                 eletron1.alpha = 1;
             }
                             completion:^(BOOL finished)
             {
                 
             }];

        }
        else
        {
            //update velocity of the newlayer
            [velocityUpdater2 resetWithInitialPosition:velocityUpdater1.currentPosition initialVelocity:2 acceleration:6 finalVelocity:2];
            //change aceleration of the first layer (until stop)
            //velocityUpdater1.acceleration = -3;
            
            eletron1.alpha = 0;
            
            //wait to show of the eletron at the new layer after the dash animation
            [UIView animateWithDuration:0 delay:1.6 options:0 animations:^
             {
                 eletron2.alpha = 1;
             }
                             completion:^(BOOL finished)
             {
                 
             }];


        }
            
        //reset acc to count laps until the eletron returns to layer 0
        accLap = 0;
        [eletronAnimated1 startAnimating];
        [eletronAnimated2 startAnimating];
        
//    else
//    {
//        //switch frames
//        NSArray *framesAux = eletronAnimated1.animationImages;
//        eletronAnimated1.animationImages = eletronAnimated2.animationImages;
//        eletronAnimated2.animationImages = framesAux;
//        
//        [eletronAnimated1 startAnimating];
//        [eletronAnimated2 startAnimating];
//        
//        //update velocity of the newlayer
//        [velocityUpdater1 resetWithInitialPosition:velocityUpdater2.currentPosition initialVelocity:2 acceleration:6 finalVelocity:2];
//        //change aceleration of the first layer (until stop)
//        velocityUpdater2.acceleration = -6;
//
//        
//        eletron2.alpha = 0.0;
//        //wait to show of the eletron at the new layer after the dash animation
//        [UIView animateWithDuration:0 delay:1.3 options:0 animations:^
//         {
//             eletron1.alpha = 1;
//         }
//                         completion:^(BOOL finished)
//         {
//             
//         }];
//
//    }
    lastLayer = currentLayer;
    currentLayer = newLayer;
    
}

- (void) updateScene
{
    
    //points on layer 0
    [velocityUpdater1 updateWithTime:[displayLink duration]];
    double teta = fmod(velocityUpdater1.currentPosition, 2*M_PI);
    //double teta = eulerToRadians(velocityUpdater1.currentPosition);
    CGPoint newPoint = pointAround(CGPointMake(WIDTH_IPAD/2, HEIGHT_IPAD/2), 150, teta);
    eletronAnimated1.center = newPoint;
    eletron1.center = newPoint;

    //points on layer x>0
    if(currentLayer>0)
    {
    [velocityUpdater2 updateWithTime:[displayLink duration]];
    double teta2 = fmod(velocityUpdater2.currentPosition, 2*M_PI);
    CGPoint newPoint2 = pointAround(CGPointMake(WIDTH_IPAD/2, HEIGHT_IPAD/2), SIZE_FIRST_LAYER+(SPACE_LAYER*currentLayer), teta2);
    eletronAnimated2.center = newPoint2;
    eletron2.center = newPoint2;
    }
    
   
           
    //state on another layer
    if(eletronState == kLeavingFirstLayer)
    {
        
        CGPoint pos = nucleus.center;
        //factor that represents extension of path of the animations
        double extension = 7.85;
        //factor for adjust of the loop time of animation
        double time = 80;
        double teta2 = fmod([displayLink timestamp]*time, 2*M_PI);
        //circular funtion
        pos.x += cos(teta2)*extension;
        pos.y += sin(teta2)*extension;
        //animation is around center but rect represents origin
        nucleus.center = pos;

        
        //count x laps
        accLap+=[displayLink duration];
        if(accLap>2*M_PI_2)
        {
            //return to layer 0
            eletronState = kStable;
            [self changetoLayer:0];
            
            UIImageView* flare = flareBlue;
            if(lastLayer==1)
                flare = flareRed;
            [self.view bringSubviewToFront:flare];
            flare.center = eletron2.center;

            [UIView animateWithDuration:FAIR_TIME_INTERVAL delay: 0.0 options: 0
                             animations:^
             {
                 flare.alpha = 1.0;
                 CGAffineTransform t = self.view.transform;
                 t = CGAffineTransformScale(t, 30, 30);
                 t = CGAffineTransformRotate(t, 45);
                 flare.transform = t;
             }
                             completion:^(BOOL finihshed)
             {
                 
                 [UIView animateWithDuration:FAIR_TIME_INTERVAL delay: 0.1 options: 0
                                  animations:^
                  {
                      flare.alpha = 0.0;
                      CGAffineTransform t = self.view.transform;
                      t = CGAffineTransformScale(t, 1, 1);
                      flare.transform = t;
                      
                      //fadeView.alpha = 0.8;
                  }
                                  completion:^(BOOL finihshed)
                  {
                      
                  }];
                 
             }];

        }
    }
}


@end
