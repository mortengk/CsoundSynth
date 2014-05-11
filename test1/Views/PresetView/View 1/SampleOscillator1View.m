//
//  SampleOscillator1View.m
//  test1
//
//  Created by Morten Kleveland on 04.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "SampleOscillator1View.h"

@implementation SampleOscillator1View

@synthesize oscillator1FineTuneKnob;
@synthesize oscillator1AmplitudeKnob;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray* a = [[UINib nibWithNibName:@"SampleOscillator1View" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (IBAction)handleValueChanged:(id)sender
{
    if (sender == oscillator1FineTuneKnob) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"oscillator1FineTuneKnobMoved" object:nil];
    } else if (sender == oscillator1AmplitudeKnob) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"oscillator1AmplitudeKnobMoved" object:nil];
    }
}

@end
