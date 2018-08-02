//
//  teste_VideoPlayerViewController.m
//  teste_VideoPlayer
//
//  Created by User on 04/05/13.
//  Copyright (c) 2013 Handverse. All rights reserved.
//

#import "teste_VideoPlayerViewController.h"
#import "HVUtils.h"

@interface teste_VideoPlayerViewController ()

@end

@implementation teste_VideoPlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    videoTest = [HVVideoPlayer fastCreationSettingFileName:@"lampada.mp4"];
    
    [videoTest setFrame:CGRectMake(50, 500, 500, 425)];
    //[videoTest setBackgroundColor:[UIColor yellowColor]];
    
    [self.view addSubview:videoTest];
    [videoTest play];
    [videoTest enableTranslate:YES];

}


- (void) trocarDeFilme{
    [videoTest setMovie:@"salto.mp4"];
    [videoTest play];
}

- (void) ajustarAoTamanhoOriginal{
    [videoTest adjustToMovie];
    HVlog(@"mudou de tamanho", 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
