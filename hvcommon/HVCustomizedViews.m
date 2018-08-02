
#import "HVCustomizedViews.h"
#import "HVGeometry.h"
#import "HVUtils.h"

UIImage* tintedImageFromFileWithColor(NSString* file ,UIColor* color)
{
    // load the image
    NSString *name = file;
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color normal, and the original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
    
}

@implementation HVView

- (void)adjustToParent{
    UIView * parent = [self superview];
    if (parent == nil) {
        [self setFrame:CGRectMake(0, 0, 1024, 1024)];
        HVlog(@"View has no superview to adjust. Frame (0, 0, 1024, 1024) applied. ", 0);
        return;
    }
    CGRect parentFrame = parent.frame;
    [self setFrame:CGRectMake(0, 0,
                              parentFrame.size.width,
                              parentFrame.size.height)];
}

- (void)adjustToChildren{
    NSArray * children = [self subviews];
    float maxX = 0;
    float maxY = 0;
    int c = [children count];
    for (int i=0; i<c; i++) {
        CGRect frame = [(UIView *)[children objectAtIndex:i] frame];
        if (frame.origin.x + frame.size.width > maxX) {
            maxX = frame.origin.x + frame.size.width;
        }
        if (frame.origin.y + frame.size.height > maxY) {
            maxY = frame.origin.y + frame.size.height;
        }
    }
    CGRect rect = self.frame;
    rect.size.width = maxX;
    rect.size.height = maxY;
    [self setFrame:rect];
}

- (void)alignToCenterHorizontaly{
    CGRect superFrame = [self superview].frame;
    CGRect currentFrame = self.frame;
    currentFrame.origin.x = (superFrame.size.width - currentFrame.size.width)/2;
    [self setFrame:currentFrame];
}

- (void)alignToCenterVerticaly{
    CGRect superFrame = [self superview].frame;
    CGRect currentFrame = self.frame;
    currentFrame.origin.y = (superFrame.size.height - currentFrame.size.height)/2;
    [self setFrame:currentFrame];
}

-(void)alignToCenter{
    [self alignToCenterHorizontaly];
    [self alignToCenterVerticaly];
}

- (void)setWidthProportionaly:(double)percentage{
    float w = percentage * [self superview].frame.size.width;
    CGRect currentFrame = self.frame;
    currentFrame.size.width = w;
    [self setFrame:currentFrame];
}

- (void)setHeightProportionaly:(double)percentage{
    float h = percentage * [self superview].frame.size.height;
    CGRect currentFrame = self.frame;
    currentFrame.size.height = h;
    [self setFrame:currentFrame];
}

- (void)sumX:(float)_x{
    [self setCenter:sumVectors(self.center, CGPointMake(_x, 0))];
}

- (void)sumY:(float)_y{
    [self setCenter:sumVectors(self.center, CGPointMake(0, _y))];
}


/*
 - (void)drawRect:(CGRect)rect{
 [super drawRect:rect];
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
 CGContextSetLineWidth(context, 2.0);
 drawCircle(context, CGPointMake(self.frame.size.width/2, self.frame.size.height/2), 2);
 CGContextStrokePath(context);
 }
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

+ (UIImageView *)loadImageNamed:(NSString *)_imgName into:(UIView *)_container{
    UIImage * img = [UIImage imageNamed:_imgName];
    UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
    [_container addSubview:imgView];
    imgView.center =
    CGPointMake(_container.frame.size.width/2, _container.frame.size.height/2);
    return  imgView;
}

@end

@implementation HVDot

+ (HVDot *) fastCreationInView:(UIView *)parent{
    HVDot * view = [[HVDot alloc] init];
    CGPoint point =
    CGPointMake(parent.frame.size.width/2, parent.frame.size.height/2);
    [view config:point inView:parent];
    [view setDrag:nil onStart:nil onChange:nil onEnd:nil];
    return view;
}

+ (HVDot *) dotAt:(CGPoint)point inView:(UIView *)parent{
    HVDot * view = [[HVDot alloc] init];
    [view config:point inView:parent];
    return view;
}

- (void) config:(CGPoint)point inView:(UIView *)parent{
    sizeArea = 50;
    radiusCircle = 5;
    visible = YES;
    [self setFrame:CGRectMake(0, 0, sizeArea, sizeArea)];
    [self setBackgroundColor:[UIColor clearColor]];
    [parent addSubview:self];
    [self setCenter:point];
}

- (void) drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (!visible) { return; }
    float pos = sizeArea/2.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    drawCircle(context, CGPointMake(pos, pos), radiusCircle);
    CGContextFillPath(context);
    drawCircle(context, CGPointMake(pos, pos), radiusCircle);
    CGContextStrokePath(context);
}

- (HVDrag *) setDrag:(id)_target onStart:(SEL)started onChange:(SEL)changed onEnd:(SEL)ended{
    target = _target;
    actionStart = started;
    actionChange = changed;
    actionEnd = ended;
    if(drag == nil){ drag = [HVDrag fastCreationSettingView:self]; }
    [drag setActionToTarget:self
                    onStart:@selector(onStart)
                   onChange:@selector(onChange)
                      onEnd:@selector(onEnd)];
    return drag;
}

- (HVDrag *) setTap:(id)_target actionSingleTap:(SEL) _actionSingle actionDoubleTap:(SEL)_actionDouble{
    if(drag == nil){ drag = [HVDrag fastCreationSettingView:self]; }
    
    [drag setActionToTarget:_target
                onSingleTap:_actionSingle
                onDoubleTap:_actionDouble];
    return drag;
}

- (void) enableDrag:(BOOL)_enable{
    if(drag != nil){
        [drag enableDrag:_enable];
    }
}

- (void) onStart{
    performSelector(target, actionStart);
}

- (void) onChange{
    NSLog(@"HVDot at (%0.0f, %0.0f)", self.center.x, self.center.y);
    performSelector(target, actionChange);
}

- (void) onEnd{
    performSelector(target, actionEnd);
}

- (void)loadImageByName:(NSString *)imgName{
    UIImageView * imgView = [HVView loadImageNamed:imgName into:self];
    [self sendSubviewToBack:imgView];
}

@end

@implementation HVAnimatedAlphaView

+ (HVAnimatedAlphaView *) fastCreationSettingTarget:(UIView *)trgt{
    HVAnimatedAlphaView * view = [[HVAnimatedAlphaView alloc] init];
    [view config];
    view->target = trgt;
    return view;
}

- (void) config{
    [self setAnimLoops:-1 interval:0.5 minAlpha:0.0 maxAlpha:1.0];
    animDelay = 0;
    hideCompletely = NO;
    showCompletely = NO;
    isPlaying = NO;
    target = self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        [self config];
    }
    return self;
}

- (void)setAnimLoops:(int)times{
    blinkTimes = times;
}

- (void)setAnimLoops:(int)times interval:(double) interval minAlpha:(double)minA maxAlpha:(double)maxA{
    [self setAnimLoops:times];
    animDuration = interval;
    minAlpha = minA;
    maxAlpha = maxA;
}

- (void)setAction:(id)_target onEnd:(SEL)_actionEnd{
    targetEnd = _target;
    actionEnd = _actionEnd;
}

+ (void)blink:(UIView *)view times:(int)times interval:(double)interval minAlpha:(double)minA maxAlpha:(double)maxA{
    HVAnimatedAlphaView *auxView = [[HVAnimatedAlphaView alloc] init];
    [auxView setAnimLoops:times interval:interval minAlpha:minA maxAlpha:maxA];
    auxView->target = view;
    //[view addSubview:auxView];
    [auxView blink];
    
}

+ (void)setAlpha:(UIView *)view value:(double)value duration:(double)duration doAfter:(SEL)action  delegate:(id)delegateAnim{
    //    This kind of animation is discouraged by Apple, but it works.
    //    [UIView beginAnimations:@"animationShow" context:nil];
    //    [UIView setAnimationDuration:duration];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //    [UIView setAnimationDelegate:delegateAnim];
    //    [UIView setAnimationDidStopSelector:action];
    //    [view setAlpha:value];
    //    [UIView commitAnimations];
    //    This kind of animation is discouraged by Apple, but it works.
    
    [UIView setAnimationDidStopSelector:action];
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         view.alpha = value;
                     }
                     completion:^(BOOL finished) {
                         performSelector(delegateAnim, action);
                     }];
    
}

- (void) blink{
    if (isPlaying) {
        return; // abort any blink request if there is an animation running.
    }
    alphaBeforeBlink = target.alpha;
    countBlink = 0;
    isPlaying = YES;
    [self animationShow];
}

- (void) blinkAndHide{
    hideCompletely = YES;
    [self blink];
}

- (void)blinkAndDoSelector:(SEL)selector{
    [self setBlinkDidSelector:selector];
    [self blink];
}

- (void)setBlinkDidSelector:(SEL)selector{
    didBlink = selector;
}

- (void) animAlpha:(double)value{
    [HVAnimatedAlphaView setAlpha:target value:value duration:animDuration doAfter:didAnimAlpha delegate:self];
}

- (void)animAlpha:(double)value andDoSelector:(SEL)selector{
    [self setAnimAlphaDidSelector:selector];
    [self animAlpha:value];
}

- (void)setAnimAlphaDidSelector:(SEL)selector{
    didAnimAlpha = selector;
}

- (BOOL)blinkCounterIsAlreadyOK{
    if ((countBlink > blinkTimes)&&(blinkTimes > -1)) {
        double value = (showCompletely?1:(hideCompletely?0:alphaBeforeBlink));
        didAnimAlpha = nil;
        countBlink = 0;
        showCompletely = NO;
        hideCompletely = NO;
        isPlaying = NO;
        [self animAlpha:value andDoSelector:didBlink];
        performSelector(targetEnd, actionEnd);
        return YES;
    }
    return NO;
}

- (void) animationShow{
    // private method. It should be invoked just in the blinking process
    if (![self blinkCounterIsAlreadyOK]) {
        [self animAlpha:maxAlpha andDoSelector:@selector(animationHide)];
        countBlink++;
    }
    
}

- (void) animationHide{
    // private method. It should be invoked just in the blinking process
    if (![self blinkCounterIsAlreadyOK]) {
        [self animAlpha:minAlpha andDoSelector:@selector(animationShow)];
    }
}

- (void) show{
    if (self.alpha < 1) {
        [self animAlpha:1.0];
    }
}

- (void) hide{
    if (self.alpha > 0) {
        [self animAlpha:0.0];
    }
}

@end

@implementation HVAnimatedBackgroundView

- (void)setTimer{
    [displayLink setFrameInterval:1];
    // timer = [NSTimer scheduledTimerWithTimeInterval:(0.025) target:self selector:@selector(updateBackgroundPosition) userInfo:nil repeats:YES];
    // [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes]; // to allow timer to run while the user is interacting with the UI, so I add it in different runloop modes
}

- (void)play{
    //    if (![timer isValid]) {
    //        [self setTimer];
    //        loopsXCounter = -1;
    //        loopsYCounter = -1;
    //    }
    loopsXCounter = -1;
    loopsYCounter = -1;
    displayLink.paused = NO;
}

- (void)stop{
    //    if (timer != nil) {
    //        [timer invalidate];
    //    }
    displayLink.paused = YES;
}

- (void)setHorizontalVelocity:(double) hVelocity{
    horizontalVelocity = hVelocity / 40;
    timerCountX = 0;
    [self play];
}

- (void)setVerticalVelocity:(double) vVelocity{
    verticalVelocity = vVelocity / 40;
    timerCountY = 0;
    [self play];
}

- (void)setHorizontalLoops:(int)_loops{
    loopsX = _loops;
}
- (void)setVerticalLoops:(int)_loops{
    loopsY = _loops;
}

- (void)setPauseBetweenLoopX:(CFTimeInterval)px betweenLoopY:(CFTimeInterval)py{
    pauseIntervalX = px;
    pauseIntervalY = py;
}

- (HVAnimatedBackgroundView *)init{
    
    CGRect frame = CGRectMake(0, 0, 1024, 1024);
    if (self = [super initWithFrame:frame]) {
        backView = [[HVView alloc] initWithFrame:frame];
        loopsX = -1;
        loopsY = -1;
        loopsXCounter = -1;
        loopsYCounter = -1;
        pauseIntervalX = 0;
        pauseIntervalY = 0;
        
        displayLink =
        [CADisplayLink
         displayLinkWithTarget:self
         selector:@selector(updateBackgroundPosition)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        displayLink.paused = YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:backView];
        [self setClipsToBounds:YES];
    }
    return self;
    
}

- (void)updateBackgroundPosition{
    
    CGPoint c2 = backView.center;
    if (ABS(bgCenter.x - c2.x)+ABS(horizontalVelocity) >= background.size.width)
    {
        timerCountX = 0;
        loopsXCounter++;
        timestampX = [displayLink timestamp];
    }
    if (ABS(bgCenter.y - c2.y)+ABS(verticalVelocity) >= background.size.height)
    {
        timerCountY = 0; loopsYCounter++;
        loopsYCounter++;
        timestampY = [displayLink timestamp];
    }
    
    double pos_x = bgCenter.x + timerCountX * horizontalVelocity;
    double pos_y = bgCenter.y + timerCountY * verticalVelocity;
    [backView setCenter:CGPointMake(pos_x, pos_y)];
    
    CFTimeInterval currentTime = [displayLink timestamp];
    
    if ((loopsX < 0) || (loopsXCounter <= loopsX)) { timerCountX++; }
    else if((pauseIntervalX > 0)&&(currentTime - timestampX > pauseIntervalX))
    {loopsXCounter = 0;}
    
    if ((loopsY < 0) || (loopsYCounter <= loopsY)) { timerCountY++; }
    else if((pauseIntervalY > 0)&&(currentTime - timestampY > pauseIntervalY))
    {loopsYCounter = 0;}
    
}


- (void)fitFrameHeightToImage{
    double height = background.size.height;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y,
                              self.frame.size.width, height)];
}

- (void)fitFrameWidthToImage{
    double width = background.size.height;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y,
                              width, self.frame.size.height)];
}

- (void)setImage:(UIImage *)img{
    background = img;
    backView.backgroundColor = [UIColor colorWithPatternImage:background];
    CGRect currentFrame = self.frame;
    [self setFrame:currentFrame];
}

- (void)setImageByName:(NSString *)imageName{
    [self setImage:[UIImage imageNamed:imageName]];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [backView setFrame:CGRectMake(-2*background.size.width,
                                  -2*background.size.height,
                                  frame.size.width + 2*background.size.width,
                                  frame.size.height + 2*background.size.height)];
    bgCenter = CGPointMake(frame.size.width / 2, frame.size.height / 2);
}

@end

@implementation HVShineView

- (void)setMaskImage:(UIImage *)_mask{
    [self setMaskImage:_mask scale:1];
}

- (void)setMaskImage:(UIImage *)_mask scale:(float)_scale{
    mask = _mask;
    CALayer * _maskingLayer = [CALayer layer];
    _maskingLayer.frame =
    CGRectMake(0, 0, mask.size.width * _scale, mask.size.height * _scale);
    [_maskingLayer setContents:(id)[mask CGImage]];
    [self.layer setMask:_maskingLayer];
}

- (void)setShineImage:(UIImage *)_shine{
    [self setImage:_shine];
}

+ (HVShineView *) fastCreationSettingParent:(UIView *)parent{
    HVShineView * view = [[HVShineView alloc] init];
    [parent addSubview:view];
    [view adjustToParent];
    [view setHorizontalVelocity:200];
    
    return view;
}

- (double)getRandomFactor{
    return (randomBetween(250, 1000)/10000.0);
}

- (void)setParticlesAlpha:(double)_alpha andFrameInterval:(double)_interval{
    if (particlesView != nil) {
        [particlesView setAlpha:_alpha];
    }
    [displayLink setFrameInterval:_interval];
}

- (void)updateBackgroundPosition{
    [super updateBackgroundPosition];
    if (particlesView != nil) {
        NSArray * particles = [particlesView subviews];
        int i = 0;
        for (UIView * particle in particles) {
            double factor = [particlesFactores doubleAtIndex:i];
            double newAlpha = [particle alpha] + factor;
            if ((newAlpha < 0) || (newAlpha > 1)) {
                [particlesFactores setValue:- factor toIndex:i];
                newAlpha = [particle alpha] - factor;
                int ticket = randomBetween(0, 100);
                if (ticket < 25) {
                    [particlesFactores setValue:[self getRandomFactor] toIndex:i];
                }
            }
            [particle setAlpha:newAlpha];
            i++;
            //HVlog(@"updated ", i);
        }
    }
    
}


+ (UIImage *) diagonalShine:(CGSize)_size
                      angle:(double)_ang
                  thickness:(float)_thickness
                   gradient:(CGGradientRef)_gradient
                     center:(CGPoint)_center{
    
    UIGraphicsBeginImageContext(_size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw polygons here (if you want fill them with gradient)
    // CGContextClip(context);
    
    CGPoint mid = _center;
    CGPoint A = pointAround(mid, _thickness/2, _ang);
    CGPoint B = pointAround(mid, _thickness/2, _ang + HV_PI);
    CGContextDrawLinearGradient(context, _gradient, A, B, 0);
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *) blurImage:(UIImage *)img value:(float)_value{
    CIImage * imageToBlur = [CIImage imageWithCGImage:img.CGImage];
    CIFilter * gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: _value] forKey: @"inputRadius"];
    CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
    return [[UIImage alloc] initWithCIImage:resultImage];
}

- (void)setShineWithDefaultLinearGradient:(UIColor *)_middleColor{
    CGFloat R, G, B, A;
    [_middleColor getRed:&R green:&G blue:&B alpha:&A];
    UIColor * color = [UIColor colorWithRed:R green:G blue:B alpha:0];
    CGGradientRef gradient = gradientBiLinear(_middleColor, color);
    CGSize _size = self.frame.size;
    _size.width *= 4;
    [self setHorizontalVelocity:_size.width * 0.75];
    [self setHorizontalLoops:0];
    [self setPauseBetweenLoopX:1.5 betweenLoopY:0];
    CGPoint center = CGPointMake(3 * _size.width/4, _size.height/2);
    UIImage * shine =
    [HVShineView diagonalShine:_size
                         angle:eulerToRadians(20)
                     thickness:_size.width / 6
                      gradient:gradient
                        center:center];
    [self setShineImage:shine];
    
}

- (void)setShineGlow:(UIImage *)img blurred:(float)_value color:(UIColor *)cl{
    CGSize _size = self.frame.size;
    UIGraphicsBeginImageContext(_size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [cl CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, _size.width, _size.height));
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setShineImage:result];
    //UIImage * _mask = [HVShineView blurImage:img value:_value];
    // [self setMaskImage:_mask];
}

- (void)setShineParticle:(UIImage *)img
                    mask:(UIImage *)msk
                   block:(int)_b
                  random:(int)_r{
    
    HVView * vw = [[HVView alloc] init];
    [self addSubview:vw];
    [vw adjustToParent];
    NSMutableArray * pts =
    getPixelsAndRandomize(msk, 0, 0, 0, 1, 1, 1, 1, 0.1, _b,_r);
    HVNumberArray * factores = [HVNumberArray array];
    for (NSValue * pt in pts) {
        CGPoint _pt = [pt CGPointValue];
        HVImageMatrix * im = [HVImageMatrix fastCreationSettingImage:img];
        [vw addSubview:im];
        [im setCenter:_pt];
        [factores addNumber:[self getRandomFactor]];
    }
    particlesFactores = factores;
    particlesView = vw;
    
    [self setParticlesAlpha:1 andFrameInterval:2];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
}

-(void)stop{
    [super stop];
    [self setAlpha:0];
}

-(void)play{
    [super play];
    [self setAlpha:1];
}

- (void)setTouchReceiver:(UIView *)receiver{
    touchReceiver = receiver;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (touchReceiver == nil) { return; }
    [touchReceiver touchesMoved:touches withEvent:event];
}

@end


@implementation HVImageMatrix

+ (HVImageMatrix *)fastCreation:(NSString *)imgName{
    return [HVImageMatrix fastCreationSettingImage:[UIImage imageNamed:imgName]];
}

+ (HVImageMatrix *)fastCreationSettingImage:(UIImage *)img{
    HVImageMatrix * view = [[HVImageMatrix alloc] init];
    [view config:img];
    return view;
}

- (void) config:(UIImage *)img{
    imageView = [[UIImageView alloc] init];
    imageViewScale = 1;
    rows = 1;
    cols = 1;
    currentIndex = 0;
    [self setImage:img];
    [self addSubview:imageView];
    [self setClipsToBounds:YES];
}

- (void)setIndex:(int)index{
    currentIndex = index;
    [self adjustMatrix];
}

- (void)setIndexToBackground:(int)index{
    if (bgView == nil) {
        bgView = [[UIImageView alloc] initWithImage:image];
        [self insertSubview:bgView belowSubview:imageView];
    }
    int indexBefore = currentIndex;
    currentIndex = index;
    CGPoint bgPos = [self getImageOrigin];
    currentIndex = indexBefore;
    [bgView setFrame:CGRectMake(bgPos.x, bgPos.y, w, h)];
}

- (CGPoint)getImageOrigin{
    int y = currentIndex / cols;
    int x = currentIndex - (y * cols);
    return CGPointMake(-x*cellSize.width, -y*cellSize.height);
}

- (void)adjustMatrix{
    CGPoint imgPos = [self getImageOrigin];
    [imageView setFrame:CGRectMake(imgPos.x, imgPos.y, w, h)];
}

- (void)setMatrixCellWidth:(int)_cellWidth andHeight:(int)_cellHeight{
    cellSize.width = _cellWidth;
    cellSize.height = _cellHeight;
    rows = h / _cellHeight;
    cols = w / _cellWidth;
    [self onImageChanged];
}

- (void)setMatrixRowsCount:(int)rowsCount andColsCount:(int)colsCount{
    rows = rowsCount;
    cols = colsCount;
    [self onImageChanged];
}

- (void)setImageScale:(float)scale{
    imageViewScale = scale;
    [self onImageChanged];
}

- (void)setImage:(UIImage *)img{
    image = img;
    [imageView setImage:image];
    [self onImageChanged];
}

- (void)onImageChanged{
    w = [image size].width * imageViewScale;
    h = [image size].height * imageViewScale;
    cellSize.width = w / cols;
    cellSize.height = h / rows;
    [self adjustMatrix];
    CGPoint currentPosition = self.frame.origin;
    [self setFrame:CGRectMake(currentPosition.x, currentPosition.y,
                              cellSize.width, cellSize.height)];
    //[self setMatrixRowsCount:rows andColsCount:cols];
}

- (void)setImageByName:(NSString *)imgName{
    [self setImage:[UIImage imageNamed:imgName]];
}

- (UIImage *)imageFromIndex:(int)_index scale:(float)_scale{
    int y = _index / cols;
    int x = _index - (y * cols);
    float _w = cellSize.width / imageViewScale;
    float _h = cellSize.height / imageViewScale;
    CGRect rect = CGRectMake(x * _w, y * _h, _w, _h);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    return [UIImage imageWithCGImage:imageRef
                               scale:(1/_scale)
                         orientation:image.imageOrientation];
}

@end


@implementation HVGesturesArea

+ (HVGesturesArea *) fastCreationSettingNumberOfFingers:(int)num_fingers{
    
    HVGesturesArea * view =
    [[HVGesturesArea alloc] initWithFrame:CGRectMake(40, 400, 400, 500)];
    view->accuracy = 20;
    view->numberOfPeriods = 1;
    view->enableScaleAndRotation = NO;
    view->velocity = 0;
    view->pointsNow = [NSMutableArray array];
    
    view->panRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:view action:@selector(pan:)];
    view->panRecognizer.minimumNumberOfTouches = 1;
    
    view->tapRecognizer1 =
    [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(tap:)];
    view->tapRecognizer1.numberOfTapsRequired = 1;
    
    view->tapRecognizer2 =
    [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(tap:)];
    view->tapRecognizer2.numberOfTapsRequired = 2;
    
    view->fingers = [NSMutableArray array];
    [view setNumberOfFingers:num_fingers];
    view->singleTaps = [NSMutableArray array];
    view->doubleTaps = [NSMutableArray array];
    
    view->drags = [NSMutableArray array];
    
    [view addGestureRecognizer:view->tapRecognizer1];
    [view addGestureRecognizer:view->tapRecognizer2];
    [view enablePanGestureRecognizer:NO];
    
    return view;
}

+ (HVGesturesArea *)fastCreation{
    return [HVGesturesArea fastCreationSettingNumberOfFingers:1];
}

//+ (UIBezierPath *)bezierPathFromArrayOfPoints:(NSMutableArray *)points{
//    UIBezierPath * bezier_result = [UIBezierPath bezierPath];
//    if (points != nil) {
//        if ([points count] > 0) {
//          [bezier_result moveToPoint:pointFromObject([points objectAtIndex:0])];
//        }
//        for (int i=1; i<[points count]; i++) {
//          [bezier_result addLineToPoint:pointFromObject([points objectAtIndex:i])];
//        }
//    }
//    return bezier_result;
//}
//
//+ (NSMutableArray *)getVertexesFromArray:(NSMutableArray *)points
//                                accuracy:(double)acc{
//    return getVertexesFromArray(points, acc);
//}

- (void)setActionsToTarget:(id)target onStart:(SEL)started onChange:(SEL)changed onEnd:(SEL)ended{
    moveTarget = target;
    moveStarted = started;
    moveChanged = changed;
    moveEnded = ended;
}

- (void)setActionsToTarget:(id)target onSingleTap:(SEL)singleTap onDoubleTap:(SEL)doubleTap{
    tapTarget = target;
    tapSingle = singleTap;
    tapDouble = doubleTap;
}

- (NSMutableArray *)pointsOfFinger:(int)index onPeriod:(int)seq{
    // Pay attention: there are two arrays (FINGER an FINGERS). One "inside" each other.
    NSMutableArray * array_result;
    if (index < [fingers count]) {
        NSMutableArray * finger = [self periodsOfFinger:index];
        if ((seq < [finger count])&&(seq > -1)) {
            array_result = [finger objectAtIndex:seq];
        }else if((ABS(seq) <= [finger count])&&(seq < 0)){
            array_result = [finger objectAtIndex:([finger count] + seq)];
        }
    }
    
    return array_result;
}

- (CGPoint)pointAtIndex:(int)ptIndex onPeriod:(int)prdIndex ofFinger:(int)fgIndex{
    NSMutableArray * pts = [self pointsOfFinger:fgIndex onPeriod:prdIndex];
    if((ABS(ptIndex) <= [pts count])&&(ptIndex < 0)){
        return [[pts objectAtIndex:([pts count] + ptIndex)] CGPointValue];
    }
    return [[pts objectAtIndex:ptIndex] CGPointValue];
}

- (NSMutableArray *)periodsOfFinger:(int)index{
    // Returns an array which has others arrays inside. Each array has CGPoint's of a period.
    return [fingers objectAtIndex:index];
}

- (NSMutableArray *)singleTapPoints{
    return singleTaps;
}

- (NSMutableArray *)doubleTapPoints{
    return doubleTaps;
}

- (CGPoint) lastSingleTap{
    return [[singleTaps lastObject] CGPointValue];
}

- (CGPoint) lastDoubleTap{
    return [[doubleTaps lastObject] CGPointValue];
}

- (CGPoint)lastPointOfFinger:(int)index{
    return [[[self pointsOfFinger:index onPeriod:-1] lastObject] CGPointValue];
}

- (NSMutableArray *)lastPointsOnPeriod:(int)seq{
    NSMutableArray * result = [NSMutableArray array];
    int num = [self numberOfFingersOnPeriod:seq];
    for (int i=0; i<num; i++) {
        CGPoint lastPt = [[[self pointsOfFinger:i onPeriod:seq] lastObject] CGPointValue];
        [result addObject:[NSValue valueWithCGPoint:lastPt]];
    }
    return result;
}

- (double)scale{
    if (([pointsNow count] < 2)||(scaleRef == 0)||(!enableScaleAndRotation)) {
        return 1.0;
    }
    CGRect rectCont = rectContainerOfPoints(pointsNow);
    return sqrt(pow(rectCont.size.width,2) + pow(rectCont.size.height,2)) / scaleRef;
}

- (double)rotation{
    if (([pointsNow count] < 2)||(!enableScaleAndRotation)) {
        return 0;
    }
    CGPoint centerOfTouches = centerOfPolygon(pointsNow);
    return rotationRef + angleOfSegment(centerOfTouches,
                                        [[pointsNow objectAtIndex:0] CGPointValue]);
}

- (double)velocity{
    if (enablePanGestureRecognizer) {
        CGPoint v = [panRecognizer velocityInView:self];
        return distance(CGPointMake(0, 0), v);
    }
    return velocity;
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    if (!enablePanGestureRecognizer) return;
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self createNewPeriod];
    }
    
    [pointsNow removeAllObjects];
    for (int i=0; i<[pan numberOfTouches]; i++) {
        CGPoint currentPoint = [pan locationOfTouch:i inView:self];
        [pointsNow addObject:[NSValue valueWithCGPoint:currentPoint]];
        [[[fingers objectAtIndex:i] lastObject] addObject:[NSValue valueWithCGPoint:currentPoint]];
    }
    
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self calculateScaleAndRotationRefs];
        [self doActionsOnStart];
    } else if (pan.state == UIGestureRecognizerStateChanged){
        [self doActionsOnChange];
    }else if (pan.state == UIGestureRecognizerStateEnded){
        [self doActionsOnEnd];
    }else if (pan.state == UIGestureRecognizerStateCancelled){
        [self doActionsOnEnd];
    }
    
}

- (void)touchesRead:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [pointsNow removeAllObjects];
    NSArray * fingersNow = [touches allObjects];
    int numFingers = ([fingersNow count] >= numberOfFingers)?numberOfFingers:[fingersNow count];
    for (int i=0; i < numFingers; i++) {
        UITouch * touch = (UITouch *)[fingersNow objectAtIndex:i];
        CGPoint currentPoint = [touch locationInView:self];
        [pointsNow addObject:[NSValue valueWithCGPoint:currentPoint]];
        [[[fingers objectAtIndex:i] lastObject] addObject:[NSValue valueWithCGPoint:currentPoint]];
    }
    
    if ((!scaleAndRotationDefined)&&([pointsNow count] > 1)) {
        [self calculateScaleAndRotationRefs];
        scaleAndRotationDefined = YES;
    }
    
}

- (void)updateLastTouchTimestamp{
    timestampLastTouch = [[NSDate date] timeIntervalSince1970];
}

- (void)calculateVelocity:(CGPoint)centerOfTouchesBefore{
    CGPoint centerOfTouchesNow = centerOfPolygon(pointsNow);
    double t = [[NSDate date] timeIntervalSince1970] - timestampLastTouch;
    double d = distance(centerOfTouchesBefore, centerOfTouchesNow);
    velocity = (velocity + d/t) / 4;
    [self updateLastTouchTimestamp];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (enablePanGestureRecognizer) return;
    [self updateLastTouchTimestamp];
    scaleAndRotationDefined = NO;
    [self createNewPeriod];
    [self touchesRead:touches withEvent:event];
    [self doActionsOnStart];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if (enablePanGestureRecognizer) return;
    CGPoint centerOfTouchesBefore = centerOfPolygon(pointsNow);
    [self touchesRead:touches withEvent:event];
    [self calculateVelocity:centerOfTouchesBefore];
    [self doActionsOnChange];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (enablePanGestureRecognizer) return;
    velocity = 0;
    [self touchesRead:touches withEvent:event];
    [self doActionsOnEnd];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self touchesEnded:touches withEvent:event];
}

- (void)createNewPeriod{
    
    for (int i=0; i<numberOfFingers; i++) {
        NSMutableArray * period = [NSMutableArray array];
        [[fingers objectAtIndex:i] addObject:period];
        if ((numberOfPeriods > 0)&&
            ([[fingers objectAtIndex:i] count] > numberOfPeriods)) {
            [[fingers objectAtIndex:i] removeObjectAtIndex:0];
        }
    }
    
}

- (void)calculateScaleAndRotationRefs{
    
    if (enableScaleAndRotation) {
        CGRect rectContainer = rectContainerOfPoints(pointsNow);
        scaleRef = sqrt(pow(rectContainer.size.width,2) + pow(rectContainer.size.height,2));
        rotationRef = - angleOfSegment(centerOfPolygon(pointsNow),
                                       [[pointsNow objectAtIndex:0] CGPointValue]);
    }
    
}

- (void)doActionsOnStart{
    performSelector(moveTarget, moveStarted);
    [drags makeObjectsPerformSelector:@selector(onStart)];
}

- (void)doActionsOnChange{
    performSelector(moveTarget, moveChanged);
    [drags makeObjectsPerformSelector:@selector(onChange)];
}

- (void)doActionsOnEnd{
    performSelector(moveTarget, moveEnded);
    [drags makeObjectsPerformSelector:@selector(onEnd)];
}

- (void)tap:(UITapGestureRecognizer *)tap{
    CGPoint currentPoint = [tap locationOfTouch:0 inView:self];
    if (tap.numberOfTapsRequired == 1) {
        [singleTaps addObject:[NSValue valueWithCGPoint:currentPoint]];
        performSelector(tapTarget, tapSingle);
    }else if (tap.numberOfTapsRequired == 2){
        [doubleTaps addObject:[NSValue valueWithCGPoint:currentPoint]];
        performSelector(tapTarget, tapDouble);
    }
}

- (CGPoint)centerOfTouchesCurrently{
    return centerOfPolygon(pointsNow);
}

- (BOOL)existFinger:(int)index onPeriod:(int)seq{
    NSMutableArray * pointsOfFinger = [self pointsOfFinger:index onPeriod:seq];
    return ([pointsOfFinger count] > 0);
}

- (int)numberOfTouchesCurrently{
    return [pointsNow count];
}

- (int)numberOfFingersOnPeriod:(int)seq{
    int count_fingers = 0;
    for (int i=0; i<numberOfFingers; i++) {
        if ([self existFinger:i onPeriod:seq]) {
            count_fingers++;
        }
    }
    return count_fingers;
}


- (void)setAccuracy:(double)acc{
    accuracy = acc;
}

- (void)setNumberOfPeriods:(int)num{
    numberOfPeriods = num;
}

- (void)setNumberOfFingers:(int)num{
    numberOfFingers = num;
    panRecognizer.maximumNumberOfTouches = numberOfFingers;
    self.multipleTouchEnabled = (num > 1);
    int countNow = [fingers count];
    for (int i=countNow; i<numberOfFingers; i++) {
        NSMutableArray * finger = [NSMutableArray array];
        [fingers addObject:finger];
    }
}

- (void)enableScaleAndRotation:(BOOL)enable{
    enableScaleAndRotation = enable;
}

- (void)enablePanGestureRecognizer:(BOOL)enable{
    enablePanGestureRecognizer = enable;
    if (enablePanGestureRecognizer) {
        [self addGestureRecognizer:panRecognizer];
    }else{
        [self removeGestureRecognizer:panRecognizer];
    }
}

- (void)ignoreSingleTapBeforeDoubleTap{
    [tapRecognizer1 requireGestureRecognizerToFail:tapRecognizer2];
}

- (void)removeAllPoints{
    [singleTaps removeAllObjects];
    [doubleTaps removeAllObjects];
    for (int i=0; i < numberOfFingers; i++) {
        [[fingers objectAtIndex:i] removeAllObjects];
    }
}

- (void)addDrag:(HVDrag *)drag{
    [drags addObject:drag];
}

@end



@implementation HVDrag

+ (HVDrag *)fastCreationSettingView:(UIView *)vw
                     andGestureArea:(HVGesturesArea *)gestArea
                  thatMovesTogether:(BOOL)moveTogether{
    HVDrag * drag = [HVDrag alloc];
    drag->numberOfTouchesToDrag = 1;
    drag->enableDrag = YES;
    drag->gestureAreaMovesTogether = moveTogether;
    drag->gestureArea = gestArea;
    drag->view = vw;
    [drag->gestureArea addDrag:drag];
    
    return drag;
}

+ (HVDrag *)fastCreationSettingView:(UIView *)vw{
    
    HVGesturesArea * gestArea =
    [HVGesturesArea fastCreationSettingNumberOfFingers:1];
    HVDrag * drag = [HVDrag fastCreationSettingView:vw
                                     andGestureArea:gestArea
                                  thatMovesTogether:YES];
    
    [drag->view addSubview:gestArea];
    [gestArea adjustToParent];
    
    return drag;
    
}

- (void)setActionToTarget:(id)trgt
                  onStart:(SEL)started
                 onChange:(SEL)changed
                    onEnd:(SEL)ended{
    target = trgt;
    moveStarted  = started;
    moveChanged = changed;
    moveEnded = ended;
    //    [gestureArea setActionsToTarget:self
    //                            onStart:@selector(onStart)
    //                           onChange:@selector(onChange)
    //                              onEnd:@selector(onEnd)];
}

- (void)setActionToTarget:(id)trgt onSingleTap:(SEL)tap1 onDoubleTap:(SEL)tap2{
    target = trgt;
    singleTap = tap1;
    doubleTap = tap2;
    [gestureArea setActionsToTarget:self
                        onSingleTap:@selector(onSingleTap)
                        onDoubleTap:@selector(onDoubleTap)];
}

- (void)move{
    if (!enableDrag) return;
    int fingersNow = [gestureArea numberOfTouchesCurrently];
    if (fingersNow != numberOfTouchesToDrag) { return; }
    NSMutableArray * firstTouches = [NSMutableArray array];
    int pointsFirstFinger = 0;
    int pointsLastFinger = 0;
    for (int i=0; i<numberOfTouchesToDrag; i++) {
        NSMutableArray * pointsCurrentFinger = [gestureArea pointsOfFinger:i onPeriod:-1];
        if (i == 0) { pointsFirstFinger = [pointsCurrentFinger count]; }
        if (i == numberOfTouchesToDrag - 1) { pointsLastFinger = [pointsCurrentFinger count]; }
        [firstTouches addObject:[NSValue valueWithCGPoint:
                                 [[pointsCurrentFinger objectAtIndex:0] CGPointValue]]];
    }
    
    if (pointsFirstFinger - pointsLastFinger > 5) {
        // means that user lifted some fingers for a long time during the move.
        return;
    }
    CGPoint currentCenter = gestureAreaMovesTogether?view.center:centerBeforeMove;
    CGPoint firstTouch = centerOfPolygon(firstTouches);
    CGPoint centerOftouches = [gestureArea centerOfTouchesCurrently];
    [view setCenter:CGPointMake(currentCenter.x + centerOftouches.x - firstTouch.x,
                                currentCenter.y + centerOftouches.y - firstTouch.y)];
    
    //    if (CGRectContainsPoint([view frame], centerOftouches)) {
    //        HVlog(@"dentro", 0);
    //    }else{
    //        HVlog(@"fora", 0);
    //    }
    
    
}

- (void)setNumberOfTouchesToDrag:(int)fingers{
    numberOfTouchesToDrag = fingers;
    [gestureArea setNumberOfFingers:fingers];
}

- (void)enableDrag:(BOOL)enable{
    enableDrag = enable;
}

- (void)onSingleTap{
    performSelector(target, singleTap);
}

- (void)onDoubleTap{
    performSelector(target, doubleTap);
}

- (void)onStart{
    //    HVlog(@"comecou a arrastar ", 0);
    centerBeforeMove = [view center];
    performSelector(target, moveStarted);
}

- (void)onChange{
    [self move];
    performSelector(target, moveChanged);
}

- (void)onEnd{
    //    HVlog(@"terminou de arrastar ", 0);
    performSelector(target, moveEnded);
}

- (double)velocity{
    return [gestureArea velocity];
}

- (HVGesturesArea *)getGestureArea{
    return gestureArea;
}

- (BOOL)isEnabled{
    return enableDrag;
}

@end


@implementation HVDragView

+ (HVDragView *)fastCreationSettingView:(UIView *)parent{
    HVDragView * view = [[HVDragView alloc] init];
    [parent addSubview:view];
    [view adjustToParent];
    view->dragEnabled = YES;
    view->minTouchesToDrag = 1;
    return view;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (dragEnabled) {
        //        NSArray * fingers = [touches sortedArrayUsingDescriptors:nil];
        NSArray * fingers = [touches allObjects];
        int qt = [fingers count];
        if (qt > 0){
            UITouch * touch = (UITouch *)[fingers objectAtIndex:0];
            CGPoint point = [touch locationInView:[[self superview] superview]];
            if (qt >= minTouchesToDrag) {
                [[self superview] setCenter:sumVectors(point,vectorToSum)];
            }
            HVlog(@"count: ", qt);
        }
    }
    performSelector(targetMove, actionChange);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray * fingers = [touches sortedArrayUsingDescriptors:nil];
    if ([fingers count] > 0) {
        UITouch * touch = (UITouch *)[fingers objectAtIndex:0];
        CGPoint point = [touch locationInView:[[self superview] superview]];
        pointBeforeMoving = point;
        vectorToSum = subVectors([self superview].center, point);
    }
    performSelector(targetMove, actionStart);
}

- (void)setAction:(id)_target onSigleTap:(SEL)tap1 onDoubleTap:(SEL)tap2{
    UITapGestureRecognizer * tapRecognizer1 =
    [[UITapGestureRecognizer alloc] initWithTarget:_target action:tap1];
    tapRecognizer1.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer * tapRecognizer2 =
    [[UITapGestureRecognizer alloc] initWithTarget:_target action:tap2];
    tapRecognizer2.numberOfTapsRequired = 2;
    
    [self addGestureRecognizer:tapRecognizer1];
    [self addGestureRecognizer:tapRecognizer2];
}

- (void)setAction:(id)_target
          onStart:(SEL)start
         onChange:(SEL)change
            onEnd:(SEL)end{
    targetMove = _target;
    actionStart = start;
    actionChange = change;
    actionEnd = end;
}

- (void)enableDrag:(BOOL)enable{
    dragEnabled = enable;
}

@end


@implementation HVSlider

+ (HVSlider *)fastCreationSettingView:(UIView *)_view{
    HVSlider * slider = [[HVSlider alloc] init];
    slider->view = _view;
    [slider config];
    [slider setValue:0.5];
    return slider;
}

- (void)config{
    CGRect frm = view.frame;
    start = CGPointMake(frm.origin.x, frm.origin.y + frm.size.height / 2);
    end = CGPointMake(frm.origin.x + frm.size.width, start.y);
    maxFactor = 1;
    minFactor = 0;
    factorDefault = 0;
    spring = NO;
    thereAreTouchesNow = NO;
    animationInProgress = NO;
}

- (CGPoint)pointOfValue:(float)_value{
    CGPoint vector = multiplyVector(_value, subVectors(end, start));
    return sumVectors(start, vector);
}

- (void)setValue:(float)_value{
    float _v = _value;
    if (_value < minFactor){
        _v = minFactor;
    }
    if (_value > maxFactor){
        _v = maxFactor;
    }
    
    [view setCenter:[self pointOfValue:_v]];
    factor = _v;
    if (!thereAreTouchesNow) {
        [self adjustGestureArea];
    }
}

- (BOOL)isAnimatingNow{
    return animationInProgress;
}

- (void)setValue:(float)_value withAnimDuration:(float)time{
    animationInProgress = YES;
    [UIView animateWithDuration:time delay: 0.0 options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.center = [self pointOfValue:_value];
                     }
                     completion:^(BOOL finihshed){
                         [self setValue:_value];
                         animationInProgress = NO;
                     }];
    
}

- (float)getValue{
    return factor;
}

- (void)createGestureArea{
    gestureArea = [HVGesturesArea fastCreationSettingNumberOfFingers:1];
    [[view superview] insertSubview:gestureArea aboveSubview:view];
    [self adjustGestureArea];
    [gestureArea setActionsToTarget:self onStart:@selector(touchesBegan) onChange:@selector(touchesMoved) onEnd:@selector(touchesEnded)];
    [gestureArea setBackgroundColor:[UIColor blackColor]];
    [gestureArea setAlpha:0.1];
    
}

- (void)adjustGestureArea{
    [gestureArea setFrame:view.frame];
}

- (void)touchesBegan{
    factorBeforeMove = factor;
    thereAreTouchesNow = YES;
}

- (void)touchesMoved{
    CGPoint zero = CGPointMake(0, 0);
    NSMutableArray * points = [gestureArea pointsOfFinger:0 onPeriod:-1];
    CGPoint A = [[points objectAtIndex:0] CGPointValue];
    CGPoint B = [[points lastObject] CGPointValue];
    CGPoint vectorGesture = subVectors(B, A);
    CGPoint vectorSlider = subVectors(end, start);
    CGPoint proj = projectionOfPointToSegment(vectorGesture,
                                              zero,
                                              vectorSlider);
    int quad = quadrantOfAngle(angleOfVertex(proj, zero, vectorSlider));
    int sinal = ((quad==1)||(quad==4))?1:-1;
    float factor_aux = distance(zero, proj) / distance(zero, vectorSlider);
    float newFactor = factorBeforeMove + sinal * factor_aux;
    
    [self setValue:newFactor];
}

-(void)touchesEnded{
    thereAreTouchesNow = NO;
    if (spring) {
        [self setValue:factorDefault withAnimDuration:0.4];
    }else{
        [self adjustGestureArea];
    }
}

- (void)setLineTrackFrom:(CGPoint)_start to:(CGPoint)_end{
    start = _start;
    end = _end;
    [self setValue:factor];
}

- (void)enableSpring:(BOOL)_enable{
    spring = _enable;
}
- (void)setDefaultValue:(float)_default{
    factorDefault = _default;
}

@end


@implementation HVPixelatedImage

- (id)initWithImage:(NSString*) fileName withFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    
    if(self){
        self.autoresizesSubviews = YES;
        originalImage = [UIImage imageNamed:fileName];
        
        imageView = [[UIImageView alloc] initWithImage:originalImage];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.frame = frame;
    }
    
    return self;
}

- (NSArray*) getPixelsCenter:(float) size
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for(int i = size/2; i<self.frame.size.width;i=i+size)
    {
        for(int j = size/2; j<self.frame.size.height;j=j+size)
        {
            if([self isFilled:CGPointMake(i, j)])
            {
                HVPoint* p = [HVPoint initWithCGPoint:CGPointMake(i+self.frame.origin.x, j+self.frame.origin.y)];
                [ret addObject:p];
            }
        }
    }
    
    return ret;
}

- (NSArray*) randomPixelsCenterWithSize:(float) size count:(int) count
{
    NSMutableArray* all = [[NSMutableArray alloc] init];
    all = [NSMutableArray arrayWithArray:[self getPixelsCenter:size]];
    
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    
    if(count>[all count])
        return ret;
    
    for (int i = 0; i<count; i++) {
       int r = randomBetween(0, [all count]-1);
        [ret addObject:[all objectAtIndex:r]];
        [all removeObjectAtIndex:r];
    }
    
    return ret;
}

- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    if ((xx >= width)||(yy >= height)) {
        UIColor * empty = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [result addObject:empty];
        return result;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}

- (BOOL)isWallPixel: (UIImage *)image x:(int)x y:(int) y {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    // The image is png
    int pixelInfo = ((image.size.width  * y) + x ) * 4;
    //UInt8 red = data[pixelInfo];
    //UInt8 green = data[(pixelInfo + 1)];
    //UInt8 blue = data[pixelInfo + 2];
    UInt8 alpha = data[pixelInfo + 3];
    CFRelease(pixelData);
    
    //UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f]; // The pixel color info
    
    if (alpha)
        return YES;
    else
        return NO;
    
}

- (void) pixelateWithPixelSize:(float) size{
    
    for(int i = 0; i<self.frame.size.width;i=i+size)
    {
        for(int j = 0; j<self.frame.size.height;j=j+size)
        {
            if([self isFilled:CGPointMake(i, j)])
            {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetLineWidth(context, 1.0);
                
                CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
                
                CGRect rectangle = CGRectMake(i,j,size,size);
                
                CGContextAddRect(context, rectangle);
                
                CGContextStrokePath(context);
            }
            //            else
            //                NSLog(@"no");
        }
    }
}

- (BOOL) foundInRect:(CGRect) rect
{
    int x = rect.origin.x;
    int y = rect.origin.y;
    int width = rect.size.width;
    int height = rect.size.height;
    
    for(int i = x; i<width;i++)
    {
        for(int j = y; j<height;j++)
        {
            if([self isFilled:CGPointMake(i, j)])
                return YES;
        }
    }
    
    return NO;
}

//- (void)drawRect:(CGRect)rect
//{
//    [self pixelateWithPixelSize:10];
//}

- (BOOL) isFilled:(CGPoint) point;
{
    float scaleFactorX = originalImage.size.width/imageView.frame.size.width;
    float scaleFactorY = originalImage.size.height/imageView.frame.size.height;
    
    CGPoint newPoint = CGPointMake(scaleFactorX*point.x,scaleFactorY*point.y);
    
    return [self pixelMaskBitAt:newPoint];
}

-(BOOL) pixelMaskBitAt:(CGPoint)point
{
    // round the point coordinates to the nearest integer
    int x = (int)(point.x + 0.5f);
    int y = (int)(point.y + 0.5f);
    
    if (x < 0 || y < 0 || x >= originalImage.size.width+10 || y >= originalImage.size.height+10)
    {
        return NO;
    }
    
    //    return [self isWallPixel:originalImage x:x y:y];
    
    NSArray* cores = [self getRGBAsFromImage:originalImage atX:x andY:y count:1];
    UIColor * corAtual = ((UIColor *)[cores objectAtIndex:0]);
    const CGFloat * rgba = CGColorGetComponents([corAtual CGColor]);
    if(rgba[3]>0)
        return YES;
    else
        return NO;
    
}

@end


/*
 @implementation HVDragArea
 
 - (NSMutableArray *)viewsThatIntersect:(UIView *)view{
 CGRect frameView = [view frame];
 NSMutableArray * result = [NSMutableArray array];
 for (int i=0; i<[[self subviews] count]; i++) {
 UIView * currentView = [[self subviews] objectAtIndex:i];
 if (view == currentView) continue;
 CGRect frameCurrentView = [currentView frame];
 CGRect intersection = CGRectIntersection(frameCurrentView, frameView);
 if (!CGRectIsNull(intersection)) {
 [result addObject:currentView];
 }
 }
 return result;
 }
 
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
 //[super touchesMoved:touches withEvent:event];
 NSArray * fingers = [touches sortedArrayUsingDescriptors:nil];
 for (int i=0; i < [fingers count]; i++) {
 UITouch * touch = (UITouch *)[fingers objectAtIndex:i];
 CGPoint point = [touch locationInView:self];
 HVlog(@"dragArea X: ", point.x);
 }
 [self setNeedsDisplay];
 
 }
 
 - (void)drawRect:(CGRect)rect{
 [super drawRect:rect];
 CGContextRef context = UIGraphicsGetCurrentContext();
 for (int i=0; i<([[self subviews] count] - 1); i++) {
 UIView * viewI = [[self subviews] objectAtIndex:i];
 CGRect frameViewI = [viewI frame];
 for (int j=(i+1); j<[[self subviews] count]; j++) {
 UIView * viewJ = [[self subviews] objectAtIndex:j];
 CGRect frameViewJ = [viewJ frame];
 CGRect intersection = CGRectIntersection(frameViewI, frameViewJ);
 if (!CGRectIsNull(intersection)) {
 CGContextAddRect(context, intersection);
 }
 }
 }
 
 CGContextStrokePath(context);
 
 }
 
 
 
 @end
 
 */