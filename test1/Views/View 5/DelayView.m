//
//  DelayView.m
//  test1
//
//  Created by Morten Kleveland on 29.05.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "DelayView.h"

@implementation DelayView

@synthesize view;
@synthesize param1Placeholder;
@synthesize param2Placeholder;
@synthesize mixPlaceholder;
@synthesize param1Knob;
@synthesize param2Knob;
@synthesize mixKnob;
@synthesize powerSwitch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"DelayView" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor yellowColor];
        
        // Delay time
        param1Knob = [[RotaryKnob alloc]initWithFrame:param1Placeholder.bounds];
        param1Placeholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [param1Placeholder addSubview:param1Knob];
        [view addSubview:param1Placeholder];
        param1Knob.minimumValue = 0;
        param1Knob.maximumValue = 1;
        param1Knob.value = .1;
        
        // Feedback
        param2Knob = [[RotaryKnob alloc]initWithFrame:param2Placeholder.bounds];
        param2Placeholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [param2Placeholder addSubview:param2Knob];
        [view addSubview:param2Placeholder];
        param2Knob.minimumValue = 0;
        param2Knob.maximumValue = 1;
        param2Knob.defaultValue = .1;
        param2Knob.value = .1;
        
        // Mix
        mixKnob = [[RotaryKnob alloc]initWithFrame:mixPlaceholder.bounds];
        mixPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [mixPlaceholder addSubview:mixKnob];
        [view addSubview:mixPlaceholder];
        mixKnob.minimumValue = 0;
        mixKnob.maximumValue = 1;
        mixKnob.value = .25;
        
        [powerSwitch setOn:NO];
    }
    return self;
}

@end
