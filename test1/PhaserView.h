//
//  PhaserView.h
//  test1
//
//  Created by Morten Kleveland on 25.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKRotaryKnob.h"

@interface PhaserView : UIView

@property (strong, nonatomic) PhaserView* view;
@property (strong, nonatomic) IBOutlet UISwitch *phaserSwitch;

@property (weak, nonatomic) IBOutlet UIView *phaserFreqPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *phaserFeedbackPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *phaserMixPlaceholder;

@property (strong, nonatomic) MGKRotaryKnob *phaserFreqKnob;
@property (strong, nonatomic) MGKRotaryKnob *phaserFeedbackKnob;
@property (strong, nonatomic) MGKRotaryKnob *phaserMixKnob;

@end
