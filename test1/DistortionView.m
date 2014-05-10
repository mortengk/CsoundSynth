//
//  DistortionView.m
//  test1
//
//  Created by Morten Kleveland on 25.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "DistortionView.h"

@implementation DistortionView

@synthesize view;
@synthesize distGainPlaceholder;
@synthesize distMixPlaceholder;
@synthesize distGainKnob;
@synthesize distMixKnob;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"DistortionView" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor blueColor];
        
        distGainKnob = [[MGKRotaryKnob alloc]initWithFrame:distGainPlaceholder.bounds];
        distGainPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [distGainPlaceholder addSubview:distGainKnob];
        [view addSubview:distGainPlaceholder];
        distGainKnob.minimumValue = 0;
        distGainKnob.maximumValue = 1;
        distGainKnob.value = .1;
        
        // mix
        distMixKnob = [[MGKRotaryKnob alloc]initWithFrame:distMixPlaceholder.bounds];
        distMixPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [distMixPlaceholder addSubview:distMixKnob];
        [view addSubview:distMixPlaceholder];
        distMixKnob.minimumValue = 0;
        distMixKnob.maximumValue = 1;
        distMixKnob.value = .5;
    }
    return self;
}

@end
