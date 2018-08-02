//
//  IDCViewController.m
//  eletron_energy
//
//  Created by pebertli on 27/09/13.
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
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    
    nucleus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nucleus.png"]];
    nucleus.frame = CGRectMake(self.view.center.x-(100/2), self.view.center.y-(100/2), 100, 100);
    [self.view addSubview:nucleus];

    
    eletron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eletron.png"]];
    eletron.frame = CGRectMake(0, 0, 30, 30);
    eletron.center = pointAround(CGPointMake(self.view.center.x, self.view.center.y) , 200, eulerToRadians(0));
    [self.view addSubview:eletron];
    
    velocityEletron = [[HVVelocity alloc] initWithInitialPosition:0 initialVelocity:3 acceleration:0 finalVelocity:0];
    velocityRadius = [[HVVelocity alloc] initWithInitialPosition:0 initialVelocity:1 acceleration:-0.1 finalVelocity:0];
    
    particle = [[IDCParticleDrone alloc] initWithFrame:self.view.frame];
    [self.view addSubview:particle];
    //[particle setEmitting:YES];
    
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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.35 animations:
     ^{
         eletron.alpha = 0;
     }
    completion:^(BOOL finished){
        
        [velocityEletron resetWithInitialPosition:0 initialVelocity:3 acceleration:0 finalVelocity:0];
        [velocityRadius resetWithInitialPosition:0 initialVelocity:1 acceleration:-0.1 finalVelocity:0];
        eletron.center = pointAround(CGPointMake(self.view.center.x, self.view.center.y) , 200, eulerToRadians(0));
        [UIView animateWithDuration:0.35 animations:^
        {
        eletron.alpha = 1;
        }];
     }];
    
}

- (void) updateScene
{
    [velocityEletron updateWithTime:[displayLink duration]];
    [velocityRadius updateWithTime:[displayLink duration]];

    double teta = fmod(velocityEletron.currentPosition, 2*M_PI);
    CGPoint newPoint = pointAround(self.view.center, 200*velocityRadius.currentVelocity, teta);
    eletron.center = newPoint;
    [particle setEmitterPosition:newPoint];

}

@end
