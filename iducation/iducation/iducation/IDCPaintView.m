
#import "IDCPaintView.h"

@implementation IDCPaintView

@synthesize modified;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mainColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:1];
        mode = kCGBlendModeNormal;
        
        //self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        self.backgroundColor = [UIColor redColor];
        [self initContext:frame.size];
        
    }
    return self;
}

- (void)awakeFromNib
{
    mainColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:1];
    mode = kCGBlendModeNormal;
    
    self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0];
    [self initContext:self.frame.size];
    
    modified = NO;
    
}

- (void) initContext:(CGSize)size {
	
	int bitmapByteCount;
	int	bitmapBytesPerRow;
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow = (size.width * 4);
	bitmapByteCount = (bitmapBytesPerRow * size.height);
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	cacheBitmap = malloc( bitmapByteCount );
	cacheContext = CGBitmapContextCreate (cacheBitmap, size.width, size.height, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedFirst);
}

- (void) clear
{
    modified = YES;
    CGContextClearRect(cacheContext, self.bounds);
    [self setNeedsDisplay];
}

- (void) setMainColor:(UIColor*) color
{
    mainColor = color;
}

- (void) enableEraser:(BOOL) enable
{
    if(enable)
        mode = kCGBlendModeClear;
    else
        mode = kCGBlendModeNormal;
}

- (void) paintWithImage:(NSString*) fileName
{

    
    [self clear];
    UIImage* image = loadImageFromDocuments(fileName);
    
    if(image)
    {
        //upside down the image (CGImage) before draw
//        CGAffineTransform transform =CGAffineTransformMakeTranslation(0.0, self.bounds.size.height);
//        transform = CGAffineTransformScale(transform, 1.0, -1.0);
//        CGContextConcatCTM(cacheContext, transform);
        
        CGContextDrawImage(cacheContext, self.bounds, image.CGImage);
        [self setNeedsDisplay];
        
        //return to the correct orientation after draw
//        CGContextConcatCTM(cacheContext, transform);
    }
    
        modified = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    modified = YES;
    UITouch *touch = [touches anyObject];
    [self touchesBegan:[touch locationInView:self]];
}

- (void) touchesBegan:(CGPoint) point{
    
    //reset points
    point0 = CGPointMake(-1, -1);
    point1 = CGPointMake(-1, -1);
    point2 = CGPointMake(-1, -1);
    point3 = point;
    
    //repaint the point area
    [self drawPoint];
    
    
}

- (void) saveImage:(NSString*) fileName
{
    NSData* pngdata = UIImagePNGRepresentation (savedImage); //PNG wrap
    UIImage* img = [UIImage imageWithData:pngdata];
    img = [[UIImage alloc] initWithCGImage:img.CGImage scale:1 orientation:UIImageOrientationDownMirrored];
    
    saveImageInDocuments(savedImage,fileName);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self touchesMoved:[touch locationInView:self]];
}

- (void) touchesMoved:(CGPoint)point {
    
    //update the new point
    point0 = point1;
    point1 = point2;
    point2 = point3;
    point3 = point;
    //repaint the point area
    [self drawToCache];
}

- (void) drawPoint {
//    CGContextSetStrokeColorWithColor(cacheContext, [mainColor CGColor]);
//    CGContextSetLineCap(cacheContext, kCGLineCapRound);
//    CGContextSetLineWidth(cacheContext, 15);
    CGContextSetLineWidth(cacheContext, 2.0);
    const float* colors = CGColorGetComponents(mainColor.CGColor);
    CGContextSetRGBFillColor(cacheContext, colors[0], colors[1], colors[2], colors[3]);
    CGContextSetRGBStrokeColor(cacheContext, colors[0], colors[1], colors[2], colors[3]);
    CGContextSetBlendMode(cacheContext, mode);
    CGContextFillEllipseInRect(cacheContext,CGRectMake(point3.x-(15/2), point3.y-(15/2), 15, 15));
    
    [self setNeedsDisplayInRect:CGRectMake(point3.x-(15/2), point3.y-(15/2), 15, 15)];
}

- (void) drawToCache {
    if(point1.x > -1){
        //hue += 0.005;
        //if(hue > 1.0) hue = 0.0;
        //        UIColor *color = [UIColor colorWithHue:0.5 saturation:0.7 brightness:1.0 alpha:1.0];
        
        
        CGContextSetStrokeColorWithColor(cacheContext, [mainColor CGColor]);
        CGContextSetLineCap(cacheContext, kCGLineCapRound);
        CGContextSetLineWidth(cacheContext, 15);
        CGContextSetBlendMode(cacheContext, mode);
        
        double x0 = (point0.x > -1) ? point0.x : point1.x; //after 4 touches we should have a back anchor point, if not, use the current anchor point
        double y0 = (point0.y > -1) ? point0.y : point1.y; //after 4 touches we should have a back anchor point, if not, use the current anchor point
        double x1 = point1.x;
        double y1 = point1.y;
        double x2 = point2.x;
        double y2 = point2.y;
        double x3 = point3.x;
        double y3 = point3.y;
        // Assume we need to calculate the control
        // points between (x1,y1) and (x2,y2).
        // Then x0,y0 - the previous vertex,
        //      x3,y3 - the next one.
        
        double xc1 = (x0 + x1) / 2.0;
        double yc1 = (y0 + y1) / 2.0;
        double xc2 = (x1 + x2) / 2.0;
        double yc2 = (y1 + y2) / 2.0;
        double xc3 = (x2 + x3) / 2.0;
        double yc3 = (y2 + y3) / 2.0;
        
        double len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
        double len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
        double len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
        
        double k1 = len1 / (len1 + len2);
        double k2 = len2 / (len2 + len3);
        
        double xm1 = xc1 + (xc2 - xc1) * k1;
        double ym1 = yc1 + (yc2 - yc1) * k1;
        
        double xm2 = xc2 + (xc3 - xc2) * k2;
        double ym2 = yc2 + (yc3 - yc2) * k2;
        double smooth_value = 0.8;
        // Resulting control points. Here smooth_value is mentioned
        // above coefficient K whose value should be in range [0...1].
        float ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
        float ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
        
        float ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
        float ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
        
        CGContextMoveToPoint(cacheContext, point1.x, point1.y);
        CGContextAddCurveToPoint(cacheContext, ctrl1_x, ctrl1_y, ctrl2_x, ctrl2_y, point2.x, point2.y);
        CGContextStrokePath(cacheContext);
        
        CGRect dirtyPoint1 = CGRectMake(point1.x-10, point1.y-10, 20, 20);
        CGRect dirtyPoint2 = CGRectMake(point2.x-10, point2.y-10, 20, 20);
        [self setNeedsDisplayInRect:CGRectUnion(dirtyPoint1, dirtyPoint2)];
    }
}

- (void) drawRect:(CGRect)rect {
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGImageRef cacheImage = CGBitmapContextCreateImage(cacheContext);
    savedImage = [[UIImage alloc] initWithCGImage:cacheImage];
    CGContextDrawImage(context, self.bounds, cacheImage);
    CGImageRelease(cacheImage);
    
}



@end
