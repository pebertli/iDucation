//
//  IDCAtom.m
//  dalton.combinations
//
//  Created by pebertli on 22/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCAtom.h"

@implementation IDCAtom

@synthesize desiredPoint;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithArt: (NSString*) file withSize:(CGSize) size{
    //simple initialization
    self = [super initWithFrame:CGRectMake(0, 0, 1, 1)];
    if (self) {
        
        //get the size of image acording with the symbol
        CGRect r = CGRectMake(0, 0, size.width, size.height);
        self.frame = r;
        desiredPoint = CGPointMake(0, 0);
        
        // Initialization code
        art = [UIImage imageNamed:file];
        //set the image of atom
        imageView = [[UIImageView alloc] initWithImage:art];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.frame = CGRectMake(0, 0, size.width, size.height);

        
       [self addSubview:imageView];
        
        //a simple factor that add realism to some animations
        randomAnimationFactor =  randomBetween(-180, 180);
   
        
    }
    return self;
}

- (void)doFloatAnimation:(double) elapsed
{
    CGPoint pos = self.center;

    //factor that represents extension of path of the animations
    double extension = 0.02666;
    //factor for adjust of the loop time of animation
    double time = 0.6;
    double teta = fmod(elapsed*time, 2*HV_PI);
    double animFactor = eulerToRadians(randomAnimationFactor);
    
    //polar funtion of rose with 3 petals in linear form
    double r = 2*sin(3*(teta+animFactor));
    pos.x += r*cos(teta+animFactor)*extension;
    pos.y += r*sin(teta+animFactor)*extension;
    //animation is around center but rect represents origin
    pos = centerToOrigin(pos, self.frame);
    CGRect f = self.frame;
    f.origin.x = pos.x;
    f.origin.y = pos.y;
    self.frame = f;
}

- (void)doShakeAnimation:(double) elapsed
{
    CGPoint pos = self.center;
    
    //factor that represents extension of path of the animations
    double extension = 1.25;
    //factor for adjust of the loop time of animation
    double time = 40;
    double teta = fmod(elapsed*time, 2*HV_PI);
    double animFactor = eulerToRadians(randomAnimationFactor);
    
    //circular funtion
    pos.x += cos(teta+animFactor)*extension;
    pos.y += sin(teta+animFactor)*extension;
    
    //animation is around center but rect represents origin
    pos = centerToOrigin(pos, self.frame);
    CGRect f = self.frame;
    f.origin.x = pos.x;
    f.origin.y = pos.y;
    self.frame = f;

}

- (void)setNeedsDisplay{
    //before refresh view, update frame with rect values
//    self.frame = [rect toCGRect];
    
    [super setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
