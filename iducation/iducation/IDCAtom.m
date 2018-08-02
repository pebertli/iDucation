//
//  IDCAtom.m
//  dalton.combinations
//
//  Created by pebertli on 22/04/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCAtom.h"

@implementation IDCAtom

@synthesize state;
@synthesize desiredPoint;
@synthesize originalPoint;
@synthesize glowView;
@synthesize touch;
@synthesize currentAnimationTime;
@synthesize energizedSound;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithElement: (NSString*) symbol scale:(float) scale{
    //simple initialization
    self = [super initWithFrame:CGRectMake(0, 0, 1, 1)];
    if (self) {
        // Initialization code
        element = symbol;
        state = IDCAtomStateNormal;
        currentAnimationTime = 0.0;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
             
        //get the size of image acording with the symbol
        CGRect f = CGRectMake(0, 0, 96, 96);
        //warning: a 0.45 scale or less cause aliasing problem
        f.size.height *= scale;
        f.size.width *= scale;
        self.frame = f;
        
        originalPoint = self.frame.origin;
        desiredPoint = originalPoint;
        
        //set the image thar represent glow behind atoms
        glowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue_glowing.png"]];
        glowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        glowView.alpha = 0.0;
        CGRect gFrame = glowView.frame;
        gFrame.size.height*=scale;
        gFrame.size.width*=scale;
        glowView.frame = gFrame;
        glowView.center = self.center;
        [self addSubview:glowView];
        
        //set the image of atom acording the symbol
        art = [UIImage imageNamed:[self imageFileFromElement:symbol]];
        imageView = [[UIImageView alloc] initWithImage:art];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        f = imageView.frame;
        f.size.height *= scale;
        f.size.width *= scale;
        imageView.frame = f;

        [self addSubview:imageView];
        
        
        //a simple factor that add realism to some animations
        randomAnimationFactor =  randomBetween(-90, 90);
        
        CGRect energyFrame = self.frame;
        energyFrame.origin.x = 0;
        energyFrame.origin.y = 0;
        
        energyParticles = [[NSMutableArray alloc] init];
        for (int i = 0; i<4; i++) {
             IDCParticleDrone* p = [[IDCParticleDrone alloc] initWithFrame:energyFrame];
            [self addSubview:p];
            [p rangeRandom:self.frame.size.width];
            [energyParticles addObject:p];
        }
        
        //set the image thar represent white flash
        flashView = [[UIImageView alloc] initWithImage:tintedImageFromFileWithColor([self imageFileFromElement:symbol], [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]) ];
        flashView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        flashView.alpha = 0.0;
        gFrame = flashView.frame;
        gFrame.size.height*=scale;
        gFrame.size.width*=scale;
        flashView.frame = gFrame;
        flashView.center = self.center;
        [self addSubview:flashView];

        
        energizedSound = [HVAudio audioByName:@"energized.mp3"];
        [energizedSound setLoops:-1];
    }
    return self;
}

- (void) doEnergyAnimation:(double) elapsed{

    float offset_x = 0+(self.frame.size.width/2);
        float offset_Y = 0+(self.frame.size.height/2);
     float velocity = 3;
    float radiusYZ = (self.frame.size.width);
    
    for(IDCParticleDrone* p in energyParticles)
    {
        double animFactor = eulerToRadians(p.animFactor);

    p.viewLayer.emitterPosition = CGPointMake(p.factorX*((radiusYZ-p.randomFactor)*sin(velocity*elapsed+animFactor))+offset_x, p.factorY*((p.randomFactor) * sin(velocity*elapsed+animFactor))+offset_Y);
    p.viewLayer.emitterZPosition = p.factorZ*(p.randomFactor/2) * cos(velocity*elapsed+animFactor);
    p.viewLayer.zPosition = p.factorZ*(p.randomFactor/2) * cos(velocity*elapsed+animFactor);
    }
    

}

- (void) resetImageAtCenter
{
    CGRect f = imageView.frame;

    f.origin = [self convertPoint:CGPointZero fromView:self];
    imageView.frame = f;
}

- (void)doFloatAnimation:(double) elapsed
{
    CGPoint pos = self.center;

    //factor that represents extension of path of the animations
    double extension = 0.066666;
    //factor for adjust of the loop time of animation
    double time = 0.25;
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
    CGPoint pos = imageView.center;
    
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
    pos = centerToOrigin(pos, imageView.frame);
    CGRect f = imageView.frame;
    f.origin.x = pos.x;
    f.origin.y = pos.y;
    imageView.frame = f;
    flashView.frame = f;

}

- (void) doCombinationAnimation:(double) timeSinceLastUpdate
{
    double targetTime = 1.0;
    //non-linear funtion for time
    currentAnimationTime = lowPassFilter(timeSinceLastUpdate, targetTime, currentAnimationTime, 0.7);
    
    //points of qaudratic bezier
    CGPoint currentPoint = self.frame.origin;
    CGPoint controlPoint = midpoint(currentPoint, desiredPoint);
    //control point with a random factor
    controlPoint = sumVectors(controlPoint, CGPointMake( randomAnimationFactor , randomAnimationFactor));
    
    //find the position in bezier curve acording current time
    CGPoint newPoint = pointInQuadraticBezierAtValue(currentPoint, desiredPoint, controlPoint , currentAnimationTime);

    CGRect f = self.frame;
    f.origin.x = newPoint.x;
    f.origin.y = newPoint.y;
    self.frame = f;
    
    //stop condition: near desired point
    if(state == IDCAtomStateCombinating && fabs(self.frame.origin.x-desiredPoint.x)<1 && fabs(self.frame.origin.y-desiredPoint.y)<1)
        state = IDCAtomStateCombinated;


    //stop condition: near original point
    if(state == IDCAtomStateCombinated && fabs(self.frame.origin.x-originalPoint.x)<1 && fabs(self.frame.origin.y-originalPoint.y)<1)
        state = IDCAtomStateNormal;

}

- (void) doGlowingAnimation:(double) elapsed
{
    double time = 5;
    double teta = fmod(elapsed*time, 2*HV_PI);
    
    //intermitent glow
    glowView.alpha = sin(teta);
}

-(NSString*) imageFileFromElement: (NSString*) symbol{
    
    NSMutableString* ret = [[NSMutableString alloc] initWithString:@"atom_"];
    [ret appendString:[symbol lowercaseString]];
    
    return ret;
}

- (void)setNeedsDisplay{
    //before refresh view, update frame with rect values
    //self.frame = [rect toCGRect];
    
    [super setNeedsDisplay];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self handleSingleTap];
    
    
    
}

- (void) handleSingleTap {
    //set flag touch for later consume
    self.touch = YES;

    //new state. on/off switch
    if(state == IDCAtomStateNormal)
    {
        state = IDCAtomStateTouched;
        
        //Particles
        [self pauseEnergyParticles:NO];
        //Blink
        [UIView animateWithDuration:SHORT_TIME_INTERVAL delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                         animations:^
        {
                             flashView.alpha = 1.0;
        }
                         completion:^(BOOL finihshed){
                             [UIView animateWithDuration:FAIR_TIME_INTERVAL delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut
                                              animations:^
                             {
                                                  flashView.alpha = 0.0;
                             }
                                              completion:^(BOOL finihshed)
                             {
                                 
                             }];
                             
                         }];
        //sound
        [energizedSound playWithCrossfade:0.5];

    }
    else if (state == IDCAtomStateTouched)
    {
        state = IDCAtomStateNormal;
        [energizedSound stopWithCrossfade:0.5];
        [self pauseEnergyParticles:YES];
        glowView.alpha = 0.0;
    }
}

- (void) pauseEnergyParticles:(BOOL) pause
{
    for(IDCParticleDrone* p in energyParticles)
    {
        [p setIsEmitting:!pause];
    }
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
