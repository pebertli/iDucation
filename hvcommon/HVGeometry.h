//  HVGeometry.h
//  Generic geometry functions

@class HVPolygon;

static const double HV_PI = 3.1415926535897932384626433832795;
double distance(CGPoint A, CGPoint B);
double distanceToSegment(CGPoint A, CGPoint B, CGPoint P);
int quadrantOfAngle(double angle);
double angleOfSegment(CGPoint A, CGPoint B);
double angleOfVector(CGPoint V);
double angleOfVertex(CGPoint A, CGPoint vertex, CGPoint B);
double angleOfBisectrix(CGPoint A, CGPoint vertex, CGPoint B);
double angleOfBisectrixOutsidePath(CGPoint A, CGPoint vertex, CGPoint B);
double angleOfBisectrixInsideTriangule(CGPoint A, CGPoint vertex, CGPoint B);
double radiansToEuler(double angle);
double eulerToRadians(double angle);
double lengthOfVector(CGPoint V);
CGPoint pointAround(CGPoint center, double radius, double angle);
CGPoint projectionOfPointToSegment(CGPoint P, CGPoint A, CGPoint B);
CGPoint midpoint(CGPoint A, CGPoint B);
CGPoint centerOfPolygon(NSMutableArray * points);
CGRect rectContainerOfPoints(NSMutableArray * points);
CGPoint reverseVector(CGPoint point);
CGPoint sumVectors(CGPoint A, CGPoint B);
CGPoint subVectors(CGPoint A, CGPoint B);
CGPoint normalizeVector(CGPoint A);
CGPoint multiplyVector(double factor, CGPoint V);
CGPoint extendVector(float factor, CGPoint p0,  CGPoint p1);
CGPoint centerToOrigin(CGPoint center, CGRect rect);
CGPoint originToCenter(CGPoint origin, CGRect rect);
CGPoint intersectionOfSegments(CGPoint A, CGPoint B, CGPoint C, CGPoint D);
//CGPoint pointFromObject(id object);
//NSMutableArray * getVertexesFromArray(NSMutableArray * points, double acc);
BOOL isSegmentsItersect(CGPoint a, CGPoint b, CGPoint c, CGPoint d);
BOOL segmentTouchesRect(float factor , CGPoint p0,  CGPoint p1, CGRect rect);
CGRect rectWithCenterAndSize(float centerX, float centerY, float width, float height);

//fill functions
BOOL randomizeViews(NSMutableArray* views, CGRect rect, float scale);
BOOL arrangeViews(NSMutableArray* views, CGRect rect, int rows, int columns, float space, float scale);

// Math functions
double functionOdd(double x);
double functionGaussian(double x);
double functionSigmoid(double x);
double functionOddGaussian(double x);
double functionGaussianMultipliedBySigmoid(double x);

// Drawing functions
void drawCircle(CGContextRef context, CGPoint center, double radius);
void drawLine(CGContextRef context, CGPoint A, CGPoint B);
void drawTrianguleIsosceles(CGContextRef context,
                            CGPoint V,
                            float base,
                            float height,
                            double angle);
void drawArrow(CGContextRef context, CGPoint A, CGPoint B, float endSize);
CGPoint pointInQuadraticBezierAtValue(CGPoint A, CGPoint B, CGPoint Control, double percentage);
CGPoint pointControlOfQuadraticBezier(CGPoint A, CGPoint B, CGPoint I, double percentage);
CGColorRef CGColorMix(CGColorRef color1, CGColorRef color2, double percentage);
CGGradientRef gradientLinear(UIColor * startColor, UIColor * endColor);
CGGradientRef gradientBiLinear(UIColor * midColor, UIColor * endColor);
UIBezierPath * quadraticBezierPassingBy(CGPoint A, CGPoint B, CGPoint I, double percentage);
CGPoint pointInCubicBezierAtValue(CGPoint P1, CGPoint P2,
                                  CGPoint P1C, CGPoint P2C, double percentage);
CGPoint pointInCubicBezierUsingLengthPercentage(CGPoint P1, CGPoint P2,
                                  CGPoint P1C, CGPoint P2C, double percentage);
double lengthOfCubicBezierSegment(CGPoint P1, CGPoint P2,
                                  CGPoint P1C, CGPoint P2C);
UIBezierPath * curveUsingQuadBeziers(HVPolygon * polygon,
                                     double thick1,
                                     double thick2);


@interface HVRect : NSObject
{
    float x;
    float y;
    float width;
    float height;
}

- (id) initWithCGRect:(CGRect) rect;
-(CGRect) toCGRect;
- (void) fromCGRect: (CGRect) rect;
- (float) getRadius;
- (BOOL) originIsEqualToCGPoint:(CGPoint) point;
- (CGPoint) getCenter;

@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) float width;
@property (nonatomic) float height;

@end


@interface HVPoint : NSObject {
    CGPoint point;
}
@property (nonatomic,assign) CGPoint point;
+ (HVPoint *) initWithCGPoint:(CGPoint) pt;
- (void) setX:(double)_x;
- (void) setY:(double)_y;
- (void) sumX:(double)value;
- (void) sumY:(double)value;
- (void) sumVector:(CGPoint)pt;
- (void) moveTowards:(CGPoint)pt distance:(double)dist;
- (void) moveTowards:(CGPoint)pt percentage:(double)percent;
- (double)modulus;
- (double)angle;
@end

@interface HV3DPoint : NSObject {
    float x,y,z;
}
@property float x;
@property float y;
@property float z;
- (id) initWithX:(float) px Y:(float) py Z:(float) pz;
@end

@interface HVPolygon : NSObject {
    NSMutableArray * points;
}
@property (readwrite, retain) NSMutableArray * points;
@property BOOL open;
+ (HVPolygon *) initWithArray:(NSMutableArray *) pts;
+ (HVPolygon *) initWithBorderPoints:(NSMutableArray *) pts;
+ (HVPolygon *) initWithBorderPoints2:(NSMutableArray *) pts;
+ (HVPolygon *) initWithCapacity:(int) count;
- (HVPoint *) centerOfPolygon;
- (HVPoint *) pointAtIndex:(int)index;
- (HVPoint *) nextPointFromIndex:(int)index;
- (HVPoint *) previousPointFromIndex:(int)index;
- (void) addPointsFromArray:(NSMutableArray *) pts;
- (void) simplify:(double)accuracy;
- (void) sumVector:(CGPoint)_sum;
- (void) drawPolygon:(CGContextRef)context;
- (BOOL) isVertex:(CGPoint)pt;
- (BOOL) isVertex:(CGPoint)pt maxDistance:(double)dist;
- (UIBezierPath *) bezier;
- (void) splitSegment:(int)index percentage:(double)percent;
- (void) splitSegment:(int)index
          percentage1:(double)percent1
          percentage2:(double)percent2;
- (void) splitAllSegmentsUsingPercentage:(double)percent;
- (void) wrapPoints:(NSMutableArray *)pointsToWrap;
- (void) insertPointInNearestSegment:(CGPoint)pt;
- (void) insertPoint:(HVPoint *)pt atIndex:(int)index;
- (int) indexOfNearestSegmentToPoint:(CGPoint)pt;
- (int) indexOfNearestPointToPoint:(CGPoint)pt;
- (CGPoint) pointAmongArray:(NSMutableArray *)ptsArray nearestToPointAtIndex:(int)index;
@end

enum HVBezierPointType {
    HVBezierPointTypeEnd,
    HVBezierPointTypeSmooth,
    HVBezierPointTypeDisjunct,
    HVBezierPointTypeVertex
};

@interface HVBezierPoint : HVPoint{
    enum HVBezierPointType type;
    @public
    HVPoint * control1;
    HVPoint * control2;
}

+ (HVBezierPoint *)initWithCGPoint:(CGPoint)pt withType:(enum HVBezierPointType)_type;
- (void) setType:(enum HVBezierPointType) _type;
- (void) draw:(CGContextRef) context;


@end

struct HVBezierSegment {
    CGPoint P1;
    CGPoint P1C;
    CGPoint P2;
    CGPoint P2C;
};
typedef struct HVBezierSegment HVBezierSegment;

@interface HVBezier : HVPolygon{
    double length;
}

+ (HVBezier *)initWithArray:(NSMutableArray *)pts;
+ (HVBezier *)initWithCapacity:(int)count;
- (void)drawBezier:(CGContextRef)context;
- (void) drawBezier:(CGContextRef)context vertexes:(BOOL)_vertexes;
- (UIBezierPath *)getBezierPath;
- (HVBezierSegment)getSegmentAtIndex:(int)index;
- (HVBezierPoint *)bezierPointAtIndex:(int)index;
- (CGPoint)pointAtPercentage:(double)percentage;
- (CGPoint)pointAtPercentageNormalized:(double)percentage;
- (double)calculateLength;
- (double)length;

@end

@interface HVBezierArray : NSObject{
    NSMutableArray * beziers;
}
+ (HVBezierArray *)array;
- (HVBezier *) bezierAtIndex:(int)index;
- (void) addBezier:(HVBezier *)bezier;
- (void) insertBezier:(HVBezier *)bezier atIndex:(int)index;

@end

HVBezierSegment convertQuadBezierToCubicBezier(CGPoint A, CGPoint B, CGPoint C);
