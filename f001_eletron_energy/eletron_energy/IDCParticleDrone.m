//
//  IDCParticleDrone.m
//  dalton.combinations
//
//  Created by pebertli on 11/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCParticleDrone.h"

@implementation IDCParticleDrone

@synthesize emitting;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //configure the emitter layer
        viewLayer.emitterPosition = CGPointMake(frame.size.width/2, frame.size.height/2);
        //viewLayer.emitterSize = CGSizeMake(60, 60);
        
        //add perspective
//        CATransform3D transform = CATransform3DIdentity;
//        transform.m34 = -1.0f/100.0f;
//        viewLayer.transform = transform;
//        //show the perspective
//        viewLayer.preservesDepth = YES;
        
        
        CAEmitterCell* fire = [CAEmitterCell emitterCell];
        fire.lifetime = 0.2;
        fire.scale = 1;
        UIImage* im = [UIImage imageNamed:@"energy_trail.png"];
        fire.contents = (id)[im CGImage];
        [fire setName:@"fire"];
        fire.scaleSpeed = -2;
        fire.birthRate = 100;
        
        viewLayer.renderMode = kCAEmitterLayerOldestFirst;
        viewLayer.emitterMode = kCAEmitterLayerPoints;
        viewLayer.emitterShape = kCAEmitterLayerPoint;
        viewLayer.emitterCells = [NSArray arrayWithObject:fire];
        
        
        self.userInteractionEnabled = NO;
        
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

//-(void)setIsEmitting:(BOOL)isEmitting
//{
//    //turn on/off the emitting of particles
//    [viewLayer setValue:[NSNumber numberWithInt:isEmitting?200:0] forKeyPath:@"emitterCells.fire.birthRate"];
//}

-(void)setIsEmitting:(BOOL)isEmitting
{
    emitting = isEmitting;
    //turn on/off the emitting of particles
    if(isEmitting)
    {
        viewLayer.beginTime = CACurrentMediaTime();
        [viewLayer setValue:[NSNumber numberWithInt:200] forKeyPath:@"emitterCells.fire.birthRate"];
    }
    else
    {
        [viewLayer setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.fire.birthRate"];
    }
    //viewLayer.lifetime = isEmitting?1:0;
    //        [viewLayer setValue:[NSNumber numberWithInt:isEmitting?YES:NO] forKeyPath:@"emitterCells.fire.enable"];
}

-(void)setEmitterPosition: (CGPoint) p
{
    //change the emitter's position
    self.viewLayer.emitterPosition = p;
}

@end
