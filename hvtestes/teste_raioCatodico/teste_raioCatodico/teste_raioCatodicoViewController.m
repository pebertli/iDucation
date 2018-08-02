//
//  teste_raioCatodicoViewController.m
//  teste_raioCatodico
//
//  Created by User on 08/04/13.
//  Copyright (c) 2013 iDucation. All rights reserved.
//

#import "teste_raioCatodicoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HVUtils.h"
#import "HVGeometry.h"

@interface teste_raioCatodicoViewController ()

@end

@implementation teste_raioCatodicoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGSize size = CGSizeMake(600.0f, 600.0f);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor yellowColor] CGColor]);
    
    CGFloat components[] = {1.0, 0, 0, 0.9};
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetShadowWithColor(context, CGSizeMake(0,0), 10, color);

    
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, 100.0f, 100.0f);
    CGContextAddLineToPoint(context, 450.0f, 140.0f);
    CGContextAddLineToPoint(context, 450.0f, 60.0f);
    
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:result];
    [self.view addSubview:imageView];
    [imageView setNeedsDisplay];
    
    UIImage * estrelinha = [UIImage imageNamed:@"estrelinha.png"];
    tam = [estrelinha size];
    estrelas = [[UIView alloc] initWithFrame:CGRectMake(-80,-10,500,500)];
    [estrelas setBackgroundColor:[UIColor colorWithPatternImage:estrelinha]];
    
    estrelas_container = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 400, 400)];
    [self.view addSubview:estrelas_container];
    [estrelas_container addSubview:estrelas];
    //[estrelas_container setClipsToBounds:YES];
    
    
    _maskingLayer = [CALayer layer];
    _maskingLayer.frame = estrelas.bounds;
    [_maskingLayer setContents:(id)[result CGImage]];
    [estrelas_container.layer setMask:_maskingLayer];
    ref = [estrelas center];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:(0.05)
                                                      target:self
                                                    selector:@selector(anim)
                                                    userInfo:nil
                                                     repeats:YES];
    
    raio = [[teste_raioCatodicoView alloc] initWithFrame:CGRectMake(10,300, 600, 700)];
    [raio setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:raio];
    
    HVAnimatedBackgroundView * teste_estrelas =
    [[HVAnimatedBackgroundView alloc] init];
    
    [teste_estrelas setFrame:CGRectMake(100, 850, 400, 100)];
    [teste_estrelas setImageByName:@"estrelinha.png"];
    [teste_estrelas setVerticalVelocity:0];
    [teste_estrelas setHorizontalVelocity:15];
    [teste_estrelas setBackgroundColor:[UIColor yellowColor]];
    
    [teste_estrelas setHorizontalLoops:5];
//    [teste_estrelas setPauseBetweenLoopX:3 betweenLoopY:0];
    
    [self.view addSubview:teste_estrelas];
    

    
    HVAnimatedBackgroundView * teste_estrela =
    [[HVAnimatedBackgroundView alloc] init];
    
    [teste_estrela setFrame:CGRectMake(300, 450, 400, 100)];
    [teste_estrela setImageByName:@"estrela.png"];
//    [teste_estrela setVerticalVelocity:5];
    [teste_estrela setHorizontalVelocity:25];
    [teste_estrela fitFrameHeightToImage];
    [teste_estrela fitFrameWidthToImage];
    
    [teste_estrela setHorizontalLoops:0];
    [teste_estrela setPauseBetweenLoopX:2 betweenLoopY:0];
    
    [self.view addSubview:teste_estrela];


    
}

- (void)anim{
    pos++;
    CGPoint center = estrelas.center;
    if (pos >= tam.width) {
        pos = 0;
    }
    [estrelas setCenter:CGPointMake(ref.x + pos, ref.y)];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray * fingersNow = [touches allObjects];
    UITouch * touch = (UITouch *)[fingersNow objectAtIndex:0];
    CGPoint currentPoint = [touch locationInView:self.view];
    CGRect currentFrame = _maskingLayer.frame;
    [_maskingLayer setFrame:CGRectMake(currentPoint.x, currentPoint.y,
                                       currentFrame.size.width, currentFrame.size.height)];
    [estrelas_container setCenter:currentPoint];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@implementation teste_raioCatodicoView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Drawing with a white stroke color
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0);
    s = CGPointMake(30.0, 120.0);
    e = CGPointMake(300.0, cp2.y);
    cp1 = midpoint(s, cp2);
//    cp2 = CGPointMake(210.0, 210.0);
    CGContextMoveToPoint(context, s.x, s.y);
    CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
    
    drawCircle(context, s, 3);
    drawCircle(context, e, 3);
    drawCircle(context, cp1, 3);
    drawCircle(context, cp2, 3);
    
    CGContextStrokePath(context);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray * fingersNow = [touches allObjects];
    UITouch * touch = (UITouch *)[fingersNow objectAtIndex:0];
    CGPoint currentPoint = [touch locationInView:self];
    cp2 = currentPoint;
    [self setNeedsDisplay];
}

@end
