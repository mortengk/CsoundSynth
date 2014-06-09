//
//  View1.h
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKRotaryKnob.h"
#import "PlainOscillator1View.h"
#import "SampleOscillator1View.h"
#import "CustomOscillatorSlider.h"
#import "envelopeView.h"
#import "OscillatorView.h"
#import "LFOView.h"
#import "FilterView.h"

@interface View1 : UIView

@property (nonatomic, retain) IBOutlet View1 *view;

// Knobs


@property (strong, nonatomic) IBOutlet UIView *envelopePlaceholder;
@property (strong, nonatomic) IBOutlet UIView *filterPlaceholder;
@property (strong, nonatomic) IBOutlet UIView *lfoPlaceholder;
@property (strong, nonatomic) IBOutlet UIView *oscillatorPlaceholder;

@property (strong, nonatomic) PlainOscillator1View *oscillator1View;
@property (strong, nonatomic) envelopeView *envView;
@property (strong, nonatomic) OscillatorView *oscView;
@property (strong, nonatomic) FilterView *filterView;
@property (strong, nonatomic) LFOView *lfoView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *oscillator1SegmentedControl;
@property (strong, nonatomic) IBOutlet CustomOscillatorSlider *oscillator1Slider;
@property (strong, nonatomic) IBOutlet UISlider *oscillator2Slider;

@property (strong, nonatomic) IBOutlet UISegmentedControl *oscillator2SegmentedControl;

- (IBAction)oscillator1Changed:(UISegmentedControl *)sender;
- (IBAction)oscillator2Changed:(UISegmentedControl *)sender;
- (IBAction)oscillator1SliderChanged:(UISlider *)sender;
- (IBAction)oscillator2SliderChanged:(UISlider *)sender;


@end
