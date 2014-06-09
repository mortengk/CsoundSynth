//
//  View1.m
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "View1.h"

@implementation View1

@synthesize oscillator1View;
@synthesize oscillator1Slider;
@synthesize oscillator2Slider;
@synthesize envView;
@synthesize oscView;
@synthesize filterView;
@synthesize lfoView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"View1" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        
        [self addObserver:self forKeyPath:@"value" options:0 context:NULL];

        self.backgroundColor = [UIColor clearColor];
                
        envView = [[envelopeView alloc]initWithFrame:CGRectZero];
        [self.envelopePlaceholder addSubview:envView];
        [self.view addSubview:self.envelopePlaceholder];
        [self.view bringSubviewToFront:envView];
        
        filterView = [[FilterView alloc]initWithFrame:CGRectZero];
        [self.filterPlaceholder addSubview:filterView];
        [self.view addSubview:self.filterPlaceholder];
        [self.view bringSubviewToFront:filterView];
        
        lfoView = [[LFOView alloc]initWithFrame:CGRectZero];
        [self.lfoPlaceholder addSubview:lfoView];
        [self.view addSubview:self.lfoPlaceholder];
        [self.view bringSubviewToFront:lfoView];
        
        oscView = [[OscillatorView alloc]initWithFrame:CGRectZero];
        [self.oscillatorPlaceholder addSubview:oscView];
        [self.view addSubview:self.oscillatorPlaceholder];
        [self.view bringSubviewToFront:oscView];
        
    }
    return self;
}

- (IBAction)handleValueChanged:(id)sender
{
}


- (IBAction)oscillator1Changed:(UISegmentedControl*)sender
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    NSInteger selectedOsc = sender.selectedSegmentIndex;
    // + 1 because of the csound instrument number
    selectedOsc += 1;
    NSString* selectedOscString = [[NSString alloc]initWithFormat: @"%li", (long)selectedOsc];
    [dict setValue:selectedOscString forKey:@"oscillator1"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"oscillator1InstrumentChanged" object:nil userInfo:dict];
}

- (IBAction)oscillator1SliderChanged:(UISlider *)sender {
    //NSLog(@"%f", sender.value);
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


- (IBAction)oscillator2Changed:(UISegmentedControl*)sender
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    NSInteger selectedOsc = sender.selectedSegmentIndex;
    // + 11 because of the csound instrument number
    selectedOsc += 11;
    NSString* selectedOscString = [[NSString alloc]initWithFormat: @"%li", (long)selectedOsc];
    [dict setValue:selectedOscString forKey:@"oscillator2"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"oscillator2InstrumentChanged" object:nil userInfo:dict];
}

- (void)setKnob:(MGKRotaryKnob*)knob toPlaceholder:(UIView*)placeholder
{
    NSLog(@"KNAPPEN: %@", knob);
    knob = [[MGKRotaryKnob alloc]initWithFrame:placeholder.bounds];
    [knob addTarget:self action:@selector(handleValueChanged:) forControlEvents:UIControlEventValueChanged];
    placeholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
    [placeholder addSubview:knob];
    [self.view addSubview:placeholder];
}

@end
