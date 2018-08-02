//
//  teste_PixelColorsViewController.m
//  teste_PixelColors
//
//  Created by User on 22/04/13.
//  Copyright (c) 2013 HandVerse. All rights reserved.
//

#import "teste_PixelColorsViewController.h"
#import "HVUtils.h"
#import "HVGeometry.h"

@implementation HVImage

+ (HVImage *) fastCreation:(NSString *)imageName{
    HVImage * view = [[HVImage alloc] init];
    [view config:[UIImage imageNamed:imageName]];
//    [view setClipsToBounds:YES];
    view->cor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [label setText:@"T"];
    [label setBackgroundColor:[UIColor clearColor]];
    [view->cor addSubview:label];
    [view addSubview:view->cor];
    [view setBackgroundColor:[UIColor clearColor]];
    view->pontosDeInteresse = [HVImage getPixelsBorder:view->image
                                             red:0
                                           green:0
                                            blue:0
                                           alpha:1
                                        redRange:1
                                      greenRange:1
                                       blueRange:1
                                      alphaRange:0.4
                                     blockSearch:8];
    [view setFrame:CGRectMake(100, 150,
                              [view->image size].width,
                              [view->image size].height * 2)];
    
    CGRect rectContainer = rectContainerOfPoints(view->pontosDeInteresse);
    rectContainer.origin = sumVectors(rectContainer.origin,
                                      CGPointMake(0, [view->image size].height));
    
    NSMutableArray * borderPoints = [NSMutableArray array];
    CGPoint currentPoint = rectContainer.origin;
    [borderPoints addObject:[HVPoint initWithCGPoint:currentPoint]];
    currentPoint = sumVectors(currentPoint, CGPointMake(rectContainer.size.width, 0));
    [borderPoints addObject:[HVPoint initWithCGPoint:currentPoint]];
    currentPoint = sumVectors(currentPoint, CGPointMake(0, rectContainer.size.height));
    [borderPoints addObject:[HVPoint initWithCGPoint:currentPoint]];
    currentPoint = sumVectors(currentPoint, CGPointMake(-rectContainer.size.width, 0));
    [borderPoints addObject:[HVPoint initWithCGPoint:currentPoint]];
    
    HVPolygon * polygon = [HVPolygon initWithArray:borderPoints];
    [polygon splitAllSegmentsUsingPercentage:0.5];
    [polygon splitAllSegmentsUsingPercentage:0.5];
    
    NSMutableArray * pontosQueQuero = [NSMutableArray array];
    for (int i=0; i<[view->pontosDeInteresse count]; i++) {
        CGPoint pontoDeslocado = sumVectors([[view->pontosDeInteresse objectAtIndex:i] CGPointValue], CGPointMake(0, [view->image size].height));
        [pontosQueQuero addObject:[NSValue valueWithCGPoint:pontoDeslocado]];
    }
    
    CGPoint c = [polygon centerOfPolygon].point;
    for (int i=0; i<[polygon.points count]; i++) {
        CGPoint pt = [polygon pointAmongArray:pontosQueQuero
                        nearestToPointAtIndex:i];
        CGPoint currentPoint = [polygon pointAtIndex:i].point;
        CGPoint vectorToCenter = subVectors(c, currentPoint);
        CGPoint vectorToNearest = subVectors(pt, currentPoint);
        CGPoint vectorResultant = sumVectors(currentPoint,
                                             sumVectors(vectorToCenter,
                                                        vectorToNearest));
        double distanceToMove = distance(currentPoint, pt);
        double angleToMove = angleOfSegment(currentPoint, vectorResultant);
        CGPoint newPoint = pointAround(currentPoint, distanceToMove, angleToMove);
        [[polygon pointAtIndex:i] setPoint:newPoint];
    }

    view->polygon = polygon;
    return view;
}

+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
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

+ (NSMutableArray *)getPixels:(UIImage*)image
                          red:(double)r
                        green:(double)g
                         blue:(double)b
                        alpha:(double)a
                     redRange:(double)rR
                   greenRange:(double)gR
                    blueRange:(double)bR
                   alphaRange:(double)aR
                  blockSearch:(int)block{
    
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
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int rows = height / block;
    int cols = width / block;
    for (int i = 0 ; i < rows ; i++){
        for (int j = 0 ; j < cols ; j++){
            int byteIndex = block * ((bytesPerRow * i) + (bytesPerPixel * j));
            CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
            CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
            CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
            CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
            if((ABS(red - r) <= rR)&&
               (ABS(blue - b) <= bR)&&
               (ABS(green - g) <= gR)&&
               (ABS(alpha - a) <= aR)){
                [result addObject:[NSValue valueWithCGPoint:CGPointMake(block * j, block * i)]];
                //HVlog(@"adicionou ", 0);
            }
        }
    }
    
    free(rawData);
    
    return result;

}

+ (NSMutableArray *)getPixelsBorder:(UIImage*)image
                          red:(double)r
                        green:(double)g
                         blue:(double)b
                        alpha:(double)a
                     redRange:(double)rR
                   greenRange:(double)gR
                    blueRange:(double)bR
                   alphaRange:(double)aR
                  blockSearch:(int)block{
    
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


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint point;
    NSArray * fingers = [touches sortedArrayUsingDescriptors:nil];
    for (int i=0; i < [fingers count]; i++) {
        UITouch * touch = (UITouch *)[fingers objectAtIndex:i];
        point = [touch locationInView:self];
    }
    
    NSArray * cores = [HVImage getRGBAsFromImage:self->image atX:point.x andY:point.y count:1];
    UIColor * corAtual = ((UIColor *)[cores objectAtIndex:0]);
    const CGFloat * rgba = CGColorGetComponents([corAtual CGColor]);
    CGFloat r = rgba[0];
    CGFloat g = rgba[1];
    CGFloat b = rgba[2];
    CGFloat a = rgba[3];
    
    
    //NSLog(@"R: %0.02f  G: %0.02f  B: %0.02f A: %0.02f ", r,g,b,a);
    UIBezierPath * bezier = [polygon bezier];
    if ([bezier containsPoint:point]) {
        HVlog(@"Dentro ", 0);
    }else{
        HVlog(@"Fora ", 0);
    }
    
    [self->cor setBackgroundColor:corAtual];
    
    [super touchesMoved:touches withEvent:event];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i=0; i<[pontosDeInteresse count]; i++) {
        drawCircle(context,
                   sumVectors(CGPointMake(0, [image size].height),
                              [[pontosDeInteresse objectAtIndex:i] CGPointValue]), 2);
    }
    
    CGContextFillPath(context);
    
//    CGPoint centerPoly = [polygon centerOfPolygon].point;
//    [[polygon pointAtIndex:0] moveTowards:centerPoly percentage:0.5];

    
    [polygon drawPolygon:context];
    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextStrokePath(context);
    
    
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    for (int i=0; i<[polygon.points count]; i++) {
        HVPoint * pointToDraw = [polygon pointAtIndex:i];
        drawCircle(context, pointToDraw.point , 2);
    }
    CGContextFillPath(context);
    
}

@end

@interface teste_PixelColorsViewController ()

@end

@implementation teste_PixelColorsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    HVImage * imagem = [HVImage fastCreation:@"imagem_teste.png"];
    [self.view addSubview:imagem];
    [imagem setCenter:self.view.center];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
