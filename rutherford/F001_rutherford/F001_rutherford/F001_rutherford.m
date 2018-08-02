//
//  F001_rutherford.m
//  F001_rutherford
//
//  Created by User on 22/05/13.
//  Copyright (c) 2013 iDucation. All rights reserved.
//

#import "F001_rutherford.h"

@implementation F001_rutherfordContainer

+ (F001_rutherfordContainer *) fastCreationSettingParent:(UIView *)parent{
    F001_rutherfordContainer * view =
    [[F001_rutherfordContainer alloc] init];
    
    view->startPoint =      CGPointMake(275, 410);
    view->reflectionPoint = CGPointMake(490, 330);
    view->endPoint =        CGPointMake(585, 275);
    
    UIImage * bg = [UIImage imageNamed:@"F001_rutherford_scene.png"];
    float factor = 768.0 / bg.size.width;
    CGRect frm = CGRectMake(0, 100, 768, bg.size.height * factor);
    
    UIImageView * imgView = [[UIImageView alloc] initWithImage:bg];
    [imgView setFrame:frm];
    view->scene = imgView;
    
    bg = [UIImage imageNamed:@"F001_rutherford_machine.png"];
    imgView = [[UIImageView alloc] initWithImage:bg];
    [imgView setFrame:frm];
    view->machine = imgView;

    bg = [UIImage imageNamed:@"F001_rutherford_machine_shine.png"];
    imgView = [[UIImageView alloc] initWithImage:bg];
    [imgView setFrame:frm];
    view->machineShine = imgView;
    [view->machineShine setAlpha:0.0];

    bg = [UIImage imageNamed:@"F001_rutherford_gold_01.png"];
    imgView = [[UIImageView alloc] initWithImage:bg];
    [imgView setFrame:frm];
    view->gold_01 = imgView;

    bg = [UIImage imageNamed:@"F001_rutherford_gold_02.png"];
    imgView = [[UIImageView alloc] initWithImage:bg];
    [imgView setFrame:frm];
    view->gold_02 = imgView;
    
    F001_rutherfordRay * ray1 =
    [F001_rutherfordRay fastCreation:view];
    
    CADisplayLink * dLink = [CADisplayLink displayLinkWithTarget:view selector:@selector(displayLinkCalled:)];
    [dLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [dLink setFrameInterval:1];
    
    HVAnimatedAlphaView * blink =
    [HVAnimatedAlphaView fastCreationSettingTarget:view->machineShine];
    [blink setAnimLoops:-1 interval:0.25 minAlpha:0.5 maxAlpha:1];
    view->machineShineBlink = blink;
    
    view->gestureArea = [HVGesturesArea fastCreation];
    [view->gestureArea setActionsToTarget:view
                              onSingleTap:@selector(tap)
                              onDoubleTap:nil];
    
    view->machinePosition = CGPointMake(220, 430);
    view->machineActive = NO;
    view->progress = 0;
    view->cycleTime = 5.0;
    
    [view addSubview:view->scene];
    [view addSubview:view->machine];
    [view addSubview:view->machineShine];
    [view addSubview:ray1];
    [view addSubview:view->gold_01];
    [view addSubview:view->gold_02];
    [view addSubview:view->gestureArea];
    
    view->dotMachine = [HVDot dotAt:CGPointMake(270, 410) inView:view];
    [view->dotMachine setDrag:nil action:nil];
    
    [parent addSubview:view];
    [view adjustToParent];
    [view->gestureArea adjustToParent];
    [ray1 adjustToParent];
    return view;
}

- (void) displayLinkCalled:(CADisplayLink *)sender{
    CFTimeInterval time = [sender timestamp] - lastTimestamp;
    if (machineActive) {
        //[machineShine setAlpha:sin(time)];
    }
    double porcentagem = time/cycleTime;
    progress += porcentagem;
    
    progress = progress>1?0:progress;
    HVlog(@"timestamp: ", progress);
    lastTimestamp = [sender timestamp];
}

- (void) tap{
    CGPoint tapPoint = [gestureArea lastSingleTap];
    if (distance(tapPoint, machinePosition) < 40) {
        machineActive = !machineActive;
        [machineShineBlink setAnimLoops:(machineActive?-1:1)];
        [machineShineBlink blinkAndHide];
        HVlog(@"machine ", 0);
    }
}

@end

@implementation F001_rutherfordRay

+ (F001_rutherfordRay *)fastCreation:(F001_rutherfordContainer *)parent{
    F001_rutherfordRay * ray = [[F001_rutherfordRay alloc] init];
    ray->container = parent;
    NSMutableArray * points = [NSMutableArray array];
    CGPoint start = ray->container->startPoint;
    CGPoint reflection = ray->container->reflectionPoint;
    CGPoint end = ray->container->endPoint;
    [points addObject:[NSValue valueWithCGPoint:start]];
    [points addObject:[NSValue valueWithCGPoint:reflection]];
    [points addObject:[NSValue valueWithCGPoint:end]];
    ray->bezier = [HVBezier initWithArray:points];

    return ray;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIBezierPath * path = [bezier getBezierPath];
    [path stroke];
}

@end
