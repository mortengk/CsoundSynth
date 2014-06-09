//
//  PlainOscillatorView.m
//  test1
//
//  Created by Morten Kleveland on 04.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "PlainOscillator1View.h"

@implementation PlainOscillator1View

@synthesize oscillator1FineTuneKnob;
@synthesize oscillator1AmplitudeKnob;
@synthesize oscillator1FineTunePlaceholder;
@synthesize oscillator1AmplitudePlaceholder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray* a = [[UINib nibWithNibName:@"PlainOscillator1View" bundle:nil]instantiateWithOwner:nil options:nil];
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
