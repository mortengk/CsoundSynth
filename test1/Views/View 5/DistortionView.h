//
//  DistortionView.h
//  test1
//
//  Created by Morten Kleveland on 25.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryKnob.h"

@interface DistortionView : UIView

@property (strong, nonatomic) DistortionView* view;
@property (strong, nonatomic) IBOutlet UISwitch *distSwitch;

@property (weak, nonatomic) IBOutlet UIView *distGainPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *distMixPlaceholder;

@property (strong, nonatomic) RotaryKnob *distGainKnob;
@property (strong, nonatomic) RotaryKnob *distMixKnob;

@end
