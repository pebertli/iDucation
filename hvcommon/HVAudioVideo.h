//
//  HVAudioVideo.h
//  teste_VideoPlayer
//
//  Created by User on 04/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "HVCustomizedViews.h"

@interface HVAudio : NSObject{
    NSTimer * timer;
    float crossfade;
    @public
        AVAudioPlayer * audioPlayer;
        float volumeMin;
        float volumeMax;
}

+ (HVAudio *)audioByName:(NSString *)file;
- (void)playWithCrossfade:(float) seconds;
- (void)stopWithCrossfade:(float) seconds;
- (void)setLoops:(int)loops;
- (void)play;
- (void)stop;

@end

@interface HVMuteButton : HVImageMatrix{
    NSMutableArray * sounds;
    BOOL isMuted;
    int indexOn;
    int indexOff;
}

+ (HVMuteButton *)muteButtonWithImage:(NSString *)file;
- (void)setIndexWhenOn:(int)_on whenOff:(int)_off;
- (void)setMute:(BOOL)mute;
- (void)addAudio:(HVAudio *)audio;
- (BOOL)isMuted;

@end

@interface HVVideoPlayer : HVView{
    
    HVGesturesArea * gestureArea; // control user's finger position
    HVDrag * drag;
    MPMoviePlayerController * movie;
    AVAssetReader * movieReader;
    NSMutableArray * videoFrames; // array of UIImages from loaded frames
    UIImageView * framesContainer; // show the image during slide movement
    AVAssetReaderTrackOutput * output;
    NSTimer * timer; //
    BOOL enableTranslate;
    int frameCount;// count all frames to determine blocks
    int frameBlockLength; // capture only the first frame of each block
    double frameQuality; // compressionQuality for each frame (0.0 to 1.0)
    double progress; // current percentage of movie's progress
}

+ (HVVideoPlayer *)fastCreationSettingFileName:(NSString *)file;
+ (HVVideoPlayer *)fastCreationSettingFileName:(NSString *)file
                                  frameQuality:(double)quality
                                    frameBlock:(int)blockLength;
- (void)setMovie:(NSString *)file;
- (void)play;
- (void)onSlideStart;
- (void)onSlideChange;
- (void)onSlideEnd;
- (void)adjustToMovie;
- (void)enableTranslate:(BOOL)enable;

@end


@interface testeVideoViewController : UIViewController{
    MPMoviePlayerController *moviePlayer;
    HVVideoPlayer * videoTest;
    AVAssetReader * _movieReader;
    UIImage * imagem;
    double tempo;
}

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

-(IBAction) goTo20thSecond;
-(IBAction) playMovie;
-(IBAction) capturar;
-(IBAction) readNextMovieFrame;
-(IBAction) mostrarImagemCapturada;
-(IBAction) mostrarImagemCapturadaDeOutroJeito;
-(IBAction) maisUmTeste;
-(IBAction) ultimoTesteEuAcho;
-(IBAction) trocarVideo;
-(IBAction) autoAjustar;

@end
