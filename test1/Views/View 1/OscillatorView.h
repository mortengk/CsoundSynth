//
//  OscillatorView.h
//  test1
//
//  Created by Morten Kleveland on 20.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKRotaryKnob.h"
#import "customOscillatorSlider.h"

@interface OscillatorView : UIView

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) MGKRotaryKnob *oscillator1FineTuneKnob;
@property (strong, nonatomic) MGKRotaryKnob *oscillator1AmplitudeKnob;
@property (strong, nonatomic) MGKRotaryKnob *oscillator1ModKnob;
@property (strong, nonatomic) MGKRotaryKnob *oscillator2FineTuneKnob;
@property (strong, nonatomic) MGKRotaryKnob *oscillator2TuneKnob;
@property (strong, nonatomic) MGKRotaryKnob *oscillator2AmplitudeKnob;
@property (strong, nonatomic) MGKRotaryKnob *oscillator2ModKnob;
@property (strong, nonatomic) UIView* oscillator1HiddenSubviewTouchRecognization;
@property (strong, nonatomic) UIView* oscillator2HiddenSubviewTouchRecognization;

@property (weak, nonatomic) IBOutlet UIView *oscillator1FineTunePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator1AmplitudePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator1ModPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator2FineTunePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator2TunePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator2AmplitudePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator2ModPlaceholder;

@property (strong, nonatomic) IBOutlet UISlider *oscillator1Slider;
@property (strong, nonatomic) IBOutlet UISlider *oscillator2Slider;

- (IBAction)oscillator1SliderChanged:(UISlider *)sender;
- (IBAction)oscillator2SliderChanged:(UISlider *)sender;
@end
