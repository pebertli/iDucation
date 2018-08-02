//
//  IDCViewController.m
//  bohrheat
//
//  Created by pebertli on 26/07/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCViewController.h"

@interface IDCViewController ()

@end

@implementation IDCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    inside = NO;
    
    flame = [[IDCParticleFlame alloc] initWithFrame:CGRectMake(0 , 0, 768, 1024)];
    [self.view addSubview:flame];
    
   
    
    spring = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spring.png"]];
    spring.frame = CGRectMake(200, 200, 300, 300);
    [self.view addSubview:spring];
    
    hotSpring = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_spring.png"]];
    hotSpring.frame = CGRectMake(200, 200, 300, 300);
    
    hotSpring.alpha = 0;
    [self.view addSubview:hotSpring];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //CGPoint touch = [[touches anyObject] locationInView:nil];
    [flame setEmitterPositionFromTouch:[touches anyObject]];
    //= CGPointMake(touch.x, touch.y-(flame.frame.size.height/2));
    [flame setIsEmitting:YES];
    [self actionFlame];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endFlame];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endFlame];
}

- (void) endFlame
{
    [flame setIsEmitting:NO];
    //[self actionFlame];
    
    inside = NO;
    [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
     {
         hotSpring.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
     }];

}

- (void) actionFlame
{
//    NSLog(@"%f %f %f %f - %f %f %f %f",spring.frame.origin.x,spring.frame.origin.y,spring.frame.size.width,spring.frame.size.height,flame.visualFrame.origin.x,flame.visualFrame.origin.y,flame.visualFrame.size.width,flame.visualFrame.size.height);
    if(CGRectIntersectsRect(spring.frame, flame.visualFrame))
    {
        if(!inside)
        {
            inside = YES;
            //           [hotSpring.layer removeAllAnimations];
            [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
             {
                 hotSpring.alpha = 1;
             }
                             completion:^(BOOL finished)
             {
                 //                 if(!finished)
                 //                     hotSpring.alpha = hotSpring.alpha;
             }];
        }
    }
    else
    {
        if(inside)
        {
            inside = NO;
            //                        [hotSpring.layer removeAllAnimations];
            [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
             {
                 hotSpring.alpha = 0;
             }
                             completion:^(BOOL finished)
             {
                 //                 if(!finished)
                 //                     hotSpring.alpha = hotSpring.alpha;
             }];
            
        }
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //[flame setEmitterPositionFromTouch: [touches anyObject]];
    //CGPoint touch = [[touches anyObject] locationInView:nil];
    //flame.center = CGPointMake(touch.x, touch.y-(flame.frame.size.height/2));
    [flame setEmitterPositionFromTouch:[touches anyObject]];
    [self actionFlame];    

  }


@end
