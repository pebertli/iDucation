//
//  IDCViewController.h
//  bohrheat
//
//  Created by pebertli on 26/07/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCParticleFlame.h"

@interface IDCViewController : UIViewController
{
    IDCParticleFlame* flame;
    
    UIImageView* spring;
    UIImageView* hotSpring;
    
    BOOL inside;
}
@end
