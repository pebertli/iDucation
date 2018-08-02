
#import "HVUtils.h"
#import <AVFoundation/AVFoundation.h>

void HVlog(NSString * message, double number){
    NSString * format = (floor(number) == ceil(number))?@"%0.0f":@"%0.02f";
    NSString * msg = ([message rangeOfString:@"%0"].location == NSNotFound)?
    [message stringByAppendingString:format]:message;
    NSLog([[NSString alloc] initWithFormat:msg, number]);
}


void HVmsg(NSString * message){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"aviso" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

int randomBetween(int min, int max){
    return (arc4random()% (max - min + 1)) + min;
}

int randomUniformBetween(int min, int max){
    return (arc4random_uniform(100)% (max - min + 1)) + min;
}

BOOL performSelector(id target, SEL selector){
    BOOL result = [target respondsToSelector:selector];
    if (result) { [target performSelector:selector]; }
    return result;
}

void saveImageInDocuments(UIImage* image, NSString* fileName)
{
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [UIImagePNGRepresentation(image) writeToFile:[folderPath stringByAppendingFormat:@"/%@",fileName]  atomically:YES];
}

UIImage* loadImageFromDocuments(NSString* fileName)
{
    
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [UIImage imageWithContentsOfFile:[folderPath stringByAppendingFormat:@"/%@",fileName]];
}

double lowPassFilter(double elapsed, double target, double current, float factor)
{
    double v = factor*elapsed*elapsed;
    v = (current+elapsed);
    if(v>target)
        v = target;
//    
//    return (current) + (factor*v);
    
    return v;
    
}

double linearPassFilter(double elapsed, double target, double current, float factor)
{
    double v = factor*elapsed;
    v = (current+elapsed);
    if(v>target)
        v = target;
    
    return v;
    
}

@implementation HVVelocity

@synthesize currentPosition;
@synthesize currentVelocity;
@synthesize acceleration;
@synthesize terminalVelocity;

- (id) initWithInitialPosition:(double) s0 initialVelocity:(double) v0 acceleration:(double) a
{
    self = [super init];
    
    if(self){
        initialVelocity = v0;
        initialPosition = s0;
        currentPosition = s0;
        currentVelocity = v0;
        acceleration = a;
        terminalVelocity = 0;
    }
    
    return self;
}

- (id) initWithInitialPosition:(double) s0 initialVelocity:(double) v0 acceleration:(double) a finalVelocity:(double) vFinal
{
    self = [super init];
    
    if(self){
        initialVelocity = v0;
        initialPosition = s0;
        currentPosition = s0;
        currentVelocity = v0;
        acceleration = a;
        terminalVelocity = vFinal;
    }
    
    return self;

}
- (void) resetWithInitialPosition:(double) s0 initialVelocity:(double) v0 acceleration:(double) a finalVelocity:(double) vFinal
{
    initialVelocity = v0;
    initialPosition = s0;
    currentPosition = s0;
    currentVelocity = v0;
    acceleration = a;
    terminalVelocity = vFinal;
}

- (void) updateWithTime:(double) timeSinceLastUpdate
{
    double v;
    if ((acceleration!=0) && ((acceleration<0 && initialVelocity<terminalVelocity) || (acceleration>0 && initialVelocity>terminalVelocity))) {
        acceleration = 0;
        initialVelocity = terminalVelocity;
    }
    v = initialPosition+(timeSinceLastUpdate*initialVelocity)+(acceleration*(pow(timeSinceLastUpdate, 2))*0.5);

    initialVelocity = initialVelocity+(acceleration*timeSinceLastUpdate);
    initialPosition = v;
    currentPosition = v;
    currentVelocity = initialVelocity;
       
    
}

@end;

@implementation HVTreeNode

@synthesize value;
@synthesize children;
@synthesize parent;

- (id) initWithValue: (id) v parent:(HVTreeNode*) p{
    self = [super init];
    
    if(self)
    {
        value = v;
        parent = p;
    }
    
return self;
}

- (HVTreeNode*) addChildWithValue:(id) v
{
    //init array when the first child is inserted
    if(!children)
    {
        children = [NSMutableArray array];
    }
    
    HVTreeNode* n = [[HVTreeNode alloc] initWithValue:v parent:self];
    [children addObject:n];
    
    return n;
    
}

- (NSMutableArray*) children
{
    if(!children)
        children = [NSMutableArray array];
    return children;
}

@end

@implementation HVTree

@synthesize root;

- (id) init{
    self = [super init];
    
    if(self){
        root = [[HVTreeNode alloc] initWithValue:nil parent:nil];
    }
    
    return self;
}

- (NSArray*) getAllChindren
{
    NSMutableArray* result = [NSMutableArray array];
    
    result = [self childrenToSet:result withNode:root];
    
    return result;
    
}

- (NSMutableArray*) childrenToSet:(NSMutableArray*) set withNode: (HVTreeNode*) node
{
    [set addObject:node];
    
    for(HVTreeNode* n in [node children])
    {
      [self childrenToSet:set withNode:n];
    }
    
    return  set;
}

@end;

@implementation HVNumber

@synthesize value;

+ (HVNumber *)numberWithDouble:(double)_value{
    HVNumber * number = [[HVNumber alloc] init];
    number.value = _value;
    return number;
}

@end

@implementation HVNumberArray

+ (HVNumberArray *)array{
    HVNumberArray * array = [[HVNumberArray alloc] init];
    array->numbers = [NSMutableArray array];
    return  array;
}
- (double) doubleAtIndex:(int)index{
    return ((HVNumber *)[numbers objectAtIndex:index]).value;
}
- (void) addNumber:(double)number{
    [numbers addObject:[HVNumber numberWithDouble:number]];
}
- (void) insertNumber:(double)number atIndex:(int)index{
    [numbers insertObject:[HVNumber numberWithDouble:number] atIndex:index];
}

- (void)setValue:(double)_value toIndex:(int)index{
    ((HVNumber *)[numbers objectAtIndex:index]).value = _value;
}

@end



UIImage * imageFromFileWithScale(NSString * filename, float scale){
    // ao escalar, a imagem fica pixelada, por isso nao estou usando essa funcao,
    // no HVImageMatrix. É melhor escalar a UIImageView, que fica melhor
    NSString * extension = [filename pathExtension];
    NSString * file = [filename stringByDeletingPathExtension];
    NSString * path = [[NSBundle mainBundle] pathForResource:file ofType:extension];
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:path] scale:scale];
}



NSMutableArray * getPixelsAndRandomize(UIImage* image,
                                       double r, double g, double b, double a,
                                       double rR, double gR, double bR, double aR,
                                       int block, int randomFactor){
    
    NSMutableArray * result = [NSMutableArray array];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int rows = height / block;
    int cols = width / block;
    for (int i = 0 ; i < rows ; i++){
        for (int j = 0 ; j < cols ; j++){
            int rBlockX = block + randomBetween(-randomFactor, randomFactor);
            int rBlockY = block + randomBetween(-randomFactor, randomFactor);
            rBlockX = ((rBlockX < 1)||(rBlockX * j >= width))? block : rBlockX;
            rBlockY = ((rBlockY < 1)||(rBlockY * i >= height))? block : rBlockY;
            int byteIndex = rBlockY * (bytesPerRow * i) +
                            rBlockX * (bytesPerPixel * j);
            CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
            CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
            CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
            CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
            BOOL add = NO;
            if((ABS(red - r) <= rR)&&
               (ABS(blue - b) <= bR)&&
               (ABS(green - g) <= gR)&&
               (ABS(alpha - a) <= aR)){
                add = YES;
            }else if(randomFactor != 0){
                rBlockX = rBlockY = block;
                byteIndex = block * ((bytesPerRow * i) + (bytesPerPixel * j));
                red   = (rawData[byteIndex]     * 1.0) / 255.0;
                green = (rawData[byteIndex + 1] * 1.0) / 255.0;
                blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
                alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
                if((ABS(red - r) <= rR)&&
                   (ABS(blue - b) <= bR)&&
                   (ABS(green - g) <= gR)&&
                   (ABS(alpha - a) <= aR)){
                    add = YES;
                }
            }
            
            if (add) {
                [result addObject:[NSValue valueWithCGPoint:CGPointMake(rBlockX * j, rBlockY * i)]];
            }
        }
    }
    
    free(rawData);
    
    return result;
    
}

NSMutableArray * getPixels(UIImage* image,
                           double r, double g, double b, double a,
                           double rR, double gR, double bR, double aR,
                           int block){
    return getPixelsAndRandomize(image, r, g, b, a, rR, gR, bR, aR, block, 0);
}

NSMutableArray * getPixelsBorder(UIImage* image,
                                    double r, double g, double b, double a,
                                    double rR, double gR, double bR, double aR,
                                    int block){
    
    NSMutableArray * result = [NSMutableArray array];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
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
    
    int rows = height / block;
    int cols = width / block;
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int min_x = width + 1;
    int max_x = -1;
    NSMutableArray * minY = [NSMutableArray array];
    NSMutableArray * maxY = [NSMutableArray array];
    for (int j=0; j<cols; j++) {
        [maxY addObject:[NSNumber numberWithInt:-1]];
        [minY addObject:[NSNumber numberWithInt:(height + 1)]];
    }
    for (int i = 0 ; i < rows ; i++){
        for (int j = 0 ; j < cols ; j++){
            if (j == 0) {
                min_x = width + 1;
                max_x = -1;
            }
            int byteIndex = block * ((bytesPerRow * i) + (bytesPerPixel * j));
            CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
            CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
            CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
            CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
            if((ABS(red - r) <= rR)&&
               (ABS(blue - b) <= bR)&&
               (ABS(green - g) <= gR)&&
               (ABS(alpha - a) <= aR)){
                
                int pos_x = block * j;
                int pos_y = block * i;
                
                min_x = (pos_x < min_x)?pos_x:min_x;
                max_x = (pos_x > max_x)?pos_x:max_x;
                if ([[minY objectAtIndex:j] integerValue] > pos_y) {
                    [minY removeObjectAtIndex:j];
                    [minY insertObject:[NSNumber numberWithInt:pos_y] atIndex:j];
                }
                if ([[maxY objectAtIndex:j] integerValue] < pos_y) {
                    [maxY removeObjectAtIndex:j];
                    [maxY insertObject:[NSNumber numberWithInt:pos_y] atIndex:j];
                }
                
            }
            if (j == cols - 1) {
                if (max_x != -1) {
                    CGPoint A = CGPointMake(min_x, i * block);
                    CGPoint B = CGPointMake(max_x, i * block);
                    [result addObject:[NSValue valueWithCGPoint:A]];
                    if (max_x != min_x) {
                        [result addObject:[NSValue valueWithCGPoint:B]];
                    }
                }
            }
            if (i == rows - 1) {
                int min_y = [[minY objectAtIndex:j] integerValue];
                int max_y = [[maxY objectAtIndex:j] integerValue];
                if (max_y != -1) {
                    CGPoint C = CGPointMake(j * block, min_y);
                    CGPoint D = CGPointMake(j * block, max_y);
                    [result addObject:[NSValue valueWithCGPoint:C]];
                    if (max_y != min_y) {
                        [result addObject:[NSValue valueWithCGPoint:D]];
                    }
                }
            }
        }
    }
    
    free(rawData);
    
    return result;
    
}


void hideView(UIView * view, float duration){
    [UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.alpha = 0;
                     }
                     completion:^(BOOL finihshed){
                         //alphaAnimation = NO;
                     }];
}

void scaleView(UIView * view, float _scale, float duration){
    [UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.transform =
                         CGAffineTransformMakeScale(_scale, _scale);
                     }
                     completion:^(BOOL finihshed){
                         //alphaAnimation = NO;
                     }];
}

void minimizeViewToPoint(UIView * view, CGPoint point, float duration){
    [UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //view.frame = CGRectMake(point.x, point.y, 0, 0);
                         view.center = point;
                         view.transform =
                         CGAffineTransformMakeScale(0.20, 0.20);
                     }
                     completion:^(BOOL finihshed){
                         //alphaAnimation = NO;
                     }];
}

void maximizeViewToPoint(UIView * view, CGPoint point, float duration){
    [UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //view.frame = rect;
                         view.center = point;
                         view.transform =
                         CGAffineTransformMakeScale(1.0, 1.0);
                     }
                     completion:^(BOOL finihshed){
                         //alphaAnimation = NO;
                     }];
}

void animateViewBySetFrameAndAlpha(UIView* view, CGRect finalFrame, float finalAlpha, float duration, BOOL removeFromSuperview)
{
    [UIView animateWithDuration:duration animations:
     ^{
         view.frame = finalFrame;
         view.alpha = finalAlpha;
     } completion:
     ^(BOOL finished)
    {
        if(removeFromSuperview)
           [view removeFromSuperview];
     }];
}

//void animateViewBySetPoint(UIView* view, CGPoint initialPoint, CGPoint finalPoint, float duration)
//{
//    CGRect auxFrame = view.frame;
//    auxFrame.origin = initialPoint;
//    view.frame = auxFrame;
//    auxFrame.origin = finalPoint;
//    
//    [UIView animateWithDuration:duration animations:
//     ^{
//         view.frame = auxFrame;
//     }];
//}
