//
//  HVAudioVideo.m
//  teste_VideoPlayer
//
//  Created by User on 04/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import "HVAudioVideo.h"
#import "HVUtils.h"

@implementation HVAudio

+ (HVAudio *)audioByName:(NSString *)file{
    HVAudio * audio = [[HVAudio alloc] init];
    NSString * name = [file stringByDeletingPathExtension];
    NSString * type = [file pathExtension];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:name
                                         ofType:type]];
    
    NSError *error;
    
    audio->audioPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audio->audioPlayer prepareToPlay];
    audio->volumeMax = 1;
    audio->volumeMin = 0;
        return audio;
}

- (void)playWithCrossfade:(float) seconds
{
    [timer invalidate];
    [audioPlayer play];
    if(seconds<=0)
    {
        audioPlayer.volume = 1;
    }
    else
    {
        crossfade = (1/seconds)*0.1;
    audioPlayer.volume = 0;
    // start now
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    // fire every centesim from then on
    timer = [[NSTimer alloc] initWithFireDate:date interval:0.1 target:self selector:@selector(timerPlay:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }

}
- (void)stopWithCrossfade:(float) seconds
{
    [timer invalidate];
    
    if(seconds<=0)
        [audioPlayer stop];
    else{
        crossfade = (1/seconds)*0.1;
    // start now
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    // fire every centesim from then on
    timer = [[NSTimer alloc] initWithFireDate:date interval:0.1 target:self selector:@selector(timerStop:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }

}

-(void)timerPlay:(NSTimer*)theTimer
{
    audioPlayer.volume+=crossfade;

    if(audioPlayer.volume>=1)
    {
        [timer invalidate];
        timer = nil;
    }
}

-(void)timerStop:(NSTimer*)theTimer
{
    audioPlayer.volume-=crossfade;
    if(audioPlayer.volume<=0)
    {
        [audioPlayer stop];
        [timer invalidate];
    }
}

- (void)setLoops:(int)loops{
    audioPlayer.numberOfLoops = loops;
}

- (void)play{ [audioPlayer play]; }
- (void)stop{ [audioPlayer stop]; }

@end

@implementation HVMuteButton

+ (HVMuteButton *)muteButtonWithImage:(NSString *)file{
    HVMuteButton * button = [[HVMuteButton alloc] init];
    [button config:[UIImage imageNamed:file]];
    [button setMatrixRowsCount:1 andColsCount:2];
    button->indexOff = 0;
    button->indexOn = 1;
    button->sounds = [NSMutableArray array];
    [button setMute:NO];
    return button;
}

- (void)setMute:(BOOL)mute{
    for (int i=0; i<[sounds count]; i++) {
        HVAudio * audio = (HVAudio *)[sounds objectAtIndex:i];
        float vol = mute?(audio->volumeMin):(audio->volumeMax);
        [audio->audioPlayer setVolume:vol];
    }
    int _index = mute?indexOn:indexOff;
    [self setIndex:_index];
    isMuted = mute;
}

- (void)setIndexWhenOn:(int)_on whenOff:(int)_off{
    indexOn = _on;
    indexOff = _off;
}

- (void)addAudio:(HVAudio *)audio{
    [sounds addObject:audio];
}

- (BOOL)isMuted{
    return isMuted;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setMute:![self isMuted]];
}

@end

@implementation HVVideoPlayer

-(void)setFrameQuality:(double)quality frameBlock:(int)blockLength{
    frameQuality = quality;
    frameBlockLength = blockLength;
}

+ (HVVideoPlayer *)fastCreationSettingFileName:(NSString *)file
                                  frameQuality:(double)quality
                                    frameBlock:(int)blockLength{
    
    CGRect frame = CGRectMake(150, 500, 400, 300);
    HVVideoPlayer * view = [[HVVideoPlayer alloc] initWithFrame:frame];
    view->gestureArea = [HVGesturesArea fastCreationSettingNumberOfFingers:2];
    view->movie =  [[MPMoviePlayerController alloc] init];
    view->framesContainer = [[UIImageView alloc] initWithFrame:frame];
    view->drag = [HVDrag fastCreationSettingView:view
                                  andGestureArea:view->gestureArea
                               thatMovesTogether:YES];
    [view->drag setNumberOfTouchesToDrag:2];
    [view enableTranslate:NO];
    [view setFrameQuality:quality frameBlock:blockLength];
    [view setMovie:file];
    
    view->movie.controlStyle = MPMovieControlStyleDefault;
    [view->movie setFullscreen:NO animated:YES];
    [view setFrame:frame];
    [view addSubview:view->framesContainer];
    [view addSubview:view->gestureArea];
    [view addSubview:view->movie.view];
    
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:
                                    view->gestureArea action:@selector(pan:)];
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 2;
    [view->movie.view addGestureRecognizer:pan];
    
    [view setBackgroundColor:[view->movie.view backgroundColor]];
    
    [view->gestureArea setActionsToTarget:view
                                  onStart:@selector(onSlideStart)
                                 onChange:@selector(onSlideChange)
                                    onEnd:@selector(onSlideEnd)];
    
    [view->gestureArea setActionsToTarget:view
                              onSingleTap:@selector(bringMovieToFront)
                              onDoubleTap:nil];
    
    [view->gestureArea enableScaleAndRotation:YES];
    [view->gestureArea enablePanGestureRecognizer:YES];
    
    return view;
    
}

+ (HVVideoPlayer *)fastCreationSettingFileName:(NSString *)file{
    return [HVVideoPlayer fastCreationSettingFileName:file
                                         frameQuality:0.5
                                           frameBlock:3];
}

- (void)setMovie:(NSString *)file{
    NSString * name = [file stringByDeletingPathExtension];
    NSString * type = [file pathExtension];
    
    NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                          pathForResource:name ofType:type]];
    videoFrames = [NSMutableArray array];
    [movie setContentURL:url];
    [self readMovie:url];
    //[self adjustFramesContainerToMovie];
    
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [gestureArea setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [[movie view] setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [framesContainer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (CGSize)getMovieSize{
    UIImage * firstFrame = (UIImage *)[videoFrames objectAtIndex:0];
    return firstFrame.size;
    //  return [movie naturalSize];
}

- (void)adjustFramesContainerToMovie{
    CGSize size = [self getMovieSize];
    CGRect frame = [self frame];
    double factor = frame.size.width / size.width;
    double h = factor * size.height;
    if (h >= frame.size.height) {
        factor = frame.size.height / h;
        double w = frame.size.width * factor;
        [framesContainer setFrame:CGRectMake((frame.size.width - w)/2, 0, w, frame.size.height)];
    }else{
        [framesContainer setFrame:CGRectMake(0, (frame.size.height - h)/2, frame.size.width, h)];
    }
}

- (void)adjustToMovie{
    CGSize size = [self getMovieSize];
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y,
                              size.width, size.height)];
}

- (void)play{
    //[framesContainer setAlpha:0];
    [movie play];
}

- (double)convertPositionToVideoInterval{
    double interval = 0.0;
    double movieDuration = [movie duration];
    double width = self.frame.size.width;
    double currentPosition = [gestureArea centerOfTouchesCurrently].x;
    if (currentPosition > width) {
        interval = movieDuration;
    }else if (currentPosition > 0){
        interval = (currentPosition / width) * movieDuration;
    }
    return interval;
}

- (int)convertPositionToVideoFrame{
    int frame = 0;
    int framesCount = [videoFrames count];
    double width = self.frame.size.width;
    double currentPosition = [gestureArea centerOfTouchesCurrently].x;
    if (currentPosition >= width) {
        frame = framesCount - 1;
    }else if (currentPosition > 0){
        frame = (int) floor(((currentPosition / width) * framesCount));
    }
    progress = ((double)frame) / (framesCount - 1);
    return frame;
}

- (void)onSlideStart{
    int numberOfFingers = [gestureArea numberOfTouchesCurrently];
    if (numberOfFingers == 1) {
        //[framesContainer setAlpha:1];
        //[movie.view setAlpha:0.0];
        [self bringSubviewToFront:framesContainer];
        [movie setControlStyle:MPMovieControlStyleNone];
    }else if (numberOfFingers == 2){
        HVlog(@"comecou a deslizar com %02.0f dedos", numberOfFingers);
    }
}

- (void)onSlideChange{
    int numberOfFingers = [gestureArea numberOfTouchesCurrently];
    
    if (numberOfFingers == 1) {
        int currentFrame = [self convertPositionToVideoFrame];
        [framesContainer setImage:[videoFrames objectAtIndex:currentFrame] ];
        [movie pause];
    }else if (numberOfFingers == 2){
        //        if (enableTranslate) {
        //            [HVDrag moveView:self usingGestureArea:gestureArea fingers:2];
        //        }
        if ([gestureArea scale] > 1.75) {
            [movie setFullscreen:YES animated:YES];
            HVlog(@"escala: ", [gestureArea scale]);
        }
    }
    
}

- (void)onSlideEnd{
    HVlog(@"terminou o deslizamento ", (movie.duration * progress));
    //[movie.view setAlpha:1.0];
    [movie setCurrentPlaybackTime:(movie.duration * progress)];
    [self bringSubviewToFront:gestureArea];
    [movie setCurrentPlaybackTime:(progress * movie.duration)];
    [movie setControlStyle:MPMovieControlStyleDefault];
}

- (void)bringMovieToFront{
    [self bringSubviewToFront:movie.view];
    HVlog(@"movie veio pra frente ", 0);
}

- (void) readMovie:(NSURL *)url
{
	AVURLAsset * asset = [AVURLAsset URLAssetWithURL:url options:nil];
	[asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:
     ^{
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            AVAssetTrack * videoTrack = nil;
                            NSArray * tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
                            if ([tracks count] == 1)
                            {
                                videoTrack = [tracks objectAtIndex:0];
                                
                                NSError * error = nil;
                                
                                movieReader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
                                if (error)
                                    HVlog(error.localizedDescription, 0);
                                
                                NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
                                NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
                                NSDictionary* videoSettings =
                                [NSDictionary dictionaryWithObject:value forKey:key];
                                
                                
                                [movieReader addOutput:[AVAssetReaderTrackOutput
                                                        assetReaderTrackOutputWithTrack:videoTrack
                                                        outputSettings:videoSettings]];
                                [movieReader startReading];
                                [self startToCapture];
                            }
                        });
     }];
    
}

- (void)startToCapture{
    
    progress = 0.0;
    frameCount = 0;
    output = [movieReader.outputs objectAtIndex:0];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(captureVideoFrames) userInfo:nil repeats:YES];
    
}

- (void)captureVideoFrames;
{
    
    if (movieReader.status == AVAssetReaderStatusReading){
        
        CMSampleBufferRef sampleBuffer = [output copyNextSampleBuffer];
        frameCount++;
        if (sampleBuffer != NULL) {
            if (frameCount % frameBlockLength == 0) {
                UIImage * img = [self imageFromSampleBuffer:sampleBuffer];
                [videoFrames addObject:img];
                if ([videoFrames count] == 1) {
                    [self adjustFramesContainerToMovie];
                    [framesContainer setImage:img];
                }
            }
            CFRelease(sampleBuffer);
        }else{
            [timer invalidate];
            HVlog(@"terminou o carregamento ", 0);
            return;
        }
    }
    
}

- (void) enableTranslate:(BOOL)enable{
    [drag enableDrag:enable];
}

-(UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return ([UIImage imageWithData:
             UIImageJPEGRepresentation(image, frameQuality)]);
}


@end
