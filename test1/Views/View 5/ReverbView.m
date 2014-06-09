//
//  ReverbView.m
//  test1
//
//  Created by Morten Kleveland on 25.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "ReverbView.h"

@implementation ReverbView

@synthesize view;
@synthesize reverbFreqPlaceholder;
@synthesize reverbRoomSizePlaceholder;
@synthesize reverbMixPlaceholder;
@synthesize reverbFreqKnob;
@synthesize reverbRoomSizeKnob;
@synthesize reverbMixKnob;
@synthesize reverbSwitch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"ReverbView" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor greenColor];
        
        // Reverb room size
        reverbRoomSizeKnob = [[MGKRotaryKnob alloc]initWithFrame:reverbRoomSizePlaceholder.bounds];
        reverbRoomSizePlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [reverbRoomSizePlaceholder addSubview:reverbRoomSizeKnob];
        [view addSubview:reverbRoomSizePlaceholder];
        reverbRoomSizeKnob.minimumValue = 0;
        reverbRoomSizeKnob.maximumValue = 1;
        reverbRoomSizeKnob.value = .8;
        
        // Reverb frequency
        reverbFreqKnob = [[MGKRotaryKnob alloc]initWithFrame:reverbFreqPlaceholder.bounds];
        reverbFreqPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [reverbFreqPlaceholder addSubview:reverbFreqKnob];
        [view addSubview:reverbFreqPlaceholder];
        reverbFreqKnob.minimumValue = 0;
        reverbFreqKnob.maximumValue = 20000;
        reverbFreqKnob.defaultValue = 12000;
        reverbFreqKnob.value = 12000;
        
        // Reverb mix
        reverbMixKnob = [[MGKRotaryKnob alloc]initWithFrame:reverbMixPlaceholder.bounds];
        reverbMixPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [reverbMixPlaceholder addSubview:reverbMixKnob];
        [view addSubview:reverbMixPlaceholder];
        reverbMixKnob.minimumValue = 0;
        reverbMixKnob.maximumValue = 1;
        reverbMixKnob.value = .25;
        
        [reverbSwitch setOn:NO];
    }
    return self;
}

@end
