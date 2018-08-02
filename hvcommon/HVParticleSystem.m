//
//  HVParticle.m
//  dalton.combinations
//
//  Created by pebertli on 04/06/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "HVParticleSystem.h"

@implementation HVParticleSystem

@synthesize viewLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        
        //set ref to the layer
        viewLayer = (CAEmitterLayer*)self.layer;
                
            
        

    }
    
    return self;
}

-(void)awakeFromNib
{
  
    
}

+ (Class) layerClass
{
    return [CAEmitterLayer class];
}

@end
