//
//  teste_BezierViewController.m
//  teste_Bezier
//
//  Created by User on 19/04/13.
//  Copyright (c) 2013 HandVerse. All rights reserved.
//

#import "teste_BezierViewController.h"
#import "HVUtils.h"

CGPoint density(CGPoint A, CGPoint B, CGPoint Control){
    float increment = 0.005;
    float percentage = increment;
    float dist = distance(A, B);
    float lowestDistance = dist;
    float lowestPercentage = increment;
    while (percentage < 1.0) {
        CGPoint p1 = pointInQuadraticBezierAtValue(A, B, Control, percentage);
        CGPoint p2 = pointInQuadraticBezierAtValue(A, B, Control, percentage-increment);
        float currentDistance = distance(p1, p2);
        if (currentDistance < lowestDistance) {
            lowestDistance = currentDistance;
            lowestPercentage = percentage;
        }
        percentage += increment;
    }
    
    CGPoint p3 = pointInQuadraticBezierAtValue(A, B, Control, lowestPercentage);
    CGPoint p4 = pointInQuadraticBezierAtValue(A, B, Control, lowestPercentage - increment);
    
    return midpoint(p3, p4);

}

@implementation teste_Bezier

+ (teste_Bezier *)fastCreation{
    teste_Bezier * view = [[teste_Bezier alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    [view setBackgroundColor:[UIColor clearColor]];
    view->A = CGPointMake(150, 200);
    view->B = CGPointMake(600, 420);
    view->linha = CGPointMake(30, 80);
    view->Control = sumVectors(CGPointMake(0, -150), midpoint(view->A, view->B));
    view->percentage_slider =
    [[UISlider alloc] initWithFrame:CGRectMake(10, 5, 500, 30)];
    [view->percentage_slider setValue:0.25];
    [view addSubview:view->percentage_slider];
    [view->percentage_slider addTarget:view
                                action:@selector(adjustPercentage)
                      forControlEvents:UIControlEventValueChanged];
    view->percentage_slider2 =
    [[UISlider alloc] initWithFrame:CGRectMake(10, 30, 500, 30)];
    [view->percentage_slider2 setValue:0.25];
    [view addSubview:view->percentage_slider2];
    [view->percentage_slider2 addTarget:view
                                action:@selector(adjustPercentage)
                      forControlEvents:UIControlEventValueChanged];
    view->P1 = CGPointMake(150, 400);
    view->P1C = CGPointMake(250, 450);
    view->P2 = CGPointMake(350, 600);
    view->P2C = CGPointMake(250, 650);
    view->P2C_ = CGPointMake(300, 700);
    view->P3 = CGPointMake(450, 500);
    view->P3C = CGPointMake(450, 600);
    view->X = CGPointMake(200, 800);
    view->XC = CGPointMake(200, 750);
    view->Y = CGPointMake(450, 800);
    view->YC = CGPointMake(450, 850);
    
    view->comprimento =
    [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [view addSubview:view->comprimento];
    [view->comprimento setTextAlignment:NSTextAlignmentRight];
    [view->comprimento setBackgroundColor:[UIColor clearColor]];
    
    view->dist_intersecao =
    [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [view addSubview:view->dist_intersecao];
    [view->dist_intersecao setTextAlignment:NSTextAlignmentRight];
    [view->dist_intersecao setBackgroundColor:[UIColor clearColor]];
    
    view->dotControl = [HVDot dotAt:view->Control inView:view];
    view->dotA = [HVDot dotAt:view->A inView:view];
    view->dotB = [HVDot dotAt:view->B inView:view];
    view->dotLinha = [HVDot dotAt:view->linha inView:view];
    view->dotP1 = [HVDot dotAt:view->P1 inView:view];
    view->dotP1C = [HVDot dotAt:view->P1C inView:view];
    view->dotP2 = [HVDot dotAt:view->P2 inView:view];
    view->dotP2C = [HVDot dotAt:view->P2C inView:view];
    view->dotP2C_ = [HVDot dotAt:view->P2C_ inView:view];
    view->dotP3 = [HVDot dotAt:view->P3 inView:view];
    view->dotP3C = [HVDot dotAt:view->P3C inView:view];
    view->dotX = [HVDot dotAt:view->X inView:view];
    view->dotXC = [HVDot dotAt:view->XC inView:view];
    view->dotY = [HVDot dotAt:view->Y inView:view];
    view->dotYC = [HVDot dotAt:view->YC inView:view];

    
    [view->dotControl setDrag:view action:@selector(updatePoints)];
    [view->dotA setDrag:view action:@selector(updatePoints)];
    [view->dotB setDrag:view action:@selector(updatePoints)];
    [view->dotLinha setDrag:view action:@selector(updatePoints)];
    [view->dotP1 setDrag:view action:@selector(updatePoints)];
    [view->dotP1C setDrag:view action:@selector(updatePoints)];
    [view->dotP2 setDrag:view action:@selector(updatePoints)];
    [view->dotP2C setDrag:view action:@selector(updatePoints)];
    [view->dotP2C_ setDrag:view action:@selector(updatePoints)];
    [view->dotP3 setDrag:view action:@selector(updatePoints)];
    [view->dotP3C setDrag:view action:@selector(updatePoints)];
    [view->dotX setDrag:view action:@selector(updatePoints)];
    [view->dotY setDrag:view action:@selector(updatePoints)];
    [view->dotXC setDrag:view action:@selector(updatePoints)];
    [view->dotYC setDrag:view action:@selector(updatePoints)];
    return view;
}

- (void)adjustPercentage{
    NSLog(@"slider1: %0.02f   Slider2: %0.02f",
          [percentage_slider value],
          [percentage_slider2 value]);
    [self setNeedsDisplay];
}

- (void)updatePoints{
    Control = dotControl.center;
    A = dotA.center;
    B = dotB.center;
    linha = dotLinha.center;
    P1 = dotP1.center;
    P1C = dotP1C.center;
    P2 = dotP2.center;
    P2C = dotP2C.center;
    P2C_ = dotP2C_.center;
    P3 = dotP3.center;
    P3C = dotP3C.center;
    X = dotX.center;
    Y = dotY.center;
    XC = dotXC.center;
    YC = dotYC.center;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    double percentage = [percentage_slider value];
    double percentage2 = [percentage_slider2 value];

    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:A];
    [path addQuadCurveToPoint:B controlPoint:Control];
    [path stroke];
    
    CGPoint P3Cr = sumVectors(P2, reverseVector(subVectors(P2C, P2)));
    P3Cr = P2C_;
    UIBezierPath * path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:P1];
    [path2 addCurveToPoint:P2 controlPoint1:P1C controlPoint2:P2C];
    [path2 addCurveToPoint:P3 controlPoint1:P3Cr controlPoint2:P3C];
    [path2 stroke];
    
    UIBezierPath * path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:X];
    [path3 addCurveToPoint:Y controlPoint1:XC controlPoint2:YC];
    [path3 stroke];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    drawCircle(context, A, 5);
    drawCircle(context, B, 5);
    drawCircle(context, Control, 5);

    drawCircle(context, P1, 5);
    drawCircle(context, P2, 5);
    drawCircle(context, P3Cr, 5);
    drawCircle(context, P3, 5);
    CGPoint pointInCubicCurve =
    pointInCubicBezierAtValue(P1, P2, P1C, P2C, percentage2);
    drawCircle(context, pointInCubicCurve, 5);
    double comp = lengthOfCubicBezierSegment(P1, P2, P1C, P2C);
    [comprimento setText:[NSString stringWithFormat:@"%0.02f", comp]];
    [comprimento setCenter:sumVectors(CGPointMake(0, -20), pointInCubicCurve)];
    
    CGContextFillPath(context);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
    CGFloat dash[] = {5.0, 5.0};
    CGContextSetLineDash(context, 2, dash, 2);
    CGContextMoveToPoint(context, A.x, A.y);
//    CGContextAddLineToPoint(context, Control.x, Control.y);
    CGContextAddLineToPoint(context, B.x, B.y);
//    CGContextAddLineToPoint(context, A.x, A.y);
    
    /*
    
    CGContextMoveToPoint(context, Control.x, Control.y);
    double bissetriz = angleOfBisectrixInsideTriangule(A, Control, B);
    double dist = distanceToSegment(A, B, Control);
    CGPoint bissetriz_point = pointAround(Control, dist, bissetriz);
    CGContextAddLineToPoint(context, bissetriz_point.x, bissetriz_point.y);
    
    CGContextMoveToPoint(context, A.x, A.y);
    bissetriz = angleOfBisectrixInsideTriangule(Control, A, B);
    dist = distanceToSegment(Control, B, A);
    bissetriz_point = pointAround(A, dist, bissetriz);
    CGContextAddLineToPoint(context, bissetriz_point.x, bissetriz_point.y);
    
    CGContextMoveToPoint(context, B.x, B.y);
    bissetriz = angleOfBisectrixInsideTriangule(A, B, Control);
    dist = distanceToSegment(A, Control, B);
    bissetriz_point = pointAround(B, dist, bissetriz);
    CGContextAddLineToPoint(context, bissetriz_point.x, bissetriz_point.y);
    
     */
    
    CGContextMoveToPoint(context, Control.x, Control.y);
    CGPoint midAB = midpoint(A, B);
//    CGContextAddLineToPoint(context, midAB.x, midAB.y);
    
    CGContextMoveToPoint(context, A.x, A.y);
    CGPoint midBC = midpoint(B, Control);
//    CGContextAddLineToPoint(context, midBC.x, midBC.y);
    
    CGContextMoveToPoint(context, B.x, B.y);
    CGPoint midAC = midpoint(A, Control);
//    CGContextAddLineToPoint(context, midAC.x, midAC.y);
    
    CGContextMoveToPoint(context, midAC.x, midAC.y);
//    CGContextAddLineToPoint(context, midBC.x, midBC.y);
    
    CGPoint midMid = midpoint(midAC, midBC);
    
    CGContextStrokePath(context);
    
    CGPoint firstSegment = sumVectors(A, multiplyVector(percentage, subVectors(Control, A)));
    CGPoint secondSegment = sumVectors(B, multiplyVector(1-percentage, subVectors(Control, B)));
    CGPoint intersect = sumVectors(firstSegment, multiplyVector(percentage,
                                                     subVectors(secondSegment, firstSegment)));
    //drawLine(context, firstSegment, secondSegment);
    CGPoint projectionI = projectionOfPointToSegment(intersect, A, B);
    CGPoint projectionC = projectionOfPointToSegment(Control, A, B);
    //drawLine(context, intersect, projectionI);
    //drawLine(context, Control, projectionC);
    
    drawLine(context, P1, P1C);
    drawLine(context, P2, P2C);
    drawLine(context, P2, P3Cr);
    drawLine(context, P3, P3C);
    
    drawLine(context, X, XC);
    drawLine(context, Y, YC);
    
    CGPoint AB = midpoint(A, B);
    double bissetriz = angleOfBisectrixInsideTriangule(A, Control, B);
    CGPoint bissetrizP = pointAround(Control, 100, bissetriz);
    CGPoint bP = intersectionOfSegments(A, B, Control, bissetrizP);
    
    CGPoint pontoAltaDensidade = density(A, B, Control);
    CGPoint d = intersectionOfSegments(A, B, Control, pontoAltaDensidade);
    //HVlog(@"percentage densidade: ", distance(A, d)/distance(A, B));
    double ACB = (distance(Control, B) + distance(A, Control));
    double CM = distanceToSegment(A, B, Control)/ (distance(A, Control));
    double CP = distance(Control, projectionC) / distance(A, B);
    HVlog(@"relacao AC/ACB: ", distance(A, Control)/ ACB);
    //HVlog(@"relacao CM/ACB: ", CM);
    double sinal = distance(A, projectionC)<distance(projectionC, B)?-1:1;
    double relation1 = distance(AB, projectionC)/distance(A, B);
    double distCtoAB = 0.1 * distanceToSegment(A, B, Control);
    distCtoAB = (distCtoAB < 0.001)?0.001:distCtoAB;
    double relation2 = distance(A, B) / distCtoAB;
    //HVlog(@"relacao1 : ", sinal * relation1);
    //HVlog(@"relacao2 : ", relation2);
    //HVlog(@"sigmoid : ", functionSigmoid(relation2 * relation1 * sinal)+0.5);

    //drawLine(context, Control, d);
    
    
    HVBezierSegment cubic = convertQuadBezierToCubicBezier(A, B, Control);
    
    drawLine(context, cubic.P1C, cubic.P2C);
    
    CGPoint ponto = pointInCubicBezierUsingLengthPercentage(cubic.P1,
                                                            cubic.P2,
                                                            cubic.P1C,
                                                            cubic.P2C,
                                                            percentage);
    
    
//    drawLine(context, P1C, P2C);
//    drawLine(context, P1C, Control);
//    drawLine(context, P2C, Control);
    
    //NSLog(@"dist: %0.02f , %0.02f, percentage: %0.02f",
    //      distance(A, projectionI) / distance(A, B),
      //    distance(A, projectionC) / distance(A, B),
       //   percentage);
//        NSLog(@"dist: %0.02f, percentage: %0.02f",
//              distance(intersect, projectionI) / distance(Control, projectionC),
//              percentage);
    
    CGContextStrokePath(context);
//    drawCircle(context, midMid, 5);
//    drawCircle(context, firstSegment, 5);
//    drawCircle(context, secondSegment, 5);
    CGPoint intersectMenosZeroVirgulaUm =
    pointInQuadraticBezierAtValue(A, B, Control, percentage - 0.05);
    //drawCircle(context, intersect, 5);
    //drawCircle(context, intersectMenosZeroVirgulaUm, 5);
    drawCircle(context, ponto, 5);
    drawCircle(context, cubic.P1C, 5);
    drawCircle(context, cubic.P2C, 5);
    CGContextFillPath(context);
    
    [dist_intersecao setText:[NSString stringWithFormat:@"%0.02f", distance(intersect, intersectMenosZeroVirgulaUm)]];
    [dist_intersecao setCenter:sumVectors(CGPointMake(0, -30), intersect)];
    
    double dist_i = distanceToSegment(A, B, intersect);
    double dist_c = distanceToSegment(A, B, Control);
    double angle_acb = angleOfVertex(A, Control, B);
    double angle_aib = angleOfVertex(A, intersect, B);
    
//    NSLog(@"t: %0.02f  d1: %0.02f  d2:%0.02f  d1/d2: %0.02f", percentage, dist_i, dist_c, dist_i/dist_c);
    
//    NSLog(@"t: %0.02f  angle ACB: %0.02f  angle AIB:%0.02f ", percentage, radiansToEuler(angle_acb), radiansToEuler(angle_aib));
    
 //   if ((percentage > 0.001)&&(percentage < 0.999)) {
    
    /*

        double angleBAI = angleOfVertex(B, A, projectionI);
        int sinal = ((angleBAI > 0.5 * HV_PI) && (angleBAI < 1.5 * HV_PI))?-1:1;
        double alpha = - 2 * (pow(percentage, 2) - percentage);
        double func = sinal * distance(A, projectionI) / distance(A, B);
        double factor = (func - pow(percentage, 2)) / alpha;
        double distanceProjectionToControl = distance(intersect, projectionI) / alpha;
        CGPoint controlProjection = sumVectors(A, multiplyVector(factor, subVectors(B, A)));
        CGPoint controlCalculed = pointAround(controlProjection,
                                              distanceProjectionToControl,
                                              angleOfSegment(projectionI, intersect));
     */
    CGPoint controlCalculed = pointControlOfQuadraticBezier(A, B, intersect, percentage);
    
    
        CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
        CGContextSetLineDash(context, 0, NULL, 0);
        //drawCircle(context, controlProjection, 7);
    drawCircle(context, controlCalculed, 7);
        CGContextStrokePath(context);
   // }
    //    CGContextFillPath(context);
    
    
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    /*
    NSArray * fingers = [touches sortedArrayUsingDescriptors:nil];
    for (int i=0; i < [fingers count]; i++) {
        UITouch * touch = (UITouch *)[fingers objectAtIndex:i];
        Control = [touch locationInView:self];
    }
    
    [super touchesMoved:touches withEvent:event];
    
    [self setNeedsDisplay]; */
}

@end

@interface teste_BezierViewController ()

@end

@implementation teste_BezierViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    teste_Bezier * bezierView = [teste_Bezier fastCreation];
    [self.view addSubview:bezierView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
