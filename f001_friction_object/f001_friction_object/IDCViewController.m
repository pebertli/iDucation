//
//  IDCViewController.m
//  f001_friction_object
//
//  Created by pebertli on 04/10/13.
//  Copyright (c) 2013 com.handverse. All rights reserved.
//

#import "IDCViewController.h"

@interface IDCViewController ()

@end

@implementation IDCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    currentIndex = 0;
    justFilled = NO;
    
    positiveGlow = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-(500/2), self.view.center.y-(500/2), 500, 500)];
    positiveGlow.image = [UIImage imageNamed:@"glow.png"];
    //    positiveGlow.center = positive.center;//[positiveGlow convertPoint:positive.center toView:positive];
    positiveGlow.alpha = 0;
    [self.view addSubview:positiveGlow];
    
    positive = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-(200/2), self.view.center.y-(200/2), 200, 200)];
    positive.image = [UIImage imageNamed:@"positive.png"];
    positive.userInteractionEnabled = YES;
    [self.view addSubview:positive];
    
    self.view.multipleTouchEnabled = NO;
    
    pixelated = [[HVPixelatedImage alloc] initWithImage:@"positive.png" withFrame:positive.frame];
    eletronsPosition = [pixelated randomPixelsCenterWithSize:30 count:10];
    //NSArray* eletronsPosition = [pixelated getPixelsCenter:10];
    atoms = [NSMutableArray array];
    
    for (HVPoint* p in eletronsPosition) {
        IDCAtom* a = [[IDCAtom alloc] initWithArt:@"negative.png" withSize:CGSizeMake(30 , 30)]  ;
        [atoms addObject:a];
        [self.view addSubview:a];
        a.center = [p point];
        a.desiredPoint = [p point];
    }
    
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panObject:)];
//    [panGesture setMinimumNumberOfTouches:2];
//    [panGesture setMaximumNumberOfTouches:2];
//    panGesture.cancelsTouchesInView = YES;
//    [panGesture setDelegate:self];
//    [positive  addGestureRecognizer:panGesture];
    
    workComplete = YES;
    //a callback for frame update
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCalled)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //display refresh rate
    [displayLink setFrameInterval:1];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)panObject:(UIPanGestureRecognizer *)gestureRecognizer
//{
//
//        CGPoint translation = [gestureRecognizer translationInView:self.view];
//        gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + translation.x,
//                                                    gestureRecognizer.view.center.y + translation.y);
//        positiveGlow.center = CGPointMake(positiveGlow.center.x + translation.x,
//                                          positiveGlow.center.y + translation.y);
//        
//        for(IDCAtom* a in atoms)
//        {
//            if(a.state == IDCAtomStateNormal)
//                a.center = CGPointMake(a.center.x + translation.x, a.center.y + translation.y);
//        }
//        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
//}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([touches count] == 1)
    {
        UITouch* t = [touches anyObject];
        
        CGPoint p = [t locationInView:self.view];
        CGPoint pp = [t previousLocationInView:self.view];
        
        if(CGRectContainsPoint(positive.frame, p))
        {
            countTouch--;
            
            if(countTouch<=0 && currentIndex<10)
            {
                countTouch = randomBetween(10, 30);
                
                if(currentIndex==9)
                {
                    justFilled = YES;
                }
                
                IDCAtom* a = [atoms objectAtIndex:currentIndex];
                currentIndex++;
                
                if(a.state == IDCAtomStateNormal)
                {
                    [UIView animateWithDuration:0.75 animations:^
                     {
                         a.state = IDCAtomStateEnergized;
                         int r = randomBetween(0, 360);
                         CGPoint pFinal = pointAround(p, 25, eulerToRadians(r));
                         a.center = pFinal;
                         positiveGlow.alpha = (((float)(currentIndex))/10);
                     } completion:^(BOOL finished)
                     {
                         
                     }];
                    
                    float alphaGlow = (((float)(currentIndex))/10);
                    if(alphaGlow>=1.0)
                    {
                    [UIView animateWithDuration:0.5 animations:^
                     {
                         positiveGlow.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
                     } completion:^(BOOL finished)
                     {
                         [UIView animateWithDuration:0.5 animations:^
                          {
                              positiveGlow.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                          } completion:^(BOOL finished)
                          {
                          }];

                     }];
                    }

                }
                
            }
            
        }
        else
        {
            if(!justFilled)
            {
                lastTouchOutside = [NSDate date];
                if(currentIndex==10)
                {
                    firstTouch = p;
                    distanceTouch =  distance(firstTouch, positive.center);
                    directionObject = normalizeVector(subVectors(positive.center, firstTouch));
                    moving = true;
                }
            }
            
        }
        
        for (IDCAtom* a in atoms)
        {
            if(a.state == IDCAtomStateEnergized)
            {
                CGPoint pAux = a.center;
                pAux.x += p.x -pp.x;
                pAux.y += p.y -pp.y;
                a.center = pAux;
            }
        }
        
    }
//    else if([touches count]==2)
//    {
//        UITouch* t = [touches anyObject];
//        
//        CGPoint p = [t locationInView:self.view];
//
//        CGPoint translation = [gestureRecognizer translationInView:self.view];
//        //        gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + translation.x,
//        //                                                    gestureRecognizer.view.center.y + translation.y);
//        //        positiveGlow.center = CGPointMake(positiveGlow.center.x + translation.x,
//        //                                          positiveGlow.center.y + translation.y);
//        //
//        //        for(IDCAtom* a in atoms)
//        //        {
//        //            if(a.state == IDCAtomStateNormal)
//        //                a.center = CGPointMake(a.center.x + translation.x, a.center.y + translation.y);
//        //        }
//        //        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
//
//    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([touches count] == 1)
    {
        
        countTouch = randomBetween(10, 30);
        
        UITouch* t = [touches anyObject];
        
        CGPoint p = [t locationInView:self.view];
        currentTouch = p;
        firstTouch = p;
        
        if(!CGRectContainsPoint(positive.frame, p) && currentIndex==10)
        {
            distanceTouch =  distance(firstTouch, positive.center);
            directionObject = normalizeVector(subVectors(positive.center, firstTouch));
            moving = true;
        }
        
        
                [UIView animateWithDuration:0.25 animations:^
                 {
                     for(IDCAtom* a in atoms)
                     {
                         if(a.state == IDCAtomStateEnergized)
                         {
                             int r = randomBetween(0, 360);
                             CGPoint pInitial = pointAround(firstTouch, 200, eulerToRadians(r));
                             a.center = pInitial;

                     CGPoint pFinal = pointAround(firstTouch, 25, eulerToRadians(r));
                     a.center = pFinal;
                     a.alpha = 1;
                         }
                     }
                 } completion:^(BOOL finished)
                 {
                     if(CGRectContainsPoint(positive.frame, p) && currentIndex>=10)
                     {
                         [self reset];
                     }

                 }];
            }
    }

- (void) reset
{
    //object.Position = end;
    moving = false;
    currentIndex = 0;
    pixelated = [[HVPixelatedImage alloc] initWithImage:@"positive.png" withFrame:positive.frame];
    eletronsPosition = [pixelated randomPixelsCenterWithSize:30 count:10];
    //NSArray* eletronsPosition = [pixelated getPixelsCenter:10];
    
    
    
    [UIView animateWithDuration:0.5 animations:^
     {
         for (int index = 0; index<10;index++) {
             IDCAtom* a = [atoms objectAtIndex:index];
             HVPoint* p = [eletronsPosition objectAtIndex:index];
             
             
             a.center = p.point;
             a.alpha = 1;
             positiveGlow.alpha = 0;
             a.state = IDCAtomStateNormal;
         }
     } completion:^(BOOL finished)
     {
         CGRect frameOrigin = CGRectMake(self.view.center.x-(200/2), self.view.center.y-(200/2), 200, 200);
         pixelated = [[HVPixelatedImage alloc] initWithImage:@"positive.png" withFrame:frameOrigin];
         eletronsPosition = [pixelated randomPixelsCenterWithSize:30 count:10];
         
         [UIView animateWithDuration:0.5 animations:^
          {
              positive.alpha = 0;
              for (int index = 0; index<10;index++) {
                  IDCAtom* a = [atoms objectAtIndex:index];
                  a.alpha = 0;
                  
              }
          } completion:^(BOOL finished)
          {
              positive.frame = frameOrigin;
              positiveGlow.center = positive.center;
              for (int index = 0; index<10;index++) {
                  IDCAtom* a = [atoms objectAtIndex:index];
                  HVPoint* p = [eletronsPosition objectAtIndex:index];
                  
                  
                  a.center = p.point;
              }
              
              [UIView animateWithDuration:0.5 animations:^
               {
                   positive.alpha = 1;
                   for (int index = 0; index<10;index++) {
                       IDCAtom* a = [atoms objectAtIndex:index];
                       a.alpha = 1;
                   }
                   
               } completion:^(BOOL finished)
               {
                   
               }];
          }];
         
     }];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

        UITouch* t = [touches anyObject];
        justFilled = NO;
    
        CGPoint p = [t locationInView:self.view];
        moving = NO;
    
        for(IDCAtom* a in atoms)
        {
            if(a.state == IDCAtomStateEnergized)
            {
                
                [UIView animateWithDuration:0.25 animations:^
                 {
                     int r = randomBetween(0, 360);
                     CGPoint pFinal = pointAround(p, 200, eulerToRadians(r));
                     a.center = pFinal;
                     a.alpha = 0;
                 } completion:^(BOOL finished)
                 {
                 }];
            }
        }
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
            }
        
        if(moving == true)
        {
            double currentDistance = distance(firstTouch, positive.center);
            CGPoint c = subVectors(positive.center,multiplyVector((90000/currentDistance)*[displayLink duration], directionObject));
            positive.center = c;
            positiveGlow.center = c;
            
            if(currentDistance <= 100)
            {
                [self reset];
                
            }
        }
        
        //

}

@end
