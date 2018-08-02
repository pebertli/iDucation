//
//  teste_VideoPlayerViewController.h
//  teste_VideoPlayer
//
//  Created by User on 04/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVAudioVideo.h"

@interface teste_VideoPlayerViewController : UIViewController{
    HVVideoPlayer * videoTest;
    
}

- (IBAction) trocarDeFilme;
- (IBAction) ajustarAoTamanhoOriginal;

@end
