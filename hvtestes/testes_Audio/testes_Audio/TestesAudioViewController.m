//
//  TestesAudioViewController.m
//  testes_Audio
//
//  Created by User on 02/03/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import "TestesAudioViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TestesAudioViewController ()

@end

@implementation TestesAudioViewController
@synthesize volumeControl;

-(void)playAudio
{
//    [audioPlayer play];
}
-(void)stopAudio
{
//    [audioPlayer stop];
}
-(void)adjustVolume
{
//    if (audioPlayer != nil)
//    {
//        audioPlayer.volume = volumeControl.value;
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"musica"
                                         ofType:@"mp3"]];
    
    NSError *error;
//     AVAudioPlayer *audioPlayer;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
//        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        //[audioPlayer play];
    }
    
    som = [HVAudio audioByName:@"musica.mp3"];
    
    HVDot * dot = [HVDot fastCreationInView:self.view];
    
    [dot setTap:self
actionSingleTap:nil
actionDoubleTap:@selector(tocarHVAudio)];
    
    
}

- (void)tocarHVAudio{
    [som play];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//}
//-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
//{
//}
//-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
//{
//}
//-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
//{
//}

@end
