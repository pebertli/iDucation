//
//  IDCParticleDrone.m
//  dalton.combinations
//
//  Created by pebertli on 11/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCParticleFlame.h"

@implementation IDCParticleFlame

@synthesize visualFrame;
@synthesize emitting;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y-(frame.size.height/2), frame.size.width, frame.size.height+(frame.size.height/2))];
    visualFrame = CGRectMake(frame.origin.x, frame.origin.y, 200, 300);
    
    if (self) {
        // Initialization code
        //configure the emitter layer
//            visualFrame = CGRectMake(frame.origin.x, frame.origin.y-(frame.size.height/2), frame.size.width, frame.size.height+(frame.size.height/2));
        emitting = NO;

        viewLayer.emitterPosition = CGPointMake(visualFrame.size.width/2, visualFrame.size.height);
        
        //self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        //viewLayer.emitterSize = CGSizeMake(60, 60);
        
        //add perspective
        //        CATransform3D transform = CATransform3DIdentity;
        //        transform.m34 = -1.0f/100.0f;
        //        viewLayer.transform = transform;
        //        //show the perspective
        //        viewLayer.preservesDepth = YES;
        //        self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1];
        
        CAEmitterCell* fire = [CAEmitterCell emitterCell];
        UIImage* im = [UIImage imageNamed:@"flame.png"];
        fire.contents = (id)[im CGImage];
        [fire setName:@"fire"];
        fire.lifetime = 1.5;
        fire.birthRate = 0;
        
        fire.lifetimeRange = 0.5;
        fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:1] CGColor];
        
        fire.velocity = 180;
        fire.velocityRange = 40;
        fire.emissionRange = M_PI_4;
        fire.emissionLongitude = -M_PI_2;
        
        fire.scaleSpeed = 2;
        fire.scaleRange = 1;
        fire.spin = 0.3;
        fire.yAcceleration = -45;
        fire.alphaSpeed = -0.9;
        
        viewLayer.renderMode = kCAEmitterLayerAdditive;
        viewLayer.emitterMode = kCAEmitterLayerPoints;
        viewLayer.emitterShape = kCAEmitterLayerPoint;
        viewLayer.emitterCells = [NSArray arrayWithObject:fire];
        
        viewLayer.beginTime = CACurrentMediaTime();
        //[self.view.layer addSublayer:emitter];
        
        self.userInteractionEnabled = NO;
        
        //[self rangeRandom:40];
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


 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
// - (void)drawRect:(CGRect)rect
// {
// // Drawing code
//     
//     CGContextRef cacheContext = UIGraphicsGetCurrentContext();
//
//     CGContextSetRGBFillColor(cacheContext, 0, 255, 0, 255);
//     CGContextSetRGBStrokeColor(cacheContext,0, 255, 0, 255);
//     CGContextFillRect(cacheContext, visualFrame);
//     
// }


-(void)setIsEmitting:(BOOL)isEmitting
{
    emitting = isEmitting;
    //turn on/off the emitting of particles
    if(isEmitting)
    {
        viewLayer.beginTime = CACurrentMediaTime();
    [viewLayer setValue:[NSNumber numberWithInt:50] forKeyPath:@"emitterCells.fire.birthRate"];
       // viewLayer.lifetime = 1;
    }
    else
    {
        [viewLayer setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.fire.birthRate"];
        //viewLayer.lifetime = 0;

    }
 //   viewLayer.lifetime = isEmitting?1:0;
//        [viewLayer setValue:[NSNumber numberWithInt:isEmitting?YES:NO] forKeyPath:@"emitterCells.fire.enable"];
}

-(void)setEmitterPositionFromTouch: (UITouch*) t;
{
    //change the emitter's position
     CGPoint point = [t locationInView:self];
    self.viewLayer.emitterPosition = point;
    point = [t locationInView:[self superview]];
    visualFrame.origin = CGPointMake(point.x-(200/2), point.y-300);
    [self setNeedsDisplay];
  }


@end
