//  HVUtils.h
//  Common generic functions

#import <AVFoundation/AVFoundation.h>

void HVlog(NSString * message, double number);
void HVmsg(NSString * message);
int randomUniformBetween(int min, int max);
int randomBetween(int min, int max);
BOOL performSelector(id target, SEL selector);

//funtion for fast start and slow finish
double lowPassFilter(double elapsed, double target, double current, float factor);
double linearPassFilter(double elapsed, double target, double current, float factor);

void saveImageInDocuments(UIImage* image, NSString* fileName);
UIImage* loadImageFromDocuments(NSString* fileName);

UIImage * imageFromFileWithScale(NSString * filename, float scale);
NSMutableArray * getPixelsAndRandomize(UIImage* image,
                                       double r, double g, double b, double a,
                                       double rR, double gR, double bR, double aR,
                                       int block, int randomFactor);
NSMutableArray * getPixels(UIImage* image,
                           double r, double g, double b, double a,
                           double rR, double gR, double bR, double aR,
                           int block);

@interface HVVelocity : NSObject{
    double initialVelocity;
    double currentVelocity;
    double initialPosition;
    double currentPosition;
    double acceleration;
    double terminalVelocity;
}

@property (nonatomic) double terminalVelocity;
@property (nonatomic) double currentVelocity;
@property (nonatomic) double currentPosition;
@property (nonatomic) double acceleration;

- (id) initWithInitialPosition:(double) s0 initialVelocity:(double) v0 acceleration:(double) a;
- (id) initWithInitialPosition:(double) s0 initialVelocity:(double) v0 acceleration:(double) a finalVelocity:(double) vFinal;
- (void) resetWithInitialPosition:(double) s0 initialVelocity:(double) v0 acceleration:(double) a finalVelocity:(double) vFinal;
- (void) updateWithTime:(double) timeSinceLastUpdate;


@end

@interface HVTreeNode : NSObject
{
    id value;
    NSMutableArray* children;
    HVTreeNode* parent;
}

@property (strong, nonatomic) id value;
@property (strong, nonatomic) NSMutableArray* children;
@property (strong, nonatomic) HVTreeNode* parent;

- (HVTreeNode*) addChildWithValue:(id) v;

@end

@interface HVTree : NSObject
{
    HVTreeNode* root;
}

@property (strong, nonatomic) HVTreeNode* root;

- (id) init;
- (NSArray*) getAllChindren;

@end;

@interface HVNumber : NSObject{
    double value;
}
+ (HVNumber *)numberWithDouble:(double)_value;
@property (nonatomic,assign) double value;

@end

@interface HVNumberArray : NSObject{
    NSMutableArray * numbers;
}
+ (HVNumberArray *)array;
- (double) doubleAtIndex:(int)index;
- (void) addNumber:(double)number;
- (void) insertNumber:(double)number atIndex:(int)index;
- (void) setValue:(double)_value toIndex:(int)index;

@end

void minimizeViewToPoint(UIView * view, CGPoint point, float duration);
void maximizeViewToPoint(UIView * view, CGPoint point, float duration);
void scaleView(UIView * view, float _scale, float duration);
void hideView(UIView * view, float duration);
//void animateViewBySetPoint(UIView* view, CGPoint initialPoint, CGPoint finalPoint, float duration);
void animateViewBySetFrameAndAlpha(UIView* view, CGRect finalFrame, float finalAlpha, float duration, BOOL removeFromSuperview);
