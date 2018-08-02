//
//  IDCViewController.m
//  f001_light_spectrum
//
//  Created by pebertli on 8/1/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCViewController.h"

float const BASE_X_IPAD_V = 35;
float const BASE_Y_IPAD_V = 500;
float const SCALE_IPAD_V = 0.9;
float const SCALE_2_IPAD_V = 0.8;

typedef enum {
    NONE,
    HELIUM,
    HYDROGEN,
    MERCURY,
    URANIUM
} GAS_ELEMENT;

@interface IDCViewController ()

@end

@implementation IDCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    containerHelium = CGPointMake(130, 330);
    containerHydrogen = CGPointMake(containerHelium.x+(1*170), containerHelium.y);
    containerUranium = CGPointMake(containerHelium.x+(2*170), containerHelium.y);
    containerMercury = CGPointMake(containerHelium.x+(3*170), containerHelium.y);
    
    gasHelium = [[IDCGasParticle alloc] initWithFrame:CGRectMake(containerHelium.x-(150/2), containerHelium.y-(150/2), 150, 150) color:[UIColor colorWithRed:0.2 green:0.2 blue:0.8 alpha:1.0]];
    //gasHelium.userInteractionEnabled = YES;
    [self.view addSubview:gasHelium];
    [gasHelium setIsEmitting:YES];
    heliumRect = [[UIView alloc] initWithFrame:gasHelium.frame];
    [self.view addSubview:heliumRect];
    
    gasHydrogen = [[IDCGasParticle alloc] initWithFrame:CGRectMake(containerHydrogen.x-(150/2), containerHydrogen.y-(150/2), 150, 150) color:[UIColor colorWithRed:0.6 green:0.2 blue:0.5 alpha:1.0]];
   // gasHydrogen.userInteractionEnabled = YES;
    [self.view addSubview:gasHydrogen];
    [gasHydrogen setIsEmitting:YES];
    hydrogenRect = [[UIView alloc] initWithFrame:gasHydrogen.frame];
    [self.view addSubview:hydrogenRect];
    
    gasUranium = [[IDCGasParticle alloc] initWithFrame:CGRectMake(containerUranium.x-(150/2), containerUranium.y-(150/2), 150, 150) color:[UIColor colorWithRed:0.6 green:0.9 blue:0.5 alpha:1.0]];
    // gasHydrogen.userInteractionEnabled = YES;
    [self.view addSubview:gasUranium];
    [gasUranium setIsEmitting:YES];
    uraniumRect = [[UIView alloc] initWithFrame:gasUranium.frame];
    [self.view addSubview:uraniumRect];
    
    gasMercury = [[IDCGasParticle alloc] initWithFrame:CGRectMake(containerMercury.x-(150/2), containerMercury.y-(150/2), 150, 150) color:[UIColor colorWithRed:0.6 green:0.9 blue:0.9 alpha:1.0]];
    // gasHydrogen.userInteractionEnabled = YES;
    [self.view addSubview:gasMercury];
    [gasMercury setIsEmitting:YES];
    mercuryRect = [[UIView alloc] initWithFrame:gasMercury.frame];
    [self.view addSubview:mercuryRect];

    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [heliumRect addGestureRecognizer:panRecognizer];
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [hydrogenRect addGestureRecognizer:panRecognizer];
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [uraniumRect addGestureRecognizer:panRecognizer];
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [mercuryRect addGestureRecognizer:panRecognizer];
    
    UIImageView* machine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"machine.png"]];
    machine.frame = CGRectMake(BASE_X_IPAD_V, BASE_Y_IPAD_V, machine.image.size.width*SCALE_IPAD_V, machine.image.size.height*SCALE_IPAD_V);
    [self.view addSubview:machine];
    
    bulb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bulb.png"]];
    bulb.frame = CGRectMake(BASE_X_IPAD_V+138, BASE_Y_IPAD_V+21.5, bulb.image.size.width*SCALE_IPAD_V, bulb.image.size.height*SCALE_IPAD_V);
    bulbCenter = CGPointMake(BASE_X_IPAD_V+203, BASE_Y_IPAD_V+75);
                        [self.view addSubview:bulb];
    
    torch_zero = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emission_zero.png"]];
    torch_zero.frame = CGRectMake(BASE_X_IPAD_V+250, BASE_Y_IPAD_V+(10), torch_zero.image.size.width*SCALE_IPAD_V, torch_zero.image.size.height*SCALE_IPAD_V);
    torch_zero.alpha = 0;
    [self.view addSubview:torch_zero];
    
    torch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"he_torch.png"]];
    torch.frame = CGRectMake(BASE_X_IPAD_V+437, BASE_Y_IPAD_V+(-20), torch.image.size.width*SCALE_IPAD_V, torch.image.size.height*SCALE_IPAD_V);
    torch.alpha = 0;
    [self.view addSubview:torch];
    
    emission = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"he_emission.png"]];
    emission.frame = CGRectMake(BASE_X_IPAD_V+625, BASE_Y_IPAD_V, emission.image.size.width*SCALE_IPAD_V, emission.image.size.height*SCALE_IPAD_V);
    emission.alpha = 0;
    [self.view addSubview:emission];
    
    emission_below = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"he_emission.png"]];
    emission_below.frame = CGRectMake(BASE_X_IPAD_V+300, BASE_Y_IPAD_V+50, 100, 570);
    emission_below.alpha = 0;
    emission_below.transform = CGAffineTransformMakeRotation(eulerToRadians(-90));
    [self.view addSubview:emission_below];
    
    gas_set = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gas_set.png"]];
    gas_set.frame = CGRectMake((self.view.frame.size.width/2)-(gas_set.image.size.width*SCALE_2_IPAD_V/2), BASE_Y_IPAD_V-250, gas_set.image.size.width*SCALE_2_IPAD_V, gas_set.image.size.height*SCALE_2_IPAD_V);
    [self.view addSubview:gas_set];
    
    gas_set_front = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gas_set_front.png"]];
    gas_set_front.frame = CGRectMake((self.view.frame.size.width/2)-(gas_set_front.image.size.width*SCALE_2_IPAD_V/2), BASE_Y_IPAD_V-216, gas_set_front.image.size.width*SCALE_2_IPAD_V, gas_set_front.image.size.height*SCALE_2_IPAD_V);
    [self.view addSubview:gas_set_front];
    
    switch_button = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"switch.png"]];
    switch_button.center = CGPointMake(135, 655);
    [self.view addSubview:switch_button];
    
    flame = [[IDCParticleFlame alloc] initWithFrame:CGRectMake(140, 350, 50, 50)];
    [flame setIsEmitting:YES];
    [self.view addSubview:flame];

    
}

//
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    // Remember original location
//    previousLocation = gasHelium.center;
//}

- (void) handlePan: (UIPanGestureRecognizer *) gesture
{
    
    UIView* v = gesture.view;
    IDCGasParticle* vParticle = gasHydrogen;
    GAS_ELEMENT element;
    CGPoint containerCenter;
    
    if(v == heliumRect)
    {
        vParticle = gasHelium;
        element = HELIUM;
        containerCenter = containerHelium;
    }
    else if(v == hydrogenRect)
    {
        vParticle = gasHydrogen;
        element = HYDROGEN;
        containerCenter = containerHydrogen;
    }
    else if(v == uraniumRect)
    {
        vParticle = gasUranium;
        element = URANIUM;
        containerCenter = containerUranium;
    }
    else if(v == mercuryRect)
    {
        vParticle = gasMercury;
        element = MERCURY;
        containerCenter = containerMercury;
    }


    
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        previousLocation = v.center;
    }
    
    CGPoint translation = [gesture translationInView:v.superview];
    //v.center = CGPointMake(previousLocation.x + translation.x, previousLocation.y + translation.y);
    CGPoint p = CGPointMake(previousLocation.x + translation.x, previousLocation.y + translation.y);
    CGPoint pc = [self.view convertPoint:p toView:vParticle];
    [vParticle setEmitterPosition:pc];
    v.center = p;
    

    
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        //v.center = p;
        //[((IDCGasParticle*)v) setEmitterPosition:CGPointMake(v.frame.size.width/2,v.frame.size.height/2)];
        if(CGRectIntersectsRect(v.frame, bulb.frame))
        {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
            {
                [vParticle setEmitterPosition:[self.view convertPoint:bulbCenter toView:vParticle]];
                v.center = bulbCenter;
            }
             completion:^(BOOL finished)
             {
                 if(currentGas)
                 {
                     [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
                      {
                          [currentGas setEmitterPosition:[self.view convertPoint:currentContainer toView:currentGas]];
                          currentRect.center = currentContainer;
                      }
                                      completion:^(BOOL finished)
                      {
                       }];

                 }
                     
                 currentGas = vParticle;
                 currentRect = v;
                 currentContainer = containerCenter;
                 [self changeGasTo:element];
                 
             }];
             
        }
        else
        {
            
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
             {
                 [vParticle setEmitterPosition:[self.view convertPoint:containerCenter toView:vParticle]];
                 v.center = containerCenter;
             }
                             completion:^(BOOL finished)
             {
                   [self changeGasTo:NONE];
                 currentGas = nil;
             }];

        }
    }
}

- (void) changeGasTo:(GAS_ELEMENT) toGas
{
    float alpha = 1;
    NSString* imageName = @"he";
    
    switch (toGas) {
        case NONE:
            alpha = 0;
            imageName = @"";
            break;
        case HELIUM:
            imageName = @"he";
            break;
        case HYDROGEN:
            imageName = @"h";
            break;
        case MERCURY:
            imageName = @"hg";
            break;
        case URANIUM:
            imageName = @"u";
            break;


        default:
            break;
    }
    
    if(toGas!= NONE)
    {
    torch.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_torch.png",imageName]];
    torch.frame = CGRectMake(BASE_X_IPAD_V+427, BASE_Y_IPAD_V+(-20), torch.image.size.width*SCALE_IPAD_V, torch.image.size.height*SCALE_IPAD_V);
    
    emission.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_emission.png",imageName]];
    emission.frame = CGRectMake(BASE_X_IPAD_V+665, BASE_Y_IPAD_V+(-20), emission.image.size.width*SCALE_IPAD_V, emission.image.size.height*SCALE_IPAD_V);
        
    emission_below.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_emission.png",imageName]];
    emission_below.frame = CGRectMake(BASE_X_IPAD_V+50, BASE_Y_IPAD_V+300, 570, 100);
    }
    
    [UIView animateWithDuration:0.35 animations:^
    {
        torch.alpha = alpha;
        emission.alpha = alpha;
        torch_zero.alpha = alpha;
        emission_below.alpha = alpha;
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
