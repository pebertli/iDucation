//
//  F001_amber.m
//  F001_amber
//
//  Created by User on 13/06/13.
//  Copyright (c) 2013 iDucation. All rights reserved.
//

#import "F001_amber.h"

@implementation F001_amberLeaf

+ (F001_amberLeaf *) leaf{
    F001_amberLeaf * leaf = [[F001_amberLeaf alloc] init];
    [leaf config:[UIImage imageNamed:@"F001_amber_leaf.png"]];
    [leaf setMatrixRowsCount:3 andColsCount:4];
    [leaf setIndex:randomBetween(0, 11)];
    return leaf;
}

- (void) updateFall{
    if (distance(end, self.center) > 0.5) {
        self.center = sumVectors(self.center, direction);
    }
}

- (void) updateAnimation{
    switch (container->state) {
        case F001_amberContainerStateStopped:
            break;
        case F001_amberContainerStateFallingLeaves:
            [self updateFall];
            break;
        case F001_amberContainerStateAmberCharged:
            break;
        case F001_amberContainerStateAmberDischarged:
            break;
    }
}

@end

@implementation F001_amberContainer

+ (F001_amberContainer *) fastCreationSettingParent:(UIView *)parent{
    F001_amberContainer * view = [[F001_amberContainer alloc] init];
    [parent addSubview:view];
    [view adjustToParent];
    [view config];
    [view createLeaves];
    
    return view;
}

- (void)config{
    state = F001_amberContainerStateStopped;
    topY = 400;
    baseY = 900;
    fallDuration = 1.5;
    
    displayLink = [CADisplayLink
                   displayLinkWithTarget:self
                   selector:@selector(updateAnimations)];
    
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                      forMode:NSDefaultRunLoopMode];
    
    displayLink.paused = YES;
    
}

- (void)updateAnimations{
    for (int i=0; i<[leaves count]; i++) {
        F001_amberLeaf * leaf = (F001_amberLeaf *)[leaves objectAtIndex:i];
        [leaf updateAnimation];
    }
}

- (void)prepareToLeavesFall{
    for (int i=0; i<[leaves count]; i++) {
        F001_amberLeaf * leaf = (F001_amberLeaf *)[leaves objectAtIndex:i];
        leaf.center = CGPointMake(350, 50);
        leaf->end = CGPointMake(350, baseY);
        leaf->direction = CGPointMake(0, 0.5);
    }
}

- (void)createLeaves{
    leaves = [NSMutableArray array];
    F001_amberLeaf * leaf = [F001_amberLeaf leaf];
    leaf->container = self;
    [self addSubview:leaf];
    [leaves addObject:leaf];
    [leaf alignToCenter];
}

- (void)fallLeaves{
    state = F001_amberContainerStateFallingLeaves;
    displayLink.paused = NO;
}

@end

@implementation F001_amberScene

+ (F001_amberScene *)amberSceneAt:(CGPoint)_position inView:(UIView *)_parent{
    F001_amberScene * scene = [[F001_amberScene alloc] init];
    
    [_parent addSubview:scene];
    [scene config:_position inView:_parent];
    
    return scene;
}

- (void)config:(CGPoint)_position inView:(UIView *)_parent{
    UIImage * img = [UIImage imageNamed:@"F001_amber_scene.png"];
    float factorScale = 0.6;
    lineTie = CGPointMake(272, 12);
    UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
    [imgView setFrame:CGRectMake(0, 0,
                                 img.size.width * factorScale,
                                 img.size.height * factorScale)];
    [self setFrame:CGRectMake(_position.x, _position.y,
                               img.size.width, img.size.height)];
    [self addSubview:imgView];
    UIImage * img2 = [UIImage imageNamed:@"F001_amber_line.png"];
    lineLength = img2.size.height * factorScale;
    UIImageView * imgView2 = [[UIImageView alloc] initWithImage:img2];
    [imgView2 setFrame:CGRectMake(0, 0,
                                  img2.size.width * factorScale,
                                  lineLength)];
    [self addSubview:imgView];
    [self addSubview:imgView2];
    line = imgView2;
    
    line.layer.anchorPoint = CGPointMake(0.5, 0);
    [line setCenter:CGPointMake(lineTie.x, lineTie.y)];
    
    displayLink =
    [CADisplayLink displayLinkWithTarget:self selector:@selector(updateScene)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                      forMode:NSDefaultRunLoopMode];
    [displayLink setFrameInterval:1];
    
    sphere = [HVImageMatrix fastCreation:@"F001_amber_sphere.png"];
    [sphere setImageScale:0.8];
    [self addSubview:sphere];
    [sphere setCenter:CGPointMake(lineTie.x, lineTie.y + lineLength)];
    
    sphereLimit = 100;
    
}

- (void)setSphereProgress:(double)progress{
    float x = ABS(progress)>1?sphereLimit:(sphereLimit*progress);
    x = progress<0?-x:x;
    float y = sqrt(pow(lineLength, 2) - pow(x, 2));
    [sphere setCenter:sumVectors(lineTie, CGPointMake(x, y))];
    double angle = angleOfSegment(lineTie, sphere.center) - 0.5 * HV_PI;
    line.transform = CGAffineTransformMakeRotation(angle);
}


- (void)updateLine{
    [self setSphereProgress:stone.electriccharge/10];
    float dist = distance(stone.center, sumVectors(self.frame.origin, sphere.center));
    HVlog(@"dist:", dist);
    // HVlog(@"updateLine point:", stone.electriccharge);
}

- (void)updateScene{
   // NSLog(@"charge: %0.08f", stone.electriccharge);
    [stone processTouchesAndCharge];
}

@end

@implementation F001_amberStone

@synthesize electriccharge = _electriccharge;

+ (F001_amberStone *)amberStoneAt:(CGPoint)_pt inScene:(F001_amberScene *)_scene{
    F001_amberStone * stone = [[F001_amberStone alloc] init];
    stone->scene = _scene;
    _scene->stone = stone;
    [_scene addSubview:stone];
    [stone config];
    [stone setCenter:_pt];
    [stone configBalloon];
    return stone;
}

- (void)configBalloon{
    balloon = [HVBalloon balloonToView:self];
    [balloon setAnimLoops:1 interval:0.25 minAlpha:0 maxAlpha:1];
    //[balloon setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:0.25]];
    
    UIImage * icons = [UIImage imageNamed:@"F001_amber_buttons.png"];
    HVToolbar * toolbar =
    [HVToolbar fastCreationSettingImage:icons andButtonSize:CGSizeMake(80, 80)];
    toolbar->buttonMargin = 10;
    [toolbar setImageScale:0.8];
    HVToolbarGroup * grupo1 = [HVToolbarGroup fastCreationInToolbar:toolbar];
    HVToolbarButton * bt3 = [grupo1 addButtonWithIconIndex:3];
    HVToolbarButton * bt2 = [grupo1 addButtonWithIconIndex:2];
    [bt3 setIndexToBackground:7];
    [bt2 setIndexToBackground:7];
    
    [bt3 setAnimLoops:3 interval:0.1 minAlpha:0.25 maxAlpha:1];
    [bt2 setAnimLoops:3 interval:0.1 minAlpha:0.25 maxAlpha:1];
    
    [bt3 setAction:self onEnd:@selector(enableFriction)];
    [bt2 setAction:self onEnd:@selector(enableDrag)];
    
    UIImage * msk = [bt3 imageFromIndex:7 scale:0.8];
    shineButton3 = [HVShineView fastCreationSettingParent:bt3];
    shineButton2 = [HVShineView fastCreationSettingParent:bt2];
    [shineButton3 setShineWithDefaultLinearGradient:[UIColor colorWithRed:1
                                                              green:1
                                                               blue:1
                                                              alpha:0.75]];
    [shineButton2 setShineWithDefaultLinearGradient:[UIColor colorWithRed:1
                                                                    green:1
                                                                     blue:1
                                                                    alpha:0.75]];
    [shineButton3 setMaskImage:msk];
    [shineButton2 setMaskImage:msk];

    
    //[bt3 setAction:self onSigleTap:@selector(enableFriction) onDoubleTap:nil];
    //[bt2 setAction:self onSigleTap:@selector(enableDrag) onDoubleTap:nil];
    
    [balloon addSubview:toolbar hasToFit:YES];
    //[balloon showBalloon];
    balloon.autoHide = YES;
    [balloon setAction:self
         onShowBalloon:nil
        onCloseBalloon:@selector(onBalloonClose)];
}

- (void)adjustBalloon{
    [balloon showBalloon];
    [shine setAlpha:0];
}

- (void) setAmberState:(enum F001_amberStoneState)_state{
    state = _state;
    if (state == F001_amberStoneInitial) {
        [shine setAlpha:1];
    }else{
        [shine setAlpha:0];
        [balloon hide];
        
        if (state == F001_amberStoneDrag) {
            [drag enableDrag:YES];
        }else if(state == F001_amberStoneFriction){
            [drag enableDrag:NO];
        }
    }
}

- (void)onBalloonClose{
    if (state == F001_amberStoneInitial) {
        [shine setAlpha:1];
    }
}

- (void)enableDrag{
    [self setAmberState:F001_amberStoneDrag];
    [shineButton2 setAlpha:0];
}

- (void)enableFriction{
    [self setAmberState:F001_amberStoneFriction];
    [shineButton3 setAlpha:0];
}

- (void)config{
    float factorScale = 0.65;
    UIImage * img = [UIImage imageNamed:@"F001_amber_stone.png"];
    UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
    [imgView setFrame:CGRectMake(0, 0, img.size.width * factorScale,
                                 img.size.height * factorScale)];
    [self setFrame:CGRectMake(0, 0, imgView.frame.size.width,
                               imgView.frame.size.height)];
    [self addSubview:imgView];
    
    UIImage * ambar_particle =
    [UIImage imageNamed:@"F001_amber_stone_particle.png"];
    
    
    glow =
    [HVShineView fastCreationSettingParent:self];
    [glow setShineParticle:ambar_particle mask:img block:20 random:20];
    [self setClipsToBounds:NO];
    [glow setClipsToBounds:NO];
    
    glow.transform =
    CGAffineTransformScale(CGAffineTransformIdentity,1.1*factorScale,1.1*factorScale);
    glow.frame = self.frame;
    [glow setCenter:sumVectors(CGPointMake(-6, -5), glow.center)];
    

    shine = [HVShineView fastCreationSettingParent:self];
    [shine setShineWithDefaultLinearGradient:
     [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
    [shine setMaskImage:img scale:factorScale];

    [[scene superview] addSubview:self];
    //    HVDragView * drag = [HVDragView fastCreationSettingView:stone];
    //    [drag setAction:_scene onStart:nil onChange:@selector(updateLine) onEnd:nil];
    //    drag->minTouchesToDrag = 2;
    //    drag.multipleTouchEnabled = true;
    drag = [HVDrag fastCreationSettingView:self];
    [drag enableDrag:NO];
    [drag setActionToTarget:self
                    onStart:nil
                   onChange:@selector(processTouchesAndCharge)
                      onEnd:nil];
    
    [drag setActionToTarget:self
                onSingleTap:@selector(adjustBalloon)
                onDoubleTap:nil];
    
    scene->stoneGA = [drag getGestureArea];
    GA = [drag getGestureArea];
    
    bar = [[HVAnimatedAlphaView alloc] init];
    [self insertSubview:bar atIndex:1];
    //[bar setBackgroundColor:[UIColor yellowColor]];
    [bar adjustToParent];
    [bar setHeightProportionaly:0.1];
    [bar sumY:-30];
    self.electriccharge = 0;
    barIsVisible = NO;
    bar.alpha = 0;
    
    chargeProgress =
    [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [bar addSubview:chargeProgress];
    chargeProgress.frame = CGRectMake(0, 0, 125, 50);
    
    state = F001_amberStoneInitial;

}

- (double)electriccharge{
    return _electriccharge;
}

- (void)setElectriccharge:(double)electriccharge{
    _electriccharge = electriccharge;
    [chargeProgress setProgress:(electriccharge/10) animated:YES];
    [glow setAlpha:(electriccharge/10)];
}

- (void)processTouchesAndCharge{
    CGPoint stonePt = [GA lastPointOfFinger:0];
    CGSize _size = self.frame.size;
    CGPoint _center = CGPointMake(_size.width/2, _size.height/2);
    CFTimeInterval currentTimestamp = [scene->displayLink timestamp];
    CFTimeInterval timeSinceLastFriction = currentTimestamp - lastFriction;
    if (state == F001_amberStoneDrag) {
        // HVlog(@"processar carga. ", 0);
    }else if(state == F001_amberStoneFriction){
        if ((self.electriccharge > 0.1) && (!barIsVisible) &&
            (timeSinceLastFriction < 0.75)) {
            barIsVisible = YES;
            [bar show];
        }
        if ((distance(stonePt,_center) < 50) && ([GA velocity] > 150)) {
            self.electriccharge += 0.025*functionGaussian((self.electriccharge/6.5));
            lastFriction = currentTimestamp;
        }
        if ((timeSinceLastFriction > 2.75) && (self.electriccharge > 5)) {
            [self enableDrag];
        }
    }
    if((timeSinceLastFriction > 1.75) && (self.electriccharge > 0)) {
        self.electriccharge *= 0.9995;
    }
    
    if((timeSinceLastFriction > 4.75) && (barIsVisible) ) {
        HVlog(@"timeSinceLastFriction: ", timeSinceLastFriction);
        barIsVisible = NO;
        [bar hide];
    }
    
    [scene updateLine];
}

@end


@implementation HVBalloon

@synthesize vectorBalloon;
@synthesize vectorRefView;
@synthesize autoHide;
@synthesize bgColor;
@synthesize borderColor;
@synthesize borderWidth;

+ (HVBalloon *)balloonToView:(UIView *)_refView{
    HVBalloon * balloon = [[HVBalloon alloc] init];
    balloon->refView = _refView;
    [balloon configBalloon];
    return balloon;
}

- (void)configBalloon{

    viewsToFit = [NSMutableArray array];
    internalView = [[HVView alloc] init];
    [self addSubview:internalView];
    [[refView superview] insertSubview:self aboveSubview:refView];
    vectorBalloon = CGPointMake(0, -refView.frame.size.height * 1.5);
    vectorRefView = CGPointMake(0, -refView.frame.size.height / 4);
    [self setAlpha:0];
    paddingLeft = paddingRight = paddingTop = paddingBottom = 10;
    balloonBezier = [HVBezier initWithCapacity:6];
    balloonBezier.open = NO;
    self.autoHide = YES;
    bgColor = [UIColor colorWithRed:1 green:1 blue:0.75 alpha:0.8];
    borderColor = [UIColor colorWithRed:1 green:1 blue:0.75 alpha:0.8];
    borderWidth = 2;
    [self adjustToParent];
    //[self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:0.1]];
    

}

- (void)addSubview:(UIView *)view hasToFit:(BOOL)_fit{
    [internalView addSubview:view];
    if (_fit) {
        [viewsToFit addObject:view];
    }
    [internalView adjustToChildren];
}

- (void) drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [bgColor CGColor]);
    CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
    CGContextSetLineWidth(context, borderWidth);
    CGRect frm = internalView.frame;
    frm.origin.x -= paddingLeft;
    frm.size.width += paddingLeft + paddingRight;
    frm.origin.y -= paddingTop;
    frm.size.height += paddingTop + paddingBottom;
    
    CGRect frmSuper = refView.superview.frame;
    CGPoint pos = CGPointZero;
    if (frm.origin.x < paddingLeft) { pos.x = frm.origin.x - paddingLeft; }
    if (frm.origin.y < paddingTop) { pos.y = frm.origin.y - paddingTop; }
    if (frm.origin.x + frm.size.width + paddingRight > frmSuper.size.width) {
        pos.x = frm.origin.x + frm.size.width + paddingRight - frmSuper.size.width;
    }
    if (frm.origin.y + frm.size.height + paddingBottom > frmSuper.size.height) {
        pos.y = frm.origin.y + frm.size.height + paddingBottom - frmSuper.size.height;
    }

    pos = reverseVector(pos);
    
    frm.origin = sumVectors(frm.origin, pos);
    internalView.center = sumVectors(internalView.center, pos);
    
    [balloonBezier bezierPointAtIndex:0].point = frm.origin;
    [balloonBezier bezierPointAtIndex:1].point = frm.origin;
    [balloonBezier bezierPointAtIndex:2].point = frm.origin;
    [balloonBezier bezierPointAtIndex:3].point = frm.origin;
    
    [[balloonBezier bezierPointAtIndex:1] sumX:frm.size.width];
    [[balloonBezier bezierPointAtIndex:2] sumVector:
     CGPointMake(frm.size.width, frm.size.height)];
    [[balloonBezier bezierPointAtIndex:3] sumY:frm.size.height];
    
    NSLog(@"start baloon: %0.02f , %0.02f ",frm.origin.x, frm.origin.y);
    CGPoint start = sumVectors(vectorRefView, refView.center);
    if (CGRectContainsPoint(frm, start)) { start = refView.center; }
    int row = 0;
    int col = 0;
    
    if (start.x > frm.origin.x) { col = 1; }
    if (start.x > frm.origin.x + frm.size.width) { col = 2; }
    if (start.y > frm.origin.y) { row = 1; }
    if (start.y > frm.origin.y + frm.size.height) { row = 2; }
    
    int indexInsert = 3;
    if ((row == 0) && (col == 1)) { indexInsert = 0; }
    if ((row == 0) && (col == 2)) { indexInsert = 0; }
    if ((row == 1) && (col == 0)) { indexInsert = 3; }
    if ((row == 1) && (col == 2)) { indexInsert = 1; }
    if ((row == 2) && (col == 0)) { indexInsert = 2; }
    if ((row == 2) && (col == 1)) { indexInsert = 2; }
    if ((row == 2) && (col == 2)) { indexInsert = 1; }
    
    int c = [balloonBezier.points count];
    for (int i=c; i > 4; i--) {
        [balloonBezier.points removeObjectAtIndex:(i-1)];
    }

    if (! CGRectContainsPoint(frm, start)) {
        [balloonBezier splitSegment:indexInsert percentage1:0.4 percentage2:0.6];
        [balloonBezier insertPoint:[HVPoint initWithCGPoint:start]
                           atIndex:indexInsert+2];
    }

    
    [balloonBezier drawBezier:context vertexes:NO];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect frm = internalView.frame;
    BOOL result = CGRectContainsPoint(frm, point);
    if (!result && autoHide) {
        [self closeBalloon];
    }
    return result;
}

- (void)closeBalloon{
    performSelector(targetBalloonAction, onCloseBalloon);
    [self hide];
}

- (void)showBalloon{
    performSelector(targetBalloonAction, onShowBalloon);
    internalView.center = sumVectors(vectorBalloon, refView.center);
    [self setNeedsDisplay];
    [self animAlpha:1];
}

- (void)setAction:(id)_target onShowBalloon:(SEL)_show onCloseBalloon:(SEL)_close{
    targetBalloonAction = _target;
    onShowBalloon = _show;
    onCloseBalloon = _close;
}


@end

