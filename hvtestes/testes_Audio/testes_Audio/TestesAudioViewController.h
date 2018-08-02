//
//  TestesAudioViewController.h
//  testes_Audio
//
//  Created by User on 02/03/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HVAudioVideo.h"

@interface TestesAudioViewController : UIViewController
<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
    UISlider *volumeControl;
    HVAudio * som;
}
@property (nonatomic, retain) IBOutlet UISlider *volumeControl;
-(IBAction) playAudio;
-(IBAction) stopAudio;
-(IBAction) adjustVolume;
@end