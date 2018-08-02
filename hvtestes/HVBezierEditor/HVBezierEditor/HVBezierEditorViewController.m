//
//  HVBezierEditorViewController.m
//  HVBezierEditor
//
//  Created by User on 03/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import "HVBezierEditorViewController.h"
#import "HVBezierEditor.h"

HVBezierSegment getCubicBezierFromPoints(CGPoint A, CGPoint B, CGPoint C, CGPoint D, CGPoint E){
    CGPoint quadControl1 = pointControlOfQuadraticBezier(A, C, B, 0.5);
    CGPoint quadControl2 = pointControlOfQuadraticBezier(C, E, D, 0.5);
    HVBezierSegment first = convertQuadBezierToCubicBezier(A, C, quadControl1);
    HVBezierSegment second = convertQuadBezierToCubicBezier(C, E, quadControl2);
    HVBezierSegment result;
    result.P1 = A; 
    result.P2 = E;
    
    return result;
}

UIBezierPath * rayQuad(CGPoint A, CGPoint B, CGPoint C, CGPoint D, CGPoint E,
                       double thickness1, double thickness2){
//    UIBezierPath * path = [UIBezierPath bezierPath];
//    double angle = angleOfBisectrixOutsidePath(A, B, C);
//    CGPoint B1 = pointAround(B, 2, angle);
//    CGPoint B2 = pointAround(B, 2, angle - HV_PI);
//    double percentage = distance(A,B) / (distance(A,B)+distance(B,C));
//    CGPoint control1 = pointControlOfQuadraticBezier(A, C, B1, percentage);
//    CGPoint control2 = pointControlOfQuadraticBezier(A, C, B2, percentage);
//    [path moveToPoint:A];
//    [path addQuadCurveToPoint:C controlPoint:control1];
//    [path addQuadCurveToPoint:A controlPoint:control2];
//    return path;
    double increment = (thickness2 - thickness1) / 4.0;
    double thick1 = thickness1 / 2;
    double thick2 = (thickness1 + increment) / 2;
    double thick3 = (thickness1 + increment * 2) / 2;
    double thick4 = (thickness1 + increment * 3) / 2;
    double thick5 = thickness2 / 2;
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGPoint B_ = pointControlOfQuadraticBezier(A, C, B, 0.5);
    CGPoint D_ = pointControlOfQuadraticBezier(C, E, D, 0.5);
    double angleA = angleOfSegment(A, B_) + 0.5 * HV_PI;
    double angleB = angleOfBisectrixOutsidePath(A, B, C);
    double angleC = angleOfBisectrixOutsidePath(B, C, D);
    double angleD = angleOfBisectrixOutsidePath(C, D, E);
    double angleE = angleOfSegment(D_, E) + 0.5 * HV_PI;
    CGPoint A1 = pointAround(A, thick1, angleA);
    CGPoint B1 = pointAround(B_, thick2, angleB);
    CGPoint C1 = pointAround(C, thick3, angleC);
    CGPoint D1 = pointAround(D_, thick4, angleD);
    CGPoint E1 = pointAround(E, thick5, angleE);
    CGPoint A2 = pointAround(A, thick1, angleA - HV_PI);
    CGPoint B2 = pointAround(B_, thick2, angleB - HV_PI);
    CGPoint C2 = pointAround(C, thick3, angleC - HV_PI);
    CGPoint D2 = pointAround(D_, thick4, angleD - HV_PI);
    CGPoint E2 = pointAround(E, thick5, angleE - HV_PI);


    [path moveToPoint:A1];
    [path addQuadCurveToPoint:C1 controlPoint:B1];
    [path addQuadCurveToPoint:E1 controlPoint:D1];
    [path addLineToPoint:E2];
    [path addQuadCurveToPoint:C2 controlPoint:D2];
    [path addQuadCurveToPoint:A2 controlPoint:B2];
//    [path addLineToPoint:A1];
    return path;
}


@implementation testeHVBezier


+ (testeHVBezier *) criar{
    testeHVBezier * bezierTeste =
    [[testeHVBezier alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    CGPoint A = CGPointMake(120, 300);
    CGPoint B = CGPointMake(300, 180);
    CGPoint C = CGPointMake(400, 280);
    CGPoint D = CGPointMake(450, 680);
    CGPoint E = CGPointMake(600, 400);
    CGPoint F = CGPointMake(700, 450);
    NSMutableArray * pontos = [NSMutableArray array];
    [pontos addObject:[NSValue valueWithCGPoint:A]];
    [pontos addObject:[NSValue valueWithCGPoint:B]];
    [pontos addObject:[NSValue valueWithCGPoint:C]];
    [pontos addObject:[NSValue valueWithCGPoint:D]];
    [pontos addObject:[NSValue valueWithCGPoint:E]];
    [pontos addObject:[NSValue valueWithCGPoint:F]];
    
    bezierTeste->points = [HVPolygon initWithCapacity:5];
    
    HVBezier * bezierCurva = [HVBezier initWithArray:pontos];
    bezierTeste->bezier = bezierCurva;
    [(HVBezierPoint *)[bezierCurva pointAtIndex:1] setType:HVBezierPointTypeSmooth];
    [(HVBezierPoint *)[bezierCurva pointAtIndex:2] setType:HVBezierPointTypeSmooth];
    [(HVBezierPoint *)[bezierCurva pointAtIndex:3] setType:
        HVBezierPointTypeSmooth];
    [(HVBezierPoint *)[bezierCurva pointAtIndex:4] setType:
        HVBezierPointTypeSmooth];
    
    [bezierCurva calculateLength];
    return bezierTeste;
    
}

- (void) drawRect:(CGRect)rect{
    [[bezier getBezierPath] stroke];
    CGContextRef context = UIGraphicsGetCurrentContext();
    float increment = 0.03;
    double percentage2 = percentage + 1*increment;
    double percentage3 = percentage + 2*increment;
    double percentage4 = percentage + 3*increment;
    double percentage5 = percentage + 4*increment;
    
    CGPoint pt = [bezier pointAtPercentageNormalized:percentage];
    CGPoint pt2 = [bezier pointAtPercentageNormalized:percentage2];
    CGPoint pt3 = [bezier pointAtPercentageNormalized:percentage3];
    CGPoint pt4 = [bezier pointAtPercentageNormalized:percentage4];
    CGPoint pt5 = [bezier pointAtPercentageNormalized:percentage5];
    
    for (int i=0; i<5; i++) {
        [[points pointAtIndex:i] setPoint:
         [bezier pointAtPercentageNormalized:(percentage + i*increment)]];
    }
    
    [bezier drawBezier:context];
    drawCircle(context, self.center, 5);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:1
                                                             green:0
                                                              blue:0
                                                             alpha:0.5] CGColor]);
//    UIBezierPath * ray = rayQuad(pt, pt2, pt3, pt4, pt5, 5, 15);
    UIBezierPath * ray = curveUsingQuadBeziers(points, 20, 1);
    [ray fill];
    CGContextFillPath(context);
    
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    drawCircle(context, pt, 3);
    drawCircle(context, pt2, 3);
    drawCircle(context, pt3, 3);
    drawCircle(context, pt4, 3);
    drawCircle(context, pt5, 3);
    CGContextFillPath(context);
}

@end

@interface HVBezierEditorViewController ()

@end

@implementation HVBezierEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    teste = [testeHVBezier criar];
    [self.view addSubview:teste];
    [teste adjustToParent];
    
    HVBezierEditor * editor = [HVBezierEditor fastCreationSettingParent:self.view];
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 50, 600, 100)];
    [slider addTarget:self action:@selector(sliderChange)
     forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    [slider setValue:0.5];
    [self sliderChange];
}

- (void)sliderChange{
    HVlog(@"percentage: ", [slider value]);
    teste->percentage = [slider value];
    [teste setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
