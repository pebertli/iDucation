//
//  teste_AtomosViewController.m
//  teste_Atomo
//
//  Created by User on 26/04/13.
//  Copyright (c) 2013 iDucation. All rights reserved.
//

#import "teste_AtomosViewController.h"
#import "HVGeometry.h"

@implementation IDCAtom

+ (IDCAtom *) atomWithImage:(NSString *)imageName{
    IDCAtom * newAtom = [[IDCAtom alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [newAtom setBackgroundColor:[UIColor clearColor]];
    newAtom->atom = [HVImageMatrix fastCreation:imageName];
    [newAtom->atom setClipsToBounds:YES];
    double w = newAtom->atom.frame.size.width;
    double h = newAtom->atom.frame.size.height;
    newAtom->d = 3*MAX(w, h);
    [newAtom setFrame:CGRectMake(0, 0, 2*newAtom->d, 2*newAtom->d)];
    [newAtom addSubview:newAtom->atom];
    [newAtom->atom setCenter:CGPointMake(newAtom->d,newAtom->d)];
    
    CADisplayLink * dLink = [CADisplayLink displayLinkWithTarget:newAtom selector:@selector(displayLinkCalled:)];
    [dLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [dLink setFrameInterval:1];
    
    newAtom->displayLink = dLink;
    CGPoint A = CGPointMake(100, 200);
    CGPoint B = CGPointMake(400, 150);
    CGPoint I = CGPointMake(300, 100);
    newAtom->path = quadraticBezierPassingBy(A, B, I, 0.5);
    newAtom->duration = 3;
    newAtom->isAnimating = NO;
    
    return newAtom;
}

- (void) displayLinkCalled:(CADisplayLink *)sender{
    CFTimeInterval time = [sender timestamp] - timestampStart;
    if (isAnimating) {
        HVlog(@"teste: ", time / duration);
    }
}

- (void) setNumberOfElectrons:(int)num{
    electrons = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        HVImageMatrix * electron = [HVImageMatrix fastCreation:@"electron.png"];
        [self addSubview:electron];
        double ang = i * (2 * HV_PI / num) + (HV_PI / num);
        double radius = 0.75 * d;
        CGPoint pt = pointAround(CGPointMake(d, d), radius, ang);
        [electron setCenter:pt];
    }
}

- (void) drawRect:(CGRect)rect{
    [path stroke];
}

- (void) play{
    timestampStart = [displayLink timestamp];
    HVlog(@"time ", timestampStart);
    isAnimating = YES;
}

@end

@implementation IDCElectron

+ (IDCElectron *) electronWithRadius:(double)radius{
    IDCElectron * newElectron = [[IDCElectron alloc] initWithFrame:CGRectMake(0, 0, 2 * radius, 2 * radius)];
    newElectron->d = 2 * radius;
    [newElectron setBackgroundColor:[UIColor clearColor]];
    newElectron->electron = [HVImageMatrix fastCreation:@"electron.png"];
    [newElectron addSubview:newElectron->electron];
    [newElectron->electron setCenter:CGPointMake(radius,radius)];
    newElectron->timer = [NSTimer scheduledTimerWithTimeInterval:(0.025)
                                                          target:newElectron selector:@selector(anim) userInfo:nil repeats:YES];
    newElectron->direction = 1;
    return newElectron;
}

- (void) anim{
    if (electron.center.y <= 0) {
        direction = 1;
    }else if (electron.center.y >= d){
        direction = -1;
    }
    electron.center = CGPointMake(0, electron.center.y + 10*direction);
}


@end

@interface teste_AtomosViewController ()

@end

@implementation teste_AtomosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    IDCAtom * carbono = [IDCAtom atomWithImage:@"atom_carbono.png"];
    [carbono setNumberOfElectrons:4];
    [self.view addSubview:carbono];
    [carbono setCenter:CGPointMake(400, 400)];
    [carbono setBackgroundColor:[UIColor yellowColor]];
    
    IDCElectron * eletron = [IDCElectron electronWithRadius:80];
    [self.view addSubview:eletron];
    eletron.center = CGPointMake(300, 600);
//    [eletron setBackgroundColor:[UIColor yellowColor]];
    
    //[carbono play];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:carbono
               action:@selector(play)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Play" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 410.0, 100.0, 40.0);
    [self.view addSubview:button];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
