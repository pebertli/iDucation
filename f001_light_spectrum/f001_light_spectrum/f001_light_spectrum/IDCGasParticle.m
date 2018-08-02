//
//  IDCParticleDrone.m
//  dalton.combinations
//
//  Created by pebertli on 11/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCGasParticle.h"

@implementation IDCGasParticle

//@synthesize rect;

- (id)initWithFrame:(CGRect)frame color:(UIColor*) color
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        rect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        rect.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//        
//        [self addSubview:rect];
        
        // Initialization code
        //configure the emitter layer
        viewLayer.emitterPosition = CGPointMake(frame.size.width/2, frame.size.height/2);
        //viewLayer.emitterSize = CGSizeMake(frame.size.width/4, frame.size.height/4);
        
        //add perspective
        //        CATransform3D transform = CATransform3DIdentity;
        //        transform.m34 = -1.0f/100.0f;
        //        viewLayer.transform = transform;
        //        //show the perspective
        //        viewLayer.preservesDepth = YES;
        
        
        //viewLayer.scale = 0.5;
        
        CAEmitterCell* fire = [CAEmitterCell emitterCell];
        UIImage* im = [UIImage imageNamed:@"gas.png"];
        fire.contents = (id)[im CGImage];
        [fire setName:@"fire"];
        fire.lifetime = 1.0;
        
        fire.lifetimeRange = 0.5;
        fire.color = [color CGColor];
        
        fire.velocity = 0.1;
        fire.velocityRange = 0.1;
        fire.emissionRange = M_PI;
        
        fire.scaleSpeed = 0.1;
        fire.scaleRange = 1;
        fire.alphaSpeed = -0.9;
        fire.alphaRange = -0.9;
        fire.spin = M_PI_4/2;
        fire.spinRange = M_PI_4;
       //fire.spin = 0.3;
        
        
        
        
        viewLayer.renderMode = kCAEmitterLayerUnordered;
        viewLayer.emitterMode = kCAEmitterLayerVolume;
        viewLayer.emitterShape = kCAEmitterLayerCircle;
        viewLayer.emitterCells = [NSArray arrayWithObject:fire];
        
        
        self.userInteractionEnabled = YES;
//        rect.userInteractionEnabled = YES;
        
        /*
         
         //set ref to the layer
         viewLayer = (CAEmitterLayer*)self.layer;
         //configure the emitter layer
         viewLayer.emitterPosition = CGPointMake(frame.size.width/2, frame.size.height/2);
         viewLayer.emitterSize = frame.size;
         
         //        CATransform3D transform = CATransform3DIdentity;
         //        transform.m34 = -1.0f/100.0f;
         //        viewLayer.transform = transform;
         
         viewLayer.preservesDepth = YES;
         
         CAEmitterCell* fire = [CAEmitterCell emitterCell];
         fire.lifetime = 1;
         fire.lifetimeRange = 0.3;
         fire.scale = 0.5;
         fire.scaleSpeed = -1;
         fire.spin = M_PI_2;
         
         
         //        fire.lifetimeRange = 0.5;
         //fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
         UIImage* im = [UIImage imageNamed:@"energy_trail.png"];
         fire.contents = (id)[im CGImage];
         
         [fire setName:@"energy"];
         
         fire.velocity = 10;
         fire.velocityRange = 20;
         fire.emissionRange = M_PI_2;
         
         
         //        fire.spin = 0.5;
         viewLayer.renderMode = kCAEmitterLayerBackToFront;
         viewLayer.emitterMode = kCAEmitterLayerSurface;
         viewLayer.emitterShape = kCAEmitterLayerSphere;
         
         viewLayer.emitterCells = [NSArray arrayWithObject:fire];
         
         [viewLayer setValue:[NSNumber numberWithInt:50] forKeyPath:@"emitterCells.energy.birthRate"];
         
         self.userInteractionEnabled = NO;
         */
        
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)setIsEmitting:(BOOL)isEmitting
{
    //turn on/off the emitting of particles
    [viewLayer setValue:[NSNumber numberWithInt:isEmitting?50:0] forKeyPath:@"emitterCells.fire.birthRate"];
}

-(void)setEmitterPositionFromTouch: (UITouch*)t
{
    //change the emitter's position
    CGPoint p = [t locationInView:self];
    self.viewLayer.emitterPosition = p;
//    rect.frame = CGRectMake(p.x-(rect.frame.size.width/2), p.y-(rect.frame.size.height/2), rect.frame.size.width, rect.frame.size.height);
}

- (void) setEmitterPosition: (CGPoint) p
{
    //change the emitter's position
    self.viewLayer.emitterPosition = p;
 
   
//    rect.center = p;
}


@end
