//
//  ChorusView.h
//  test1
//
//  Created by Morten Kleveland on 29.05.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKRotaryKnob.h"

@interface ChorusView : UIView

@property (strong, nonatomic) ChorusView* view;
@property (strong, nonatomic) IBOutlet UISwitch *powerSwitch;

@property (weak, nonatomic) IBOutlet UIView *param1Placeholder;
@property (weak, nonatomic) IBOutlet UIView *param2Placeholder;
@property (weak, nonatomic) IBOutlet UIView *param3Placeholder;
@property (weak, nonatomic) IBOutlet UIView *mixPlaceholder;

@property (strong, nonatomic) MGKRotaryKnob *param1Knob;
@property (strong, nonatomic) MGKRotaryKnob *param2Knob;
@property (strong, nonatomic) MGKRotaryKnob *param3Knob;
@property (strong, nonatomic) MGKRotaryKnob *mixKnob;

@end
