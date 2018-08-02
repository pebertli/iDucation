//
//  TestesGesturesViewController.m
//  testeGestures
//
//  Created by User on 07/03/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import "TestesGesturesViewController.h"
#import "../../../../HVCommon/HVGeometry.h"
#import "../../../../HVCommon/HVUtils.h"
#import "../../../../HVCommon/HVCustomizedViews.h"
#import <UIKit/UIApplication.h>
#import <UIKit/UIKit.h>

@interface TestesGesturesViewController ()

@end

@implementation TestesGesturesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    view = [ViewComReconhecimentoDeGestures fastCreation];
    [self.view addSubview:view];
   
    [view adjustToParent];
    
    // Create a path to connect lines
    
    
    // Capture touches
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:view action:@selector(pan:)];
    pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
    [view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 2;
    
    [view addGestureRecognizer:tap];
    
    gesturesArea = [HVGesturesArea fastCreationSettingNumberOfFingers:2];
    [gesturesArea setBackgroundColor:[UIColor greenColor]];
    [gesturesArea enableScaleAndRotation:YES];
    [gesturesArea ignoreSingleTapBeforeDoubleTap];
    [gesturesArea setNumberOfPeriods:3]; // salva apenas os ultimos 3 periodos
    SEL action = @selector(setNeedsDisplay);
    [gesturesArea setActionsToTarget:view
                             onStart:action
                            onChange:action
                               onEnd:action];
    [gesturesArea setActionsToTarget:view
                         onSingleTap:action
                         onDoubleTap:action];
    
    [gesturesArea setAlpha:0.25];
    [gesturesArea enablePanGestureRecognizer:YES];
    
    view->testGesturesArea = gesturesArea;
    
    [self.view addSubview:gesturesArea];
    
    avisos = [HVImageMatrix fastCreation:@"IDC_gesture_hands.png"];
    [avisos setImageScale:2];
    //[avisos setMatrixRowsCount:2 andColsCount:4];
    [avisos setMatrixCellWidth:200 andHeight:200];
    [avisos setIndex:3];
    [self.view addSubview:avisos];
    [avisos setCenter:self.view.center];
    [avisos setAnimLoops:3 interval:0.5 minAlpha:0.25 maxAlpha:1];
    [avisos blinkAndHide];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tap:(UITapGestureRecognizer *)tap{
    [avisos blinkAndHide];
    [view tap:tap];
}

@end


@implementation ViewComReconhecimentoDeGestures

+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point radius:(double)radius{
    CGContextAddEllipseInRect(context, CGRectMake(point.x - radius,
                                                  point.y - radius,
                                                  2*radius,
                                                  2*radius));
}

+ (ViewComReconhecimentoDeGestures *) fastCreation{
    
    ViewComReconhecimentoDeGestures * view = [[ViewComReconhecimentoDeGestures alloc] initWithFrame:CGRectMake(40, 30, 400, 600)];
    view->path = [UIBezierPath bezierPath];
    [view setBackgroundColor:[UIColor yellowColor]];
    view->vertexes = [NSMutableArray array];
    view->points = [NSMutableArray array];
    view->accuracy = 20;
    view->rot = 0;
    view->escala = 1;
    view->currentVertex = 0;
    view->movingTestVertex = NO;
    view->retangulo_escala = CGRectMake(0, 0, 30, 40);
    view->testA = CGPointMake(200, 300);
    view->testB = CGPointMake(500, 200);
    view->testVertex = [view center];
    view->testE = CGPointMake(600, 150);
    view->testF = pointAround(view->testE, 50, eulerToRadians(45));
    
    
    return view;
}

- (void)becomeActive:(UIApplication *)application
{
    HVmsg(@"Esta aplicação se tornou ativa.");
}

- (void)tap:(UITapGestureRecognizer *)tap{
    CGPoint currentPoint = [tap locationInView:self];
    testVertex = currentPoint;
    [self setNeedsDisplay];
    [testGesturesArea removeAllPoints];
//    UIApplication * appDelegate = (UIApplication *)[[UIApplication sharedApplication] delegate]; 
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint currentPoint = [pan locationInView:self];
    
    double dist_vertex = distance(testVertex, currentPoint);
    if ((movingTestVertex)&&(pan.state != UIGestureRecognizerStateEnded)) {
        testVertex = currentPoint;
        [self setNeedsDisplay];
        return;
    }
    
    [points addObject:[NSValue valueWithCGPoint:currentPoint]];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (dist_vertex < accuracy) {
            testVertex = currentPoint;
            movingTestVertex = YES;
            [self setNeedsDisplay];
            return;
        }
        [vertexes addObject:[NSValue valueWithCGPoint:currentPoint]];
        [path moveToPoint:currentPoint];
        testC = currentPoint;
    } else if (pan.state == UIGestureRecognizerStateChanged){
        [path addLineToPoint:currentPoint];
        CGPoint lastVertex = [[points objectAtIndex:currentVertex] CGPointValue];
        double highest_distance = 0;
        int highest_index = 0;
        BOOL reverse = NO;
        int qtd = ([points count] - 2);
        for (int i = qtd; i > currentVertex; i--) {
            CGPoint P = [[points objectAtIndex:i] CGPointValue];
            double dist = distanceToSegment(lastVertex, currentPoint, P);
            double dist_C = distance(currentPoint, lastVertex);
            double dist_V = distance(P, lastVertex);
            double dist_P = distance(P, currentPoint);
            double dist_CV = ABS(dist_C - dist_V);
            if (dist_P > 3*accuracy) {
                continue;
            }
            if (dist > highest_distance) {
                highest_distance = dist;
                highest_index = i;
            }
            if ((dist_C < dist_V)&&(dist_CV > accuracy)){
                [vertexes addObject:[points objectAtIndex:highest_index]];
                currentVertex = highest_index;
                reverse = YES;
                break;
            }
        }
        if ((highest_distance > accuracy)&&(!reverse)){
            [vertexes addObject:[points objectAtIndex:highest_index]];
            currentVertex = highest_index;
        }
        
    }else if (pan.state == UIGestureRecognizerStateEnded){
        if (!movingTestVertex) {
            [vertexes addObject:[NSValue valueWithCGPoint:currentPoint]];
            currentVertex = [points count] - 1;
            testD = currentPoint;
        }else{
            movingTestVertex = NO;
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
//    Desenhos na GESTURES_AREA
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    for (int i=0; i < 2; i++) {
        NSMutableArray * periodos = [testGesturesArea periodsOfFinger:i];
        for (int j = 0; j< [periodos count]; j++) {
            
        [[HVGesturesArea bezierPathFromArrayOfPoints:[periodos objectAtIndex:j]] stroke];
        }
    }
    
    NSMutableArray * vertexes_g = [HVGesturesArea getVertexesFromArray:
                                 [testGesturesArea pointsOfFinger:0 onPeriod:-1] accuracy:20];
    
    NSMutableArray * tapSimples = [testGesturesArea singleTapPoints];
    NSMutableArray * tapDuplos = [testGesturesArea doubleTapPoints];
    
    if (vertexes_g != nil) {
        for (int i=0; i<[vertexes_g count]; i++) {
            drawCircle(context, [[vertexes_g objectAtIndex:i] CGPointValue], 5);
        }
    }
    
    if (tapSimples != nil) {
        for (int i=0; i<[tapSimples count]; i++) {
            drawCircle(context, [[tapSimples objectAtIndex:i] CGPointValue], 3);
        }
    }
    
    if (tapDuplos != nil) {
        for (int i=0; i<[tapDuplos count]; i++) {
            drawCircle(context, [[tapDuplos objectAtIndex:i] CGPointValue], 3);
        }
    }
    
    CGContextFillPath(context);
    
    //CGContextStrokePath(context);
    
    //CGContextFillPath(context);
    
    if (tapDuplos != nil) {
        for (int i=0; i<[tapDuplos count]; i++) {
            drawCircle(context, [[tapDuplos objectAtIndex:i] CGPointValue], 6);
        }
    }
    
    CGContextStrokePath(context);
    
    // Desenhos na VIEW_COM_RECONHECIMENTO_DE_GESTURES
    
    
    [[UIColor blackColor] setStroke];
    [path stroke];
    
    
    if (vertexes
        != nil) {
        for (int i=0; i<[vertexes count]; i++) {
            [ViewComReconhecimentoDeGestures drawPoint:context point:[[vertexes objectAtIndex:i] CGPointValue] radius:4];
        }
    }
    CGContextFillPath(context);
    
    CGContextMoveToPoint(context, testA.x, testA.y);
    CGContextAddLineToPoint(context, testB.x, testB.y);

//    CGContextMoveToPoint(context, testC.x, testC.y);
//    CGContextAddLineToPoint(context, testD.x, testD.y);
    

    CGContextStrokePath(context);
    
    [ViewComReconhecimentoDeGestures drawPoint:context point:testA radius:3];
    [ViewComReconhecimentoDeGestures drawPoint:context point:testB radius:3];
    
    [ViewComReconhecimentoDeGestures drawPoint:context point:testVertex radius:8];
    
    CGContextFillPath(context);
    
    double ang = angleOfVertex(testA, testB, testVertex);
    double dist = distanceToSegment(testA, testB, testVertex);
    double dist_VB = distance(testB, testVertex);
    double dist_intersecao = cos(ang) * dist_VB;
    CGContextAddEllipseInRect(context, CGRectMake(testVertex.x - dist,
                                                  testVertex.y - dist,
                                                  2*dist, 2*dist));
    
    
    double bissetriz = angleOfBisectrixInsideTriangule(testA, testVertex, testB);
    CGPoint bissetriz_point = pointAround(testVertex, dist, bissetriz);
    CGContextMoveToPoint(context, testVertex.x, testVertex.y);
    CGContextAddLineToPoint(context, bissetriz_point.x, bissetriz_point.y);
    
    CGPoint altura_point = pointAround(testB, dist_intersecao, angleOfSegment(testB, testA));
    CGContextMoveToPoint(context, testVertex.x, testVertex.y);
    CGContextAddLineToPoint(context, altura_point.x, altura_point.y);
    
    CGContextMoveToPoint(context, testVertex.x, testVertex.y);
    CGContextAddLineToPoint(context, testA.x, testA.y);
    
    CGContextMoveToPoint(context, testVertex.x, testVertex.y);
    CGContextAddLineToPoint(context, testB.x, testB.y);
    NSMutableArray *pontos_do_triangulo = [[NSMutableArray alloc] initWithObjects:
     [NSValue valueWithCGPoint: testA],
     [NSValue valueWithCGPoint: testB],
     [NSValue valueWithCGPoint: testVertex],
     nil];
    CGPoint centro_do_triangulo = centerOfPolygon(pontos_do_triangulo);
     [ViewComReconhecimentoDeGestures drawPoint:context point:centro_do_triangulo radius:3];
   
    
    CGPoint centro_do_contato = [testGesturesArea centerOfTouchesCurrently];
    [ViewComReconhecimentoDeGestures drawPoint:context point:centro_do_contato radius:10];

    CGContextStrokePath(context);
    
    [[UIColor redColor] setStroke];
    
    CGRect container_do_triangulo = rectContainerOfPoints(pontos_do_triangulo);
    CGContextAddRect(context, container_do_triangulo);
    
    
    if ([testGesturesArea numberOfTouchesCurrently] > 1) {
        
        rot = angleOfSegment(testE, testF);
        rot =  [testGesturesArea rotation];
        escala = [testGesturesArea scale];
    }
    
    //HVlog(@"escala: ", escala);
    
    testF = pointAround(testE, 50, rot);
    CGPoint G = pointAround(testE, 50, rot + HV_PI);
    CGContextMoveToPoint(context, G.x, G.y);
    CGContextAddLineToPoint(context, testF.x, testF.y);
    
    CGPoint centro_da_escala = testE;
    
    double new_w = 50 * escala;
    double new_h = 50 * escala;
    
    retangulo_escala = CGRectMake(centro_da_escala.x - (new_w / 2),
                                  centro_da_escala.y - (new_h / 2),
                                  new_w, new_h);
    
    CGContextAddRect(context, retangulo_escala);
    
    CGContextStrokePath(context);
    [ViewComReconhecimentoDeGestures drawPoint:context point:testE radius:4];
    CGContextFillPath(context);
    
}

@end