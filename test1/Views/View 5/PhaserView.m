//
//  PhaserView.m
//  test1
//
//  Created by Morten Kleveland on 25.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "PhaserView.h"

@implementation PhaserView

@synthesize view;
@synthesize phaserFreqPlaceholder;
@synthesize phaserFeedbackPlaceholder;
@synthesize phaserMixPlaceholder;
@synthesize phaserFreqKnob;
@synthesize phaserFeedbackKnob;
@synthesize phaserMixKnob;
@synthesize phaserSwitch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"PhaserView" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor orangeColor];
        
        // Phaser frequency
        phaserFreqKnob = [[MGKRotaryKnob alloc]initWithFrame:phaserFreqPlaceholder.bounds];
        phaserFreqPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [phaserFreqPlaceholder addSubview:phaserFreqKnob];
        [view addSubview:phaserFreqPlaceholder];
        phaserFreqKnob.minimumValue = 0;
        phaserFreqKnob.maximumValue = 20;
        phaserFreqKnob.defaultValue = .5;
        phaserFreqKnob.value = phaserFreqKnob.defaultValue;
        
        // Phaser feedback
        phaserFeedbackKnob = [[MGKRotaryKnob alloc]initWithFrame:phaserFeedbackPlaceholder.bounds];
        phaserFeedbackPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [phaserFeedbackPlaceholder addSubview:phaserFeedbackKnob];
        [view addSubview:phaserFeedbackPlaceholder];
        phaserFeedbackKnob.minimumValue = -1;
        phaserFeedbackKnob.maximumValue = 1;
        phaserFeedbackKnob.defaultValue = .5;
        phaserFeedbackKnob.value = .5;
        
        // Phaser mix
        phaserMixKnob = [[MGKRotaryKnob alloc]initWithFrame:phaserMixPlaceholder.bounds];
        phaserMixPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [phaserMixPlaceholder addSubview:phaserMixKnob];
        [view addSubview:phaserMixPlaceholder];
        phaserMixKnob.minimumValue = 0;
        phaserMixKnob.maximumValue = 1;
        phaserMixKnob.value = 1;
    }
    return self;
}

@end
