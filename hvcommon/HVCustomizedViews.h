//  HVCustomizedViews.h
//  UIViews with special features

#import "HVUtils.h"
#import <Foundation/Foundation.h>

UIImage* tintedImageFromFileWithColor(NSString* file ,UIColor* color);

@interface HVView : UIView {
    
}
- (void)adjustToParent; // set frame to fill whole parent's area.
- (void)adjustToChildren;
- (void)alignToCenterVerticaly; // set center to parent's vertical middle point.
- (void)alignToCenterHorizontaly; // set center to parent's horizontal middle point.
- (void)alignToCenter;
- (void)setWidthProportionaly:(double)percentage;
- (void)setHeightProportionaly:(double)percentage;
- (void)sumX:(float)_x;
- (void)sumY:(float)_y;
+ (UIImageView *)loadImageNamed:(NSString *)_imgName into:(UIView *)_container;

@end

@class HVDrag; // Previous declaration for use inside HVGestureArea

@interface HVDot : UIView {
    // class for use during development, in order to test elements' position.
    // it also can be used as a regular UIVIew if you want.
    float sizeArea;
    float radiusCircle;
    id target;
    SEL actionStart;
    SEL actionChange;
    SEL actionEnd;
@public
    HVDrag * drag;
    BOOL visible;
}

+ (HVDot *) fastCreationInView:(UIView *)parent;
+ (HVDot *) dotAt:(CGPoint)point inView:(UIView *)parent;
- (HVDrag *) setTap:(id)_target actionSingleTap:(SEL) _actionSingle actionDoubleTap:(SEL)_actionDouble;
- (HVDrag *) setDrag:(id)_target onStart:(SEL)started onChange:(SEL)changed onEnd:(SEL)ended;
- (void) enableDrag:(BOOL)_enable;
- (void)loadImageByName:(NSString *)imgName;

@end


@interface HVAnimatedAlphaView : HVView {
    //This class implements alpha transition animated effects
    id targetEnd;
    SEL actionEnd;
    int countBlink; // counter to blink executions
    SEL didBlink; // stores the selector to be executed when blink animation ends
    SEL didAnimAlpha; // stores the selector to be executed when generic animation ends
    UIView * target; // is self object by default. It is other object in static (+) methods
    id animDelegate; // the target for selector to be executed when animation ends
    BOOL hideCompletely; // if true, set alpha to 0.0 in the last blinking, whatever "minAlpha"
    BOOL showCompletely; // if true, set alpha to 1.0 in the last blinking, whatever "maxAlpha"
    BOOL isPlaying; // if true, means a blink process is running
@public
    int blinkTimes; // number of times to execute blink effect
    double animDelay;
    double animDuration; // animation interval. In blink it's duration of a single loop
    double minAlpha; // minimal alpha value during a blink animation
    double maxAlpha; // maximal alpha value during a blink animation
    double alphaBeforeBlink; // alpha value to set in the end of blinking (if showCompletely is NO and hideCompletely is also NO)
}
+ (HVAnimatedAlphaView *) fastCreationSettingTarget:(UIView *)trgt;
+ (void)blink:(UIView *)view times:(int)times interval:(double)interval minAlpha:(double)minA maxAlpha:(double)maxA;
+ (void)setAlpha:(UIView *)view value:(double)value duration:(double)duration doAfter:(SEL)action  delegate:(id)delegateAnim;
- (void)setAnimLoops:(int)times;
- (void)setAnimLoops:(int)times interval:(double) interval minAlpha:(double)minA maxAlpha:(double)maxA;
- (void)blink;
- (void)blinkAndHide;
- (void)blinkAndDoSelector:(SEL)selector;
- (void)animAlpha:(double)value;
- (void)animAlpha:(double)value andDoSelector:(SEL)selector;
- (void)show;
- (void)hide;
- (void)config;
- (void)setAction:(id)_target onEnd:(SEL)_actionEnd;

@end

@interface HVImageMatrix : HVAnimatedAlphaView{
    // class to show images (like icons) in a same image file.
    UIImage * image; // main image that has all images to display
    UIImageView * imageView; // container that moves to display a specific image
    UIImageView * bgView; // container behind the main image
    float imageViewScale; // resize factor to background image
    int rows; // number of rows the main image has to be divided in.
    int cols; // number os cols the main image has to be divided in.
    CGSize cellSize; // size of a cell.
    int currentIndex; // store current matrix element index to show.
    float w,h; // width and height of image (scaled or not).
}

- (void)config:(UIImage *)img;
- (void)setImage:(UIImage *)img;
- (void)setImageScale:(float)scale;
- (void)setImageByName:(NSString *)imgName;
- (void)setIndex:(int)index;
- (void)setIndexToBackground:(int)index;
- (void)setMatrixRowsCount:(int)rowsCount andColsCount:(int)colsCount;
- (void)setMatrixCellWidth:(int)_cellWidth andHeight:(int)_cellHeight;
- (void)adjustMatrix;
- (CGPoint)getImageOrigin;
+ (HVImageMatrix *)fastCreation:(NSString *)imgName;
+ (HVImageMatrix *)fastCreationSettingImage:(UIImage *)img;
- (UIImage *)imageFromIndex:(int)_index scale:(float)_scale;

@end


@interface HVAnimatedBackgroundView : HVView {
    // class to simulate a texture animation.
    UIImage * background; // background image texture
    HVView * backView; // container that display the image and move during animation
    int w,h,timerCountX,timerCountY; // width, height and animation counters
    double horizontalVelocity, verticalVelocity; // animation parameters
    //NSTimer * timer; // timer to update image position
    CGPoint bgCenter; // current position of background.
    CADisplayLink * displayLink;
    CFTimeInterval timestampX, timestampY;
    CFTimeInterval pauseIntervalX, pauseIntervalY;
    int loopsX,loopsY,loopsXCounter,loopsYCounter;
}

- (void)setHorizontalVelocity:(double)hVelocity;
- (void)setVerticalVelocity:(double)vVelocity;
- (void)setHorizontalLoops:(int)_loops;
- (void)setVerticalLoops:(int)_loops;
- (void)updateBackgroundPosition;
- (void)setPauseBetweenLoopX:(CFTimeInterval)px betweenLoopY:(CFTimeInterval)py;
- (HVAnimatedBackgroundView *)init;
- (void)fitFrameHeightToImage;
- (void)fitFrameWidthToImage;
- (void)setImageByName:(NSString *)imageName;
- (void)setImage:(UIImage *)img;
- (void)play;
- (void)stop;


@end

@interface HVShineView : HVAnimatedBackgroundView{
    UIImage * mask;
    UIView * touchReceiver;
    HVView * particlesView;
    HVNumberArray * particlesFactores;
}

+ (HVShineView *) fastCreationSettingParent:(UIView *)parent;
+ (UIImage *) diagonalShine:(CGSize)_size
                      angle:(double)_ang
                  thickness:(float)_thickness
                   gradient:(CGGradientRef)_gradient
                     center:(CGPoint)_center;
+ (UIImage *) blurImage:(UIImage *)img value:(float)_value;
- (void)setMaskImage:(UIImage *)_mask;
- (void)setMaskImage:(UIImage *)_mask scale:(float)_scale;
- (void)setShineImage:(UIImage *)_shine;
- (void)setShineWithDefaultLinearGradient:(UIColor *)_middleColor;
- (void)setShineGlow:(UIImage *)img blurred:(float)_value color:(UIColor *)cl;
- (void)setShineParticle:(UIImage *)img
                    mask:(UIImage *)msk
                   block:(int)_b
                  random:(int)_r;
- (void)setTouchReceiver:(UIView *)receiver;
- (void)stop;
- (void)play;

@end


@interface HVGesturesArea : HVView{
    
    NSMutableArray * fingers;// array of arrays. One for each finger. Inside each finger array there are others array (one for each period).
    NSMutableArray * pointsNow; // array with current touches (CGPoint's)
    NSMutableArray * singleTaps; // array with single taps points
    NSMutableArray * doubleTaps; // array with double taps points
    NSMutableArray * drags; // array with HVDrag's associated to this HVGestureArea
    UIPanGestureRecognizer * panRecognizer; // recognizer for touches (if enable)
    UITapGestureRecognizer * tapRecognizer1; // recognizer for single taps
    UITapGestureRecognizer * tapRecognizer2; // recognizer for double taps
    int numberOfFingers; // number of fingers to monitorate
    int numberOfPeriods; // (0) save all periods. (N) save the last N periods.
    // A period is an user interaction (when all fingers lifts, current period ends)
    double accuracy; // accuracy for proximity point measurement
    double scaleRef; // scale reference set when touches begin
    double rotationRef; // rotation reference set when touches begin
    double velocity; //
    BOOL enableScaleAndRotation; // if YES do scale, rotation calculus
    BOOL enablePanGestureRecognizer; // if YES it uses UIPanGestureRecognizer to catch points so you can do scale and rotation properly. if NO it uses touchesBegan/Moved/Ended methods, so you can detect points right after they begin. Set YES only if you need.
    BOOL scaleAndRotationDefined; // means scale/rotation references were defined.
    id moveTarget; // target to perfom actions on touches events
    SEL moveStarted; // target will perform this action when touches begin
    SEL moveEnded; // target will perform this action when touches end
    SEL moveChanged; // target will perform this action when touches change
    id tapTarget; // target to perfom action on tap events
    SEL tapSingle; // target will perform this action on single tap
    SEL tapDouble; // target will perform this action on double tap
    CFTimeInterval timestampLastTouch;
}

- (void)pan:(UIPanGestureRecognizer *)pan;
- (void)tap:(UITapGestureRecognizer *)tap;
- (void)setAccuracy:(double)acc;
- (void)setNumberOfPeriods:(int)num;
- (void)setNumberOfFingers:(int)num;
- (void)enableScaleAndRotation:(BOOL)enable;
- (void)enablePanGestureRecognizer:(BOOL)enable;
- (void)ignoreSingleTapBeforeDoubleTap;
- (void)removeAllPoints;
- (NSMutableArray *)pointsOfFinger:(int)index onPeriod:(int)seq;
- (NSMutableArray *)lastPointsOnPeriod:(int)seq;
- (NSMutableArray *)periodsOfFinger:(int)index;
- (NSMutableArray *)singleTapPoints;
- (NSMutableArray *)doubleTapPoints;
- (int)numberOfFingersOnPeriod:(int)seq;
- (int)numberOfTouchesCurrently;
- (double)scale;
- (double)rotation;
- (double)velocity;
- (BOOL)existFinger:(int)index onPeriod:(int)seq;
- (void)setActionsToTarget:(id)target onStart:(SEL)started onChange:(SEL)changed onEnd:(SEL)ended;
- (void)setActionsToTarget:(id)target onSingleTap:(SEL)singleTap onDoubleTap:(SEL)doubleTap;
- (CGPoint)lastSingleTap;
- (CGPoint)lastDoubleTap;
- (CGPoint)lastPointOfFinger:(int)index;
- (CGPoint)pointAtIndex:(int)ptIndex onPeriod:(int)prdIndex ofFinger:(int)fgIndex;
- (CGPoint)centerOfTouchesCurrently;
- (void)addDrag:(HVDrag *)drag;
+ (HVGesturesArea *)fastCreationSettingNumberOfFingers:(int)num_fingers;
+ (HVGesturesArea *)fastCreation;
//+ (NSMutableArray *)getVertexesFromArray:(NSMutableArray *)points                      accuracy:(double)acc;
//+ (UIBezierPath *)bezierPathFromArrayOfPoints:(NSMutableArray *)points;

@end


@interface HVDrag : NSObject{
    HVGesturesArea * gestureArea; // HVGestureArea where touches will occur
    UIView * view; // UIView that is gonna to be dragged
    int numberOfTouchesToDrag; // exactly number of fingers to do movements
    BOOL enableDrag; // if YES execute movements
    BOOL gestureAreaMovesTogether; // means that gestureArea moves together main view
    CGPoint centerBeforeMove; // center reference on the first touch
    id target; // target to perfom actions on movement events
    SEL moveStarted; // target will do this action when touches start.
    SEL moveChanged; // target will do this action when touches change.
    SEL moveEnded; // target will do this action when touches end.
    SEL singleTap;
    SEL doubleTap;
}

+ (HVDrag *)fastCreationSettingView:(UIView *)vw;
+ (HVDrag *)fastCreationSettingView:(UIView *)vw
                     andGestureArea:(HVGesturesArea *)gestArea
                  thatMovesTogether:(BOOL)moveTogether;
- (void)setNumberOfTouchesToDrag:(int)fingers;
- (void)setActionToTarget:(id)trgt
                  onStart:(SEL)started
                 onChange:(SEL)changed
                    onEnd:(SEL)ended;
- (void)setActionToTarget:(id)trgt onSingleTap:(SEL)tap1 onDoubleTap:(SEL)tap2;
- (void)enableDrag:(BOOL)enable;
- (void)move;
- (double)velocity;
- (HVGesturesArea *)getGestureArea;
- (BOOL)isEnabled;

@end

@interface HVDragView : HVView{
    CGPoint pointBeforeMoving;
    CGPoint vectorToSum;
    UITapGestureRecognizer * tapRecognizer;
    id targetMove;
    SEL actionStart;
    SEL actionChange;
    SEL actionEnd;
    BOOL dragEnabled;
@public
    int minTouchesToDrag;
}

+ (HVDragView *)fastCreationSettingView:(UIView *)parent;
- (void)enableDrag:(BOOL)enable;
- (void)setAction:(id)_target onSigleTap:(SEL)tap1 onDoubleTap:(SEL)tap2;
- (void)setAction:(id)_target
          onStart:(SEL)start
         onChange:(SEL)change
            onEnd:(SEL)end;

@end

@interface HVSlider : NSObject{
    UIView * view;
    CGPoint start;
    CGPoint end;
    float factorBeforeMove;
    float factorDefault;
    float factor;
    float minFactor;
    float maxFactor;
    HVGesturesArea * gestureArea;
    BOOL spring;
    BOOL thereAreTouchesNow;
    BOOL animationInProgress;
}
+ (HVSlider *)fastCreationSettingView:(UIView *)_view;
- (void)config;
- (void)setValue:(float)_value;
- (float)getValue;
- (void)createGestureArea;
- (void)setLineTrackFrom:(CGPoint)_start to:(CGPoint)_end;
- (void)setValue:(float)_value withAnimDuration:(float)time;
- (void)enableSpring:(BOOL)_enable;
- (void)setDefaultValue:(float)_default;
- (BOOL)isAnimatingNow;

@end

@interface HVPixelatedImage : UIView
{
    UIImage* originalImage;
    UIImageView* imageView;
    NSArray* pixelArray;
}

- (id)initWithImage:(NSString*) fileName withFrame:(CGRect) frame;
- (NSArray*) getPixelsCenter:(float) size;
- (NSArray*) randomPixelsCenterWithSize:(float) size count:(int) count;

@end
