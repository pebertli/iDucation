#import "HVGeometry.h"
#import "HVUtils.h"

static const double HV_GAP_BETWEEN_RECTS = 0;

double functionOdd(double x){
    return (x > 0)?1.0:-1.0;
}

double functionOddGaussian(double x){
    return functionGaussian(x) * functionOdd(x);
}

double functionGaussianMultipliedBySigmoid(double x){
    return functionSigmoid(x) * functionGaussian(x);
}

double functionSigmoid(double x){
    return (1/(1+exp(-x))-0.5);
}

double functionGaussian(double x){
    return (exp(-(pow(x, 2))));
}

double distance(CGPoint A, CGPoint B){
    double dx = (A.x - B.x);
    double dy = (A.y - B.y);
    return sqrt(dx * dx + dy * dy);
}

CGPoint midpoint(CGPoint A, CGPoint B){
    return CGPointMake((A.x + B.x)/2, (A.y + B.y)/2);
}

double distanceToSegment(CGPoint A, CGPoint B, CGPoint P){
    double PB = distance(P, B);
    double angle = angleOfVertex(A, B, P);
    return ABS(PB * sin(angle));
}

double radiansToEuler(double angle){
    return 180 * angle / HV_PI;
}

double eulerToRadians(double angle){
    return HV_PI * angle / 180;
}

CGPoint pointAround(CGPoint center, double radius, double angle){
    
    double dx = cos(angle) * radius;
    double dy = sin(angle) * radius;
    return CGPointMake(center.x + dx, center.y + dy);
    
}

double angleOfVertex(CGPoint A, CGPoint vertex, CGPoint B){
    double toA = angleOfSegment(vertex, A);
    double toB = angleOfSegment(vertex, B);
    double angleAB = ABS(toA - toB);
    int q = quadrantOfAngle(angleAB);
    if (q > 2) {
        angleAB = (2 * HV_PI) - angleAB;
    }
    return angleAB;
}

double angleOfSegment(CGPoint A, CGPoint B){
    double dx = B.x - A.x;
    double dy = B.y - A.y;
    double angle;
    if ((dx == 0.0)&&(dy == 0.0)) {
        return 0.0;
    }else if (dx == 0.0) {
        return (dy > 0)?(0.5 * HV_PI):(1.5 * HV_PI);
    }else if(dy == 0.0){
        return (dx > 0)?(0.0):(HV_PI);
    }else{
        angle = atan(ABS(dy)/ABS(dx));
    }
    
    if ((dx < 0) && (dy > 0)) {
        return HV_PI - angle;
    }else if((dx < 0) && (dy < 0)){
        return HV_PI + angle;
    }else if((dx > 0) && (dy < 0)){
        return 2 * HV_PI - angle;
    }
    
    return angle;
}

double angleOfBisectrix(CGPoint A, CGPoint vertex, CGPoint B){
    double angleA = angleOfSegment(vertex,A);
    double angleC = angleOfSegment(vertex,B);
    double rotation = (angleA + angleC)/2;
    return rotation;
}

double angleOfBisectrixOutsidePath(CGPoint A, CGPoint vertex, CGPoint B){
    
    double AV = angleOfSegment(A, vertex);
    double AB = angleOfSegment(A, B);
    int q = quadrantOfAngle(AB);
    double b = angleOfBisectrixInsideTriangule(A, vertex, B);
    if ((((q == 1) || (q == 2)) && (!((AV < AB) || (AV > (AB + HV_PI)))))  ||
        (((q == 3) || (q == 4)) && (!((AV > (AB - HV_PI)) && (AV < AB)))) )
    {
        b = b - HV_PI;
    }
    return b;
}

double angleOfBisectrixInsideTriangule(CGPoint A, CGPoint vertex, CGPoint B){
    double angleA = angleOfSegment(vertex,A);
    double angleB = angleOfSegment(vertex,B);
    CGPoint xA = pointAround(vertex, 100, angleA);
    CGPoint xB = pointAround(vertex, 100, angleB);
    CGPoint mid = midpoint(xA, xB);
    return angleOfSegment(vertex, mid);
}



int quadrantOfAngle(double angle){
    double s = sin(angle);
    double c = cos(angle);
    if ((s >= 0) && (c >= 0)) { return 1;}
    else if ((s >= 0) && (c < 0)) { return 2; }
    else if ((s < 0) && (c <= 0)) { return 3;}
    else if ((s < 0) && (c > 0)) { return 4; }
    return 0;
}

BOOL isSegmentsItersect(CGPoint a, CGPoint b, CGPoint c, CGPoint d)
{
    
    //double yi = ((y3-y4)*(x1*y2-y1*x2)-(y1-y2)*(x3*y4-y3*x4))/d;
    //    if(x3==x4) { if ( yi < Math.min(y1,y2) || yi > Math.max(y1,y2) )return null; }
    //    Point2D.Double p = new Point2D.Double(xi,yi);
    //    if (xi < Math.min(x1,x2) || xi > Math.max(x1,x2)) return null;
    //    if (xi < Math.min(x3,x4) || xi > Math.max(x3,x4)) return null; return p; }
    
    double s = (a.x-b.x)*(c.y-d.y) - (a.y-b.y)*(c.x-d.x);
    if (s == 0)
        return NO;
    
    double xi = ((c.x-d.x)*(a.x*b.y-a.y*b.x)-(a.x-b.x)*(c.x*d.y-c.y*d.x))/s;
    double yi = ((c.y-d.y)*(a.x*b.y-a.y*b.x)-(a.y-b.y)*(c.x*d.y-c.y*d.x))/s;
    
    if(c.x==d.x)
    {
        if(yi< MIN(a.y, b.y) || yi> MAX(a.y, b.y))
            return NO;
        if(yi< MIN(c.y, d.y) || yi> MAX(c.y, d.y))
            return NO;
    }
    else
    {
        
        if (xi < MIN(a.x,b.x) || xi > MAX(a.x,b.x))
            return NO;
        if (xi < MIN(c.x,d.x) || xi > MAX(c.x,d.x))
            return NO;
    }
    return YES;
}

CGPoint extendVector(float factor, CGPoint p0,  CGPoint p1)
{
    return  CGPointMake(p0.x+(factor*(p1.x-p0.x)),p0.y+(factor*(p1.y-p0.y)));
}

CGRect rectWithCenterAndSize(float centerX, float centerY, float width, float height)
{
    return CGRectMake(centerX-(width/2), centerY-(height/2), width, height);
}

//works only for a non rotationed rect
BOOL segmentTouchesRect(float factor , CGPoint p0,  CGPoint p1, CGRect rect)
{
    if(factor!=1.0)
        p1 = extendVector(factor, p0, p1);

    //test with upper arest
    if(isSegmentsItersect(p0, p1, rect.origin, CGPointMake(rect.origin.x+rect.size.width,rect.origin.y )))
        return YES;
    //test with right arest
    if(isSegmentsItersect(p0, p1, CGPointMake(rect.origin.x+rect.size.width,rect.origin.y ), CGPointMake(rect.origin.x+rect.size.width,rect.origin.y+rect.size.height)))
        return YES;
    //test with bottom arest
    if(isSegmentsItersect(p0, p1, CGPointMake(rect.origin.x,rect.origin.y+rect.size.height ), CGPointMake(rect.origin.x+rect.size.width,rect.origin.y+rect.size.height)))
        return YES;
    //test with left arest
    if(isSegmentsItersect(p0, p1, rect.origin, CGPointMake(rect.origin.x,rect.origin.y+rect.size.height )))
        return YES;

    
    return NO;
}

CGPoint intersectionOfSegments(CGPoint A, CGPoint B, CGPoint C, CGPoint D){
    double AB = angleOfSegment(A, B);
    double CD = angleOfSegment(C, D);
    double DC = angleOfSegment(D, C);
    if ((AB == CD) || (AB == DC)) { // they are parallel
        return midpoint(B, C);
    }
    float x1 = A.x; float x2 = B.x; float x3 = C.x; float x4 = D.x;
    float y1 = A.y; float y2 = B.y; float y3 = C.y; float y4 = D.y;
    
    float x = ((x1*y2 - y1*x2)*(x3-x4)-(x1-x2)*(x3*y4 - y3*x4))/
              ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
    float y = ((x1*y2 - y1*x2)*(y3-y4)-(y1-y2)*(x3*y4 - y3*x4))/
              ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
    return CGPointMake(x, y);
}

CGPoint centerOfPolygon(NSMutableArray * points){
    double accumulator_x = 0.0;
    double accumulator_y = 0.0;
    int numberOfPoints = [points count];
    if (numberOfPoints == 1) {
        return [[points lastObject] CGPointValue];
    }else{
        for (int i=0; i<numberOfPoints; i++) {
            CGPoint currentPoint = [[points objectAtIndex:i] CGPointValue];
            accumulator_x += currentPoint.x;
            accumulator_y += currentPoint.y;
        }
    }
    return CGPointMake(accumulator_x/numberOfPoints, accumulator_y/numberOfPoints);
}

CGRect rectContainerOfPoints(NSMutableArray * points){
    double lowest_x, lowest_y, highest_x, highest_y;
    int numberOfPoints = [points count];
    if (numberOfPoints < 2) {
        return CGRectNull;
    }else{
        CGPoint currentPoint = [[points objectAtIndex:0] CGPointValue];
        lowest_x = currentPoint.x;
        lowest_y = currentPoint.y;
        highest_x = currentPoint.x;
        highest_y = currentPoint.y;
        for (int i=1; i<numberOfPoints; i++) {
            currentPoint = [[points objectAtIndex:i] CGPointValue];
            lowest_x = (currentPoint.x < lowest_x)?currentPoint.x:lowest_x;
            lowest_y = (currentPoint.y < lowest_y)?currentPoint.y:lowest_y;
            highest_x = (currentPoint.x > highest_x)?currentPoint.x:highest_x;
            highest_y = (currentPoint.y > highest_y)?currentPoint.y:highest_y;
        }
    }
    return CGRectMake(lowest_x, lowest_y,
                      highest_x - lowest_x,
                      highest_y - lowest_y);

}

CGPoint projectionOfPointToSegment(CGPoint P, CGPoint A, CGPoint B){
    double ang = angleOfVertex(A, B, P);
    double toProjection = cos(ang) * distance(P, B);
    return pointAround(B, toProjection, angleOfSegment(B, A));
}

CGPoint reverseVector(CGPoint point){
    return CGPointMake(-point.x, -point.y);
}

CGPoint sumVectors(CGPoint A, CGPoint B){
    return CGPointMake(A.x + B.x, A.y + B.y);
}

CGPoint subVectors(CGPoint A, CGPoint B){
    return sumVectors(A, reverseVector(B));
}

CGPoint normalizeVector(CGPoint A)
{
    float l = lengthOfVector(A);
   return CGPointMake(A.x/l, A.y/l);
}

double lengthOfVector(CGPoint V)
{
    return sqrt(V.x*V.x + V.y*V.y);
}

CGPoint multiplyVector(double factor, CGPoint V){
    return CGPointMake(V.x * factor, V.y * factor);
}

void drawCircle(CGContextRef context, CGPoint center, double radius){
    CGContextAddEllipseInRect(context, CGRectMake(center.x - radius,
                                                  center.y - radius,
                                                  2*radius,
                                                  2*radius));
}

void drawLine(CGContextRef context, CGPoint A, CGPoint B){
    CGContextMoveToPoint(context, A.x, A.y);
    CGContextAddLineToPoint(context, B.x, B.y);
}

void drawTrianguleIsosceles(CGContextRef context,
                            CGPoint V,
                            float base,
                            float height,
                            double angle){
    CGContextMoveToPoint(context, V.x, V.y);
    CGPoint basePoint = pointAround(V, height, angle);
    CGPoint base1 = pointAround(basePoint, base/2, angle - 0.5 * HV_PI);
    CGPoint base2 = pointAround(basePoint, base/2, angle + 0.5 * HV_PI);
    CGContextAddLineToPoint(context, base1.x, base1.y);
    CGContextAddLineToPoint(context, base2.x, base2.y);
    CGContextAddLineToPoint(context, V.x, V.y);
}

void drawArrow(CGContextRef context, CGPoint A, CGPoint B, float endSize){
    drawLine(context, A, B);
    drawTrianguleIsosceles(context, B, 0.5 * endSize, endSize, angleOfSegment(B,A));
}

CGPoint pointInQuadraticBezierAtValue(CGPoint A, CGPoint B, CGPoint Control, double percentage){
    CGPoint firstSegment = sumVectors(A, multiplyVector(percentage, subVectors(Control, A)));
    CGPoint secondSegment = sumVectors(B, multiplyVector(1-percentage, subVectors(Control, B)));
    CGPoint intersect = sumVectors(firstSegment,
                        multiplyVector(percentage,
                        subVectors(secondSegment, firstSegment)));
    return  intersect;
}

CGPoint pointControlOfQuadraticBezier(CGPoint A, CGPoint B, CGPoint I, double percentage){
    // A is start point
    // B is end point
    // I is internal point on the curve
    // percentage (from 0 to 1) represents the position in the curve
    // to determine the control point, we need two distances.
    // the first distance we need is from A to control projection
    // the second is from control to AB segment
    // to obtain this values we will use some relations between these distances
    CGPoint projectionI = projectionOfPointToSegment(I, A, B);
    double angleBAI = angleOfVertex(B, A, projectionI);
    int sinal = ((angleBAI > 0.5 * HV_PI) && (angleBAI < 1.5 * HV_PI))?-1:1;
    // for an specific 't', there are a relation is expressed by a line:
    // f(x) = alpha.x + c
    // alpha = -2.tˆ2 + 2.t = -2.(tˆ2 - t)
    // c = tˆ2
    double alpha = - 2 * (pow(percentage, 2) - percentage);
    if (alpha == 0) { alpha = 0.001; }
    double func = sinal * distance(A, projectionI) / distance(A, B);
    // f(x) = a.x + b  =>  x = (f(x) - b) / a
    // a = alpha
    // b = c = tˆ2
    double factor = (func - pow(percentage, 2)) / alpha;
    double distanceProjectionToControl = distance(I, projectionI) / alpha;
    CGPoint controlProjection = sumVectors(A, multiplyVector(factor, subVectors(B, A)));
    CGPoint controlCalculed = pointAround(controlProjection,
                                          distanceProjectionToControl,
                                          angleOfSegment(projectionI, I));
    return controlCalculed;
    
}

UIBezierPath * quadraticBezierPassingBy(CGPoint A, CGPoint B, CGPoint I, double percentage){
    CGPoint control = pointControlOfQuadraticBezier(A, B, I, percentage);
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:A];
    [bezier addQuadCurveToPoint:B controlPoint:control];
    return bezier;
}

CGPoint pointInCubicBezierAtValue(CGPoint P1, CGPoint P2,
                                  CGPoint P1C, CGPoint P2C, double percentage){
    
    CGFloat t = percentage;
    CGFloat t2 = pow(percentage, 2);
    CGFloat t3 = pow(percentage, 3);
    double x = P1.x + (-P1.x * 3 + t * (3 * P1.x - P1.x * t)) * t
    + (3 * P1C.x + t * (-6 * P1C.x + P1C.x * 3 * t)) * t
    + (P2C.x * 3 - P2C.x * 3 * t) * t2
    + P2.x * t3;
    double y = P1.y + (-P1.y * 3 + t * (3 * P1.y - P1.y * t)) * t
    + (3 * P1C.y + t * (-6 * P1C.y + P1C.y * 3 * t)) * t
    + (P2C.y * 3 - P2C.y * 3 * t) * t2
    + P2.y * t3;
    return CGPointMake(x, y);
}

HVBezierSegment convertQuadBezierToCubicBezier(CGPoint A, CGPoint B, CGPoint C){
    HVBezierSegment bezier;
    bezier.P1 = A;
    bezier.P2 = B;

    CGPoint mid = midpoint(A, B);
    CGPoint third = multiplyVector(1.0/3.0, subVectors(mid, C));
    third = sumVectors(third, C);
    double dist = distance(A, B) / 6.0;
    CGPoint third2 = pointAround(third, dist, angleOfSegment(A, B));
    CGPoint third1 = pointAround(third, dist, angleOfSegment(A, B) + HV_PI);
    bezier.P1C = third1;
    bezier.P2C = third2;
    
    return bezier;
}

CGPoint pointInCubicBezierUsingLengthPercentage(CGPoint P1, CGPoint P2,
                                                CGPoint P1C, CGPoint P2C, double percentage){
    NSMutableArray * parts = [NSMutableArray array];
    double sum = 0;
    double distanceOfSegment = 0;
    int partsToDivide = 10;
    CGPoint previous = P1;
    for (int i=1; i<partsToDivide; i++) {
        CGPoint p =
        pointInCubicBezierAtValue(P1, P2, P1C, P2C, i/((double) partsToDivide));
        distanceOfSegment = distance(p, previous);
        sum += distanceOfSegment;
        [parts addObject:[NSNumber numberWithDouble:sum]];
        previous = p;
    }
    distanceOfSegment = distance(P2, previous);
    sum += distanceOfSegment;
    [parts addObject:[NSNumber numberWithDouble:sum]];
    double previousLength = 0;
    double lengthDesired = percentage * sum;
    double newPercentage = 1;
    for (int i=0; i<partsToDivide; i++) {
        double currentLength = [(NSNumber *)[parts objectAtIndex:i] doubleValue];
        if (lengthDesired < currentLength) {
            // the segment we were looking for is this
            distanceOfSegment = currentLength - previousLength;
            double dif = lengthDesired - previousLength;
            double percentageInsideSegment = dif / distanceOfSegment;
            newPercentage = (1.0/partsToDivide) * percentageInsideSegment;
            newPercentage += i*(1.0/partsToDivide);
            break;
        }
        previousLength = currentLength;
    }
    
    return pointInCubicBezierAtValue(P1, P2, P1C, P2C, newPercentage);

}

UIBezierPath * curveUsingQuadBeziers(HVPolygon * polygon,
                                     double thick1,
                                     double thick2){
    int count = [polygon.points count];
    int midIndex = count / 2;
    if (count % 2 == 0 ) {
        CGPoint midP = midpoint([polygon pointAtIndex:(midIndex-1)].point,
                                [polygon pointAtIndex:(midIndex)].point);
        CGPoint intersection = midP;
        if (count >= 4) {
            intersection =
            intersectionOfSegments([polygon pointAtIndex:(midIndex-2)].point,
                                   [polygon pointAtIndex:(midIndex-1)].point,
                                   [polygon pointAtIndex:(midIndex)].point,
                                   [polygon pointAtIndex:(midIndex+1)].point);
        }
        CGPoint new = sumVectors(midP, multiplyVector(0.25, subVectors(intersection, midP)));
        [polygon insertPoint:[HVPoint initWithCGPoint:new] atIndex:midIndex];
        count++;
    }
    double increment = (thick2 - thick1) / (count - 1);
    
    CGPoint firstA1;
    CGPoint firstA2;
    double firstAngle;
    NSMutableArray * pointsMovingBack = [NSMutableArray array];
    int steps = midIndex;
    UIBezierPath * path = [UIBezierPath bezierPath];
    for (int i=0; i<steps; i++) {
        BOOL lastStep = (i == steps - 1);
        BOOL firstStep = (i == 0);
        CGPoint A = [polygon pointAtIndex:i*2].point;
        CGPoint B = [polygon pointAtIndex:i*2+1].point;
        CGPoint C = [polygon pointAtIndex:i*2+2].point;
        CGPoint B_ = pointControlOfQuadraticBezier(A, C, B, 0.5);
        double angleA = angleOfSegment(A, B_) + 0.5 * HV_PI;
        double angleB = angleOfBisectrixOutsidePath(A, B, C);
        double angleC = angleOfSegment(B_, C) + 0.5 * HV_PI;
        if (!firstStep) {
            CGPoint A_ = [polygon pointAtIndex:i*2-1].point;
            angleA = angleOfBisectrixOutsidePath(A_, A, B);
        }
        if (!lastStep) {
            CGPoint D = [polygon pointAtIndex:i*2+3].point;
            angleC = angleOfBisectrixOutsidePath(B, C, D);
        }
        
        CGPoint A1 = pointAround(A, (thick1+(i*2)*increment)/2, angleA);
        CGPoint A2 = pointAround(A, (thick1+(i*2)*increment)/2, angleA-HV_PI);
        CGPoint B1 = pointAround(B_,(thick1+(i*2+1)*increment)/2, angleB);
        CGPoint B2 = pointAround(B_,(thick1+(i*2+1)*increment)/2, angleB-HV_PI);
        CGPoint C1 = pointAround(C, (thick1+(i*2+2)*increment)/2, angleC);
        CGPoint C2 = pointAround(C, (thick1+(i*2+2)*increment)/2, angleC-HV_PI);
        if (firstStep) {
            [path moveToPoint:A1];
            firstA1 = A1;
            firstA2 = A2;
            firstAngle = angleOfSegment(B_, A);
        }
        
        [path addQuadCurveToPoint:C1 controlPoint:B1];
        
        if (lastStep) {
            CGPoint midC1C2 = midpoint(C1, C2);
            double angleEnd = angleOfSegment(B_, C);
            midC1C2 = pointAround(midC1C2, distance(C1, C2)*0.75, angleEnd);
            [path addQuadCurveToPoint:C2 controlPoint:midC1C2];
        }
        
        [pointsMovingBack addObject:[NSValue valueWithCGPoint:A2]];
        [pointsMovingBack addObject:[NSValue valueWithCGPoint:B2]];
        
    }
    
    for (int i=steps; i>0; i--) {
        CGPoint B = [[pointsMovingBack objectAtIndex:2*i-1] CGPointValue];
        CGPoint C = [[pointsMovingBack objectAtIndex:2*i-2] CGPointValue];
        [path addQuadCurveToPoint:C controlPoint:B];
    }
    
    CGPoint midA1A2 = midpoint(firstA1, firstA2);
    midA1A2 = pointAround(midA1A2, distance(firstA1, firstA2)*0.75, firstAngle);
    [path addQuadCurveToPoint:firstA1 controlPoint:midA1A2];
    
    return path;
}


double lengthOfCubicBezierSegment(CGPoint P1, CGPoint P2,
                                  CGPoint P1C, CGPoint P2C){
    double length = 0;
    CGPoint a = P1;
    for (int i=1; i<=100; i++) {
        CGPoint b = pointInCubicBezierAtValue(P1, P2, P1C, P2C,i/100.0);
        length += distance(a, b); a = b;
    }
    return length;
}

CGColorRef CGColorMix(CGColorRef color1, CGColorRef color2, double percentage){
    const CGFloat * components1 = CGColorGetComponents(color1);
    const CGFloat * components2 = CGColorGetComponents(color2);
    double r = (1-percentage)*components1[0]+percentage*components2[0];
    double g = (1-percentage)*components1[1]+percentage*components2[1];
    double b = (1-percentage)*components1[2]+percentage*components2[2];
    double a = (1-percentage)*components1[3]+percentage*components2[3];
    CGFloat components3[] = {r, g, b, a};
    return CGColorCreate(CGColorSpaceCreateDeviceRGB(), components3);
    
}

CGGradientRef gradientLinear(UIColor * startColor, UIColor * endColor){
    CGGradientRef result;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0.0f, 1.0f};
    CGFloat startR, startG, startB, startA;
    CGFloat endR, endG, endB, endA;
    
    [endColor getRed:&endR green:&endG blue:&endB alpha:&endA];
    [startColor getRed:&startR green:&startG blue:&startB alpha:&startA];
    
    CGFloat componnents[8] =
    { startR, startG, startB, startA, endR, endG, endB, endA };
    
    result =
    CGGradientCreateWithColorComponents(colorSpace, componnents, locations, 2);
    //CGColorSpaceRelease(colorSpace);
    return result;
}

CGGradientRef gradientBiLinear(UIColor * midColor, UIColor * endColor){
    CGGradientRef result;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[3] = {0.0f, 0.5f ,1.0f};
    CGFloat midR, midG, midB, midA;
    CGFloat endR, endG, endB, endA;
    
    [endColor getRed:&endR green:&endG blue:&endB alpha:&endA];
    [midColor getRed:&midR green:&midG blue:&midB alpha:&midA];
    
    CGFloat componnents[12] = {
        endR, endG, endB, endA,
        midR, midG, midB, midA,
        endR, endG, endB, endA
    };
    
    result =
    CGGradientCreateWithColorComponents(colorSpace, componnents, locations, 3);
    //CGColorSpaceRelease(colorSpace);
    return result;
}

CGPoint centerToOrigin(CGPoint center, CGRect rect){
    return CGPointMake(center.x-(rect.size.width/2), center.y-(rect.size.height/2));
}

CGPoint originToCenter(CGPoint origin, CGRect rect){
    return CGPointMake(origin.x+(rect.size.width/2), origin.y+(rect.size.height/2));
}




BOOL randomizeViews(NSMutableArray* views, CGRect rect, float scale){
    
    float totalWidth = 0.0;
    float totalHeight = 0.0;
    double s = 1.0;
    for (UIView* v in views) {
        totalWidth+=v.frame.size.width+HV_GAP_BETWEEN_RECTS;
        totalHeight+=v.frame.size.height+HV_GAP_BETWEEN_RECTS;
    }
    double total = MAX(totalHeight, totalWidth);
    double area1 = MAX(rect.size.height,rect.size.width);
    
    
    
    //if the rects will not fit in rect, then try to scale then
    if(total>area1)
    {
        s = (area1/total);
        if(s<scale)
            return NO;
    }
    //apply the new scale
    if(s<1.0)
    {
        for (UIView* v in views) {
            CGRect r = v.frame;
            r.size.width *= s;
            r.size.height *= s;
            r.origin.x = v.frame.origin.x;
            r.origin.y = v.frame.origin.y;
            v.frame = r;
        }
        
    }
    
    //ramdom x and y axis over the width and height
    for (int countRect = 0; countRect<[views count]; countRect++){
        
        float x = 0.0;
        float y = 0.0;
        BOOL found = NO;
        do {
            x = randomBetween(rect.origin.x, rect.size.width);
            y = randomBetween(rect.origin.y, rect.size.height);
            
            UIView* v1 = [views objectAtIndex:countRect];
            CGRect r1 = v1.frame;
            r1.origin.x = x;
            r1.origin.y = y;
            v1.frame = r1;
            
            //the total rect contains atom?
            if(CGRectContainsRect(rect, r1))
                found = YES;
            
            
            //iterate over the rects already arranged
            for (int countPlacedRect = 0; countPlacedRect<countRect; countPlacedRect++)
            {
                CGRect r2 = ((UIView*)[views objectAtIndex:countPlacedRect]).frame;
                //are x and y touching the area of others placed rects?
                if(CGRectIntersectsRect(r1, r2))
                {
                    found = NO;
                    break;
                    
                }
            }
        } while (!found);
        
        
    }
    
    
    return YES;
}

 BOOL arrangeViews(NSMutableArray* views, CGRect rect, int rows, int columns, float space, float scale)
{
    //can`t arrange at that matrix
    if([views count] != columns*rows)
        return NO;
    
    float totalWidth = 0.0;
    float totalHeight = 0.0;
    double s = 1.0;
    
    //calculate the tallest column
    for (int j = 0; j<columns; j++) {
        float h = 0;
        for (int i = 0; i<rows; i++) {
            int index =(j)+(i*columns);
            UIView* v = [views objectAtIndex:index];
            h+=v.frame.size.height;
        }
        totalHeight=MAX(h, totalHeight);
    }
    
    //calculate the largest row
    for (int i = 0; i<rows; i++) {
        float w = 0;
        for (int j = 0; j<columns; j++) {
            int index = (i*columns)+j;
            UIView* v = [views objectAtIndex:index];
            w+=v.frame.size.width;
        }
        totalWidth=MAX(w, totalWidth);
    }
    
    
    //what`s the minor dimension
    double sWidth = 1.0;
    double sHeight = 1.0;
    //discount space
    sWidth = (rect.size.width-((columns+1)*space))/totalWidth;
    sHeight = (rect.size.height-((rows+1)*space))/totalHeight;
    s = MIN(sWidth, sHeight);
    
    //if the rects will not fit in rect, then try to scale then
    if(s<scale)
        return NO;
    
    //apply the new scale
    // if(s<1.0)
    {
        for (UIView* v in views) {
            CGRect f = v.frame;
            f.size.width *= s;
            f.size.height *= s;
            v.frame = f;
        }
        
    }
    
    //arrange. Begin with the space discount
    float accHeight = space+rect.origin.y;
    for (int i = 0; i<rows; i++) {
        
        float maxHeight = 0.0;
        float accWidth = space+rect.origin.x;
        
        for (int j = 0; j<columns; j++) {
            int index = (i*columns)+(j);
            UIView* v = [views objectAtIndex:index];
            CGRect f = v.frame;
            f.origin.x = accWidth;
            f.origin.y = accHeight;
            maxHeight = MAX(maxHeight, f.size.height);
            accWidth+=space+f.size.width;
            v.frame = f;
        }
        accHeight +=space+maxHeight;
    }
    
    
    return YES;
}



@implementation HVRect

@synthesize x;
@synthesize y;
@synthesize width;
@synthesize height;

- (id) initWithCGRect:(CGRect) rect{
    self = [super init];
    if (self) {
        [self fromCGRect:rect];
    }
    
    return self;
}

-(CGRect) toCGRect{
    return CGRectMake(x, y, width, height);
}

- (void) fromCGRect: (CGRect) rect {
    x = rect.origin.x;
    y = rect.origin.y;
    width = rect.size.width;
    height = rect.size.height;
}

- (float) getRadius
{
    return sqrt(pow(width, 2)+pow(height, 2))/2.0;
}

- (BOOL) originIsEqualToCGPoint:(CGPoint) point
{
    if(point.x == x && point.y == y)
        return YES;
    else
        return NO;
}

- (CGPoint) getCenter
{
    return CGPointMake(x+(width/2), y+(height/2));
}

@end

@implementation HV3DPoint

@synthesize x;
@synthesize y;
@synthesize z;

- (id)initWithX:(float)px Y:(float)py Z:(float)pz
{
    self = [super init];
    if(self)
    {
        x = px;
        y = py;
        z = pz;
    }
    
    return self;
}

@end


@implementation HVPoint
@synthesize point;

+ (HVPoint *) initWithCGPoint:(CGPoint) pt{
    HVPoint * newPoint = [[HVPoint alloc] init];
    newPoint.point = pt;
    return newPoint;
}
- (void) setX:(double)_x { point.x = _x; }
- (void) setY:(double)_y { point.y = _y; }
- (void) sumX:(double)value { point.x += value; }
- (void) sumY:(double)value  { point.y += value; }
- (void) sumVector:(CGPoint) pt { point = sumVectors(point, pt); }
- (void) moveTowards:(CGPoint)pt distance:(double)dist{
    point = pointAround(point, dist, angleOfSegment(point, pt));
}
- (void) moveTowards:(CGPoint)pt percentage:(double)percent{
    CGPoint vector = multiplyVector(percent, subVectors(pt, point));
    point = sumVectors(point, vector);
}
@end

@implementation HVBezierPoint

+ (HVBezierPoint *) initWithCGPoint:(CGPoint)pt withType:(enum HVBezierPointType)_type{
    HVBezierPoint * point = [[HVBezierPoint alloc] init];
    point.point = pt;
    point->control1 = [HVPoint initWithCGPoint:pt];
    point->control2 = [HVPoint initWithCGPoint:pt];
    [point setType:_type];
    return point;
}

- (void) setType:(enum HVBezierPointType) _type{
    type = _type;
    if (type == HVBezierPointTypeVertex) {
        [control1 setPoint:self.point];
        [control2 setPoint:self.point];
    }else if(type == HVBezierPointTypeSmooth){
        [control1 setPoint:sumVectors(self.point, CGPointMake(-80, 0))];
        [control2 setPoint:sumVectors(self.point, CGPointMake(80, 0))];
    }
}

- (void) draw:(CGContextRef) context{
    drawCircle(context, self.point, 5);
    CGContextFillPath(context);
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
    CGFloat dash[] = {5.0, 5.0};
    CGContextSetLineDash(context, 2, dash, 2);
    drawLine(context, self.point, self->control1.point);
    drawLine(context, self.point, self->control2.point);
    CGContextStrokePath(context);
}

@end

@implementation HVPolygon
@synthesize points;

+ (HVPolygon *) initWithArray:(NSMutableArray *) pts{
    HVPolygon * polygon = [[HVPolygon alloc] init];
    [polygon config:pts];
    return polygon;
}

+ (HVPolygon *) initWithCapacity:(int) count{
    NSMutableArray * empty = [NSMutableArray array];
    HVPolygon * polygon = [HVPolygon initWithArray:empty];
    for (int i=0; i<count; i++) {
        [polygon addPoint:[HVPoint initWithCGPoint:CGPointZero]];
    }
    return polygon;
}

- (void) config:(NSMutableArray *) pts{
    self.points = [NSMutableArray array];
    for (int i=0; i<[pts count]; i++) {
        id ptObject = [pts objectAtIndex:i];
        if ([ptObject isKindOfClass:[HVPoint class]]) {
            [self addPoint:ptObject];
        }else{
            // Suppose it is a NSValue with a CGPoint
            HVPoint * newPt = [HVPoint initWithCGPoint:[ptObject CGPointValue]];
            [self addPoint:newPt];
        }
    }
}

- (void) insertPoint:(HVPoint *)pt atIndex:(int)index{
    int i = index;
    if (index < 0 ) { i = [points count] + index; }
    [points insertObject:pt atIndex:i];
}

- (void) addPoint:(HVPoint *)pt{
    [self insertPoint:pt atIndex:[points count]];
}

- (HVPoint *) centerOfPolygon{
    HVPoint * c = [HVPoint initWithCGPoint:CGPointMake(0, 0)];
    int numberOfPoints = [points count];
    if (numberOfPoints == 0){
        return c;
    }else if (numberOfPoints == 1) {
        return (HVPoint *)[points lastObject];
    }else{
        for (int i=0; i<numberOfPoints; i++) {
            HVPoint * currentPoint = (HVPoint *)[points objectAtIndex:i];
            [c sumVector:currentPoint.point];
        }
    }
    return [HVPoint initWithCGPoint:
            multiplyVector(1.0/(double)numberOfPoints, c.point)];
}

- (HVPoint *) pointAtIndex:(int)index{
    int _index = index < 0 ? ([points count] + index):index;
    return (HVPoint *)[points objectAtIndex:_index];
}

- (HVPoint *) nextPointFromIndex:(int)index{
    if (index == [points count]-1) {
        return [self pointAtIndex:0];
    }
    return [self pointAtIndex:(index + 1)];
}

- (HVPoint *) previousPointFromIndex:(int)index{
    if (index == 0) {
        return [self pointAtIndex:([points count]-1)];
    }
    return [self pointAtIndex:(index - 1)];
}


- (void) drawPolygon:(CGContextRef)context{
    int numberOfPoints = [points count];
    if (numberOfPoints < 2){
        return;
    }else{
        HVPoint * currentPoint = [self pointAtIndex:0];
        CGContextMoveToPoint(context, currentPoint.point.x, currentPoint.point.y);
        for (int i=1; i<numberOfPoints; i++) {
            currentPoint = [self pointAtIndex:i];
            CGContextAddLineToPoint(context,
                                    currentPoint.point.x,
                                    currentPoint.point.y);
        }
        CGContextClosePath(context);
    }
}

- (BOOL) isVertex:(CGPoint)pt{
    for (int i=0; i<[points count]; i++) {
        HVPoint * currentPoint = [self pointAtIndex:i];
        if ((currentPoint.point.x == pt.x)&&(currentPoint.point.y == pt.y)){
            return YES;
        }
    }
    return NO;
}

- (BOOL) isVertex:(CGPoint)pt maxDistance:(double)dist{
    for (int i=0; i<[points count]; i++) {
        HVPoint * currentPoint = [self pointAtIndex:i];
        if (distance(pt, currentPoint.point) <= dist){
            return YES;
        }
    }
    return NO;
}

- (UIBezierPath *) bezier{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    if ([points count] == 0) {
        return bezier;
    }
    [bezier moveToPoint:[self pointAtIndex:0].point];
    for (int i=1; i<[points count]; i++) {
        [bezier addLineToPoint:[self pointAtIndex:i].point];
    }
    [bezier closePath];
    return bezier;
}

- (void) splitSegment:(int)index percentage:(double)percent{
    if (index >= [points count]) {
        return;
    }
    HVPoint * A = [self pointAtIndex:index];
    HVPoint * B;
    if (index == [points count] - 1) {
        B = [self pointAtIndex:0];
    }else{
        B = [self pointAtIndex:(index + 1)];
    }
    
    CGPoint vector = multiplyVector(percent, subVectors(B.point, A.point));
    HVPoint * newPoint = [HVPoint initWithCGPoint:sumVectors(A.point, vector)];
    [self insertPoint:newPoint atIndex:(index + 1)];
}

- (void) splitAllSegmentsUsingPercentage:(double)percent{
    int vertexes = [points count];
    for (int i=0; i<vertexes; i++) {
        [self splitSegment:(2*i) percentage:percent];
    }
}

- (void) splitSegment:(int)index
          percentage1:(double)percent1
          percentage2:(double)percent2{
    double actualPercentage2 = (percent2 - percent1) / (1 - percent1);
    [self splitSegment:index percentage:percent1];
    [self splitSegment:(index+1) percentage:actualPercentage2];
}

- (void) wrapPoints:(NSMutableArray *)pointsToWrap{
    
}

- (CGPoint) pointAmongArray:(NSMutableArray *)ptsArray nearestToPointAtIndex:(int)index{
    int indexOfNearestPoint = 0;
    CGPoint pt = [[ptsArray objectAtIndex:0] CGPointValue];
    CGPoint refPoint = [self pointAtIndex:index].point;
    double nearestDistance = distance(refPoint, pt);
    for (int i=1; i<[ptsArray count]; i++) {
        pt = [[ptsArray objectAtIndex:i] CGPointValue];
        double newDistance = distance(refPoint, pt);
        if (newDistance < nearestDistance) {
            nearestDistance = newDistance;
            indexOfNearestPoint = i;
        }
    }
    return [[ptsArray objectAtIndex:indexOfNearestPoint] CGPointValue];
}

- (int) indexOfNearestPointToPoint:(CGPoint)pt{
    int indexOfNearestPoint = 0;
    double nearestDistance = distance(pt,[self pointAtIndex:0].point);
    for (int i=1; i<[points count]; i++) {
        double newDistance = distance(pt,[self pointAtIndex:i].point);
        if (newDistance < nearestDistance) {
            nearestDistance = newDistance;
            indexOfNearestPoint = i;
        }
    }
    return indexOfNearestPoint;

}

- (int) indexOfNearestSegmentToPoint:(CGPoint)pt{
    int indexOfNearestSegment = 0;
    double nearestDistance = distance(pt, midpoint([self pointAtIndex:0].point,
                                                   [self nextPointFromIndex:0].point));
    for (int i=1; i<[points count]; i++) {
        double newDistance = distance(pt, midpoint([self pointAtIndex:i].point,
                                                   [self nextPointFromIndex:i].point));
        if (newDistance < nearestDistance) {
            nearestDistance = newDistance;
            indexOfNearestSegment = i;
        }
    }
    return indexOfNearestSegment;
}

- (void) insertPointInNearestSegment:(CGPoint)pt{
    if ([self isVertex:pt]) {
        return;
    }
    int index = [self indexOfNearestSegmentToPoint:pt];
    [self insertPoint:[HVPoint initWithCGPoint:pt] atIndex:(index+1)];
}

@end

@implementation HVBezier

+ (HVBezier *) initWithArray:(NSMutableArray *) pts{
    HVBezier * bezier = [[HVBezier alloc] init];
    [bezier config:pts];
    return bezier;
}

+ (HVBezier *) initWithCapacity:(int) count{
    NSMutableArray * empty = [NSMutableArray array];
    HVBezier * bezier = [HVBezier initWithArray:empty];
    for (int i=0; i<count; i++) {
        [bezier addPoint:[HVBezierPoint initWithCGPoint:CGPointZero]];
    }
    return bezier;
}

- (void) insertPoint:(HVPoint *)pt atIndex:(int)index{
    if ([pt isKindOfClass:[HVBezierPoint class]]) {
        [super insertPoint:pt atIndex:index];
    }else{
        HVBezierPoint * newPt =
        [HVBezierPoint initWithCGPoint:pt.point
                              withType:HVBezierPointTypeVertex];
        [super insertPoint:newPt atIndex:index];
    }
}

- (void) drawBezier:(CGContextRef)context{
    int numberOfPoints = [points count];
    if (numberOfPoints < 2){
        return;
    }else{
        HVBezierPoint * currentPoint = (HVBezierPoint *)[self pointAtIndex:0];
        CGContextMoveToPoint(context, currentPoint.point.x, currentPoint.point.y);
        for (int i=1; i<numberOfPoints; i++) {
            currentPoint = [self bezierPointAtIndex:i];
            CGContextAddLineToPoint(context,
                                    currentPoint.point.x,
                                    currentPoint.point.y);
        }
        CGContextStrokePath(context);
        for (int i=0; i<numberOfPoints; i++) {
            currentPoint = [self bezierPointAtIndex:i];
            [currentPoint draw:context];
        }
    }
}

- (void) drawBezier:(CGContextRef)context vertexes:(BOOL)_vertexes{
    int numberOfPoints = [points count];
    if (numberOfPoints < 2){
        return;
    }else{
        HVBezierPoint * currentPoint = (HVBezierPoint *)[self pointAtIndex:0];
        CGContextMoveToPoint(context, currentPoint.point.x, currentPoint.point.y);
        for (int i=1; i<numberOfPoints; i++) {
            currentPoint = [self bezierPointAtIndex:i];
            CGContextAddLineToPoint(context,
                                    currentPoint.point.x,
                                    currentPoint.point.y);
        }
        if (self.open) {
            CGContextStrokePath(context);
        }else{
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        if (_vertexes) {
            for (int i=0; i<numberOfPoints; i++) {
                currentPoint = [self bezierPointAtIndex:i];
                [currentPoint draw:context];
            }
        }
    }
}


- (HVBezierPoint *)bezierPointAtIndex:(int)index{
    return (HVBezierPoint *)[self pointAtIndex:index];
}


- (UIBezierPath *) getBezierPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    int numberOfPoints = [points count];
    if (numberOfPoints < 2){
        return path;
    }else{
        HVBezierPoint * next;
        HVBezierPoint * current = (HVBezierPoint *)[self pointAtIndex:0];
        [path moveToPoint:current.point];
        for (int i=1; i<numberOfPoints; i++) {
            next = (HVBezierPoint *)[self pointAtIndex:i];
            [path addCurveToPoint:next.point
                    controlPoint1:current->control2.point
                    controlPoint2:next->control1.point];
            current = (HVBezierPoint *)[self pointAtIndex:i];
        }

    }
    return path;
}

- (HVBezierSegment)getSegmentAtIndex:(int)index{
    HVBezierPoint * A = [self bezierPointAtIndex:index];
    HVBezierPoint * B = [self bezierPointAtIndex:(index+1)];
    HVBezierSegment segment;
    segment.P1 = A.point;
    segment.P1C = A->control2.point;
    segment.P2 = B.point;
    segment.P2C = B->control1.point;
    return segment;
}

- (double)calculateLength{
    length = 0;
    int numberOfPoints = [points count];
    for (int i=0; i<numberOfPoints-1; i++) {
        HVBezierSegment seg = [self getSegmentAtIndex:i];
        length += lengthOfCubicBezierSegment(seg.P1, seg.P2, seg.P1C, seg.P2C);
    }
    return length;
}

- (double)length{
    return length;
}

- (CGPoint)pointAtPercentage:(double)percentage{
    int numberOfSegments = [points count] -1;
    double percentagePerSegment = 1.0 / (double) numberOfSegments;
    int segmentIndex = percentage / percentagePerSegment;
    if (segmentIndex >= numberOfSegments) {
        segmentIndex = numberOfSegments - 1;
    }
    HVBezierSegment segment = [self getSegmentAtIndex:segmentIndex];
    double newFactor =
    (percentage - percentagePerSegment * segmentIndex)/percentagePerSegment;
    return pointInCubicBezierAtValue(segment.P1, segment.P2,
                                     segment.P1C, segment.P2C,
                                     newFactor);
}

- (CGPoint)pointAtPercentageNormalized:(double)percentage{
    double total = length;
    double acum = 0;
    double percent = fmod(percentage, 1.0);
    if (percent < 0) { percent = 1.0 - percent; }
//    HVlog(@"resto: ", percent);
    int numberOfSegments = [points count] -1;
    
    if (percentage == 1.0) {
        return [self bezierPointAtIndex:numberOfSegments].point;
    }
    
     for (int i=0; i<numberOfSegments; i++) {
         HVBezierSegment seg = [self getSegmentAtIndex:i];
         double current =
         lengthOfCubicBezierSegment(seg.P1, seg.P2, seg.P1C, seg.P2C);
         double factor = (acum + current)/total;
         if (factor > percent) {
             // the point we are looking for is here
             double dif = factor - percent;
             double newFactor = 1.0 - (dif / (current / total));
        //         double acumPercentage = (acum / total);
        //         double newFactor =
        //        (percent - acumPercentage) / (factor - acumPercentage);
               
             return pointInCubicBezierUsingLengthPercentage(seg.P1, seg.P2,
             seg.P1C, seg.P2C,
             newFactor);
         }
         
         acum += current;
    }
    return [self bezierPointAtIndex:0].point;
    
}

@end

@implementation HVBezierArray

+ (HVBezierArray *)array{
    HVBezierArray * array = [[HVBezierArray alloc] init];
    array->beziers = [NSMutableArray array];
    return array;
}
- (HVBezier *) bezierAtIndex:(int)index{
    return (HVBezier *) [beziers objectAtIndex:index];
}
- (void) addBezier:(HVBezier *)bezier{
    [beziers addObject:bezier];
}
- (void) insertBezier:(HVBezier *)bezier atIndex:(int)index{
    [beziers insertObject:bezier atIndex:index];
}


@end

