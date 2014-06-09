//
//  OscillatorView.m
//  test1
//
//  Created by Morten Kleveland on 20.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "OscillatorView.h"

@implementation OscillatorView 

@synthesize oscillator1AmplitudeKnob;
@synthesize oscillator1FineTuneKnob;
@synthesize oscillator1ModKnob;
@synthesize oscillator1Mod2Knob;
@synthesize oscillator1FatnessKnob;
@synthesize oscillator2AmplitudeKnob;
@synthesize oscillator2FineTuneKnob;
@synthesize oscillator2TuneKnob;
@synthesize oscillator2ModKnob;
@synthesize oscillator2Mod2Knob;
@synthesize oscillator2FatnessKnob;
@synthesize oscillator1Slider;
@synthesize oscillator2Slider;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"OscillatorView" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"envelopeViewBackground.png"]];
        
        UIImage *image = [[UIImage imageNamed:@"oscillatorBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        UIImage *slider = [UIImage imageNamed:@"oscillatorSlider.png"];
        
        [self.oscillator1Slider setMaximumTrackImage:image forState:UIControlStateNormal];
        [self.oscillator1Slider setMinimumTrackImage:image forState:UIControlStateNormal];
        [self.oscillator1Slider setThumbImage:slider forState:UIControlStateNormal];
        
        [self.oscillator2Slider setMaximumTrackImage:image forState:UIControlStateNormal];
        [self.oscillator2Slider setMinimumTrackImage:image forState:UIControlStateNormal];
        [self.oscillator2Slider setThumbImage:slider forState:UIControlStateNormal];
        
        
        // OSCILLATOR 1
        // Fine tune
        oscillator1FineTuneKnob = [[MGKRotaryKnob alloc]initWithFrame:self.oscillator1FineTunePlaceholder.bounds];
        self.oscillator1FineTunePlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.oscillator1FineTunePlaceholder addSubview:self.oscillator1FineTuneKnob];
        [self.view addSubview:self.oscillator1FineTunePlaceholder];
        self.oscillator1FineTuneKnob.defaultValue = 0;
        self.oscillator1FineTuneKnob.minimumValue = -12;
        self.oscillator1FineTuneKnob.maximumValue = 12;
        self.oscillator1FineTuneKnob.value = 0;
        
        NSLog(@"Bounds: %@", NSStringFromCGRect(self.oscillator1FineTuneKnob.bounds));
        
        // Amplitude
        oscillator1AmplitudeKnob = [[MGKRotaryKnob alloc]initWithFrame:self.oscillator1AmplitudePlaceholder.bounds];
        self.oscillator1AmplitudePlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.oscillator1AmplitudePlaceholder addSubview:self.oscillator1AmplitudeKnob];
        [self.view addSubview:self.oscillator1AmplitudePlaceholder];
        self.oscillator1AmplitudeKnob.defaultValue = .6;
        self.oscillator1AmplitudeKnob.minimumValue = 0;
        self.oscillator1AmplitudeKnob.maximumValue = 1;
        self.oscillator1AmplitudeKnob.value = .6;
        
        // Mod
        oscillator1ModKnob = [[MGKRotaryKnob alloc]initWithFrame:self.oscillator1ModPlaceholder.bounds];
        self.oscillator1ModPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.oscillator1ModPlaceholder addSubview:self.oscillator1ModKnob];
        [self.view addSubview:self.oscillator1ModPlaceholder];
        self.oscillator1ModKnob.defaultValue = .5;
        self.oscillator1ModKnob.minimumValue = 0;
        self.oscillator1ModKnob.maximumValue = 1;
        self.oscillator1ModKnob.value = .5;
        
        // Mod 2
        oscillator1Mod2Knob = [[MGKRotaryKnob alloc]initWithFrame:self.oscillator1Mod2Placeholder.bounds];
        self.oscillator1Mod2Placeholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.oscillator1Mod2Placeholder addSubview:self.oscillator1Mod2Knob];
        [self.view addSubview:self.oscillator1ModPlaceholder];
        self.oscillator1Mod2Knob.defaultValue = 0;
        self.oscillator1Mod2Knob.minimumValue = 0;
        self.oscillator1Mod2Knob.maximumValue = 1;
        self.oscillator1Mod2Knob.value = 0;
        
        // Mod 2
        oscillator1FatnessKnob = [[MGKRotaryKnob alloc]initWithFrame:self.oscillator1FatnessPlaceholder.bounds];
        self.oscillator1FatnessPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.oscillator1FatnessPlaceholder addSubview:self.oscillator1FatnessKnob];
        [self.view addSubview:self.oscillator1FatnessPlaceholder];
        self.oscillator1FatnessKnob.defaultValue = 0;
        self.oscillator1FatnessKnob.minimumValue = 0;
        self.oscillator1FatnessKnob.maximumValue = 1;
        self.oscillator1FatnessKnob.value = 0;
        
        // OSCILLATOR 2
        // Fine tune
        oscillator2FineTuneKnob = [[MGKRotaryKnob alloc]initWithFrame:self.oscillator2FineTunePlaceholder.bounds];
        self.oscillator2FineTunePlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.oscillator2FineTunePlaceholder addSubview:self.oscillator2FineTuneKnob];
        [self.view addSubview:self.oscillator2FineTunePlaceholder];
        self.oscillator2FineTuneKnob.defaultValue = 0;
        self.oscillator2FineTuneKnob.minimumValue = -12;
        self.oscillator2FineTuneKnob.maximumValue = 12;
        self.oscillator2FineTuneKnob.value = 0;
        
        // Tune
        oscillator2TuneKnob = [[MGKRotaryKnob alloc]initWithFrame:self.oscillator2TunePlaceholder.bounds];
        self.oscillator2TunePlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.oscillator2TunePlaceholder addSubview:self.oscillator2TuneKnob];
        [self.view addSubview:self.oscillator2TunePlaceholder];
        self.oscillator2TuneKnob.defaultValue = 0;
        self.oscillator2TuneKnob.minimumValue = -24;
        self.oscillator2TuneKnob.maximumValue = 24;
        self.oscillator2TuneKnob.value = -12;
        
        // Amplitude
        oscillator2AmplitudeKnob = [[MGKRotaryKnob alloc]initWithFrame:self.oscillator2AmplitudePlaceholder.bounds];
        self.oscillator2AmplitudePlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.oscillator2AmplitudePlaceholder addSubview:self.oscillator2AmplitudeKnob];
        [self.view addSubview:self.oscillator2AmplitudePlaceholder];
        self.oscillator2AmplitudeKnob.defaultValue = .6;
        self.oscillator2AmplitudeKnob.minimumValue = 0;
        self.oscillator2AmplitudeKnob.maximumValue = 1;
        self.oscillator2AmplitudeKnob.value = .6;
        
        // Mod
        oscillator2ModKnob = [[MGKRotaryKnob alloc]initWithFrame:self.oscillator2ModPlaceholder.bounds];
        self.oscillator2ModPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.oscillator2ModPlaceholder addSubview:self.oscillator2ModKnob];
        [self.view addSubview:self.oscillator2ModPlaceholder];
        self.oscillator2ModKnob.defaultValue = .5;
        self.oscillator2ModKnob.minimumValue = 0;
        self.oscillator2ModKnob.maximumValue = 1;
        self.oscillator2ModKnob.value = .5;
        
        // Mod 2
        oscillator2Mod2Knob = [[MGKRotaryKnob alloc]initWithFrame:self.oscillator2Mod2Placeholder.bounds];
        self.oscillator2Mod2Placeholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.oscillator2Mod2Placeholder addSubview:self.oscillator2Mod2Knob];
        [self.view addSubview:self.oscillator2ModPlaceholder];
        self.oscillator2Mod2Knob.defaultValue = 0;
        self.oscillator2Mod2Knob.minimumValue = 0;
        self.oscillator2Mod2Knob.maximumValue = 1;
        self.oscillator2Mod2Knob.value = 0;

        // Mod 2
        oscillator2FatnessKnob = [[MGKRotaryKnob alloc]initWithFrame:self.oscillator2FatnessPlaceholder.bounds];
        self.oscillator2FatnessPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.oscillator2FatnessPlaceholder addSubview:self.oscillator2FatnessKnob];
        [self.view addSubview:self.oscillator2FatnessPlaceholder];
        self.oscillator2FatnessKnob.defaultValue = 0;
        self.oscillator2FatnessKnob.minimumValue = 0;
        self.oscillator2FatnessKnob.maximumValue = 1;
        self.oscillator2FatnessKnob.value = 0;
    }
    return self;
}


- (IBAction)oscillator1SliderChanged:(UISlider *)sender {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    NSNumber *selectedOsc = [[NSNumber alloc]initWithDouble:sender.value];
    NSString* selectedOscString = [[NSString alloc]initWithFormat: @"%f", [selectedOsc doubleValue]];
    [dict setValue:selectedOscString forKey:@"oscillator1"];
}

- (IBAction)oscillator2SliderChanged:(UISlider *)sender {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    NSNumber *selectedOsc = [[NSNumber alloc]initWithDouble:sender.value];
    NSString* selectedOscString = [[NSString alloc]initWithFormat: @"%f", [selectedOsc doubleValue]];
    [dict setValue:selectedOscString forKey:@"oscillator2"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        NSLog(@"Double tap in touchesBegan");
    }
}


@end
