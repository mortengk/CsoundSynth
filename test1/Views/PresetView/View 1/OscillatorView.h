//
//  OscillatorView.h
//  test1
//
//  Created by Morten Kleveland on 20.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryKnob.h"
#import "customOscillatorSlider.h"

@interface OscillatorView : UIView

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) RotaryKnob *oscillator1FineTuneKnob;
@property (strong, nonatomic) RotaryKnob *oscillator1AmplitudeKnob;
@property (strong, nonatomic) RotaryKnob *oscillator1ModKnob;
@property (strong, nonatomic) RotaryKnob *oscillator1Mod2Knob;
@property (strong, nonatomic) RotaryKnob *oscillator1FatnessKnob;
@property (strong, nonatomic) RotaryKnob *oscillator2FineTuneKnob;
@property (strong, nonatomic) RotaryKnob *oscillator2TuneKnob;
@property (strong, nonatomic) RotaryKnob *oscillator2AmplitudeKnob;
@property (strong, nonatomic) RotaryKnob *oscillator2ModKnob;
@property (strong, nonatomic) RotaryKnob *oscillator2Mod2Knob;
@property (strong, nonatomic) RotaryKnob *oscillator2FatnessKnob;
@property (strong, nonatomic) UIView* oscillator1HiddenSubviewTouchRecognization;
@property (strong, nonatomic) UIView* oscillator2HiddenSubviewTouchRecognization;

@property (weak, nonatomic) IBOutlet UIView *oscillator1FineTunePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator1AmplitudePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator1ModPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator1Mod2Placeholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator1FatnessPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator2FineTunePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator2TunePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator2AmplitudePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator2ModPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator2Mod2Placeholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator2FatnessPlaceholder;

@property (strong, nonatomic) IBOutlet UISlider *oscillator1Slider;
@property (strong, nonatomic) IBOutlet UISlider *oscillator2Slider;

- (IBAction)oscillator1SliderChanged:(UISlider *)sender;
- (IBAction)oscillator2SliderChanged:(UISlider *)sender;
@end
