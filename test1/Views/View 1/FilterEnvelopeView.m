//
//  FilterEnvelopeView.m
//  test1
//
//  Created by Morten Kleveland on 21.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "FilterEnvelopeView.h"

@implementation FilterEnvelopeView

@synthesize filterAttackKnob;
@synthesize filterDecayKnob;
@synthesize filterSustainKnob;
@synthesize filterReleaseKnob;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *a = [[UINib nibWithNibName:@"FilterEnvelopeView" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"envelopeViewBackground.png"]];

        
        // Filter envelope attack
        filterAttackKnob = [[customEnvelopeSlider alloc]initWithFrame:self.filterAttackPlaceholder.bounds];
        self.filterAttackPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.filterAttackPlaceholder addSubview:filterAttackKnob];
        [self.view addSubview:self.filterAttackPlaceholder];
        self.filterAttackKnob.minimumValue = 0.0015;
        self.filterAttackKnob.maximumValue = 4;
        self.filterAttackKnob.value = 0.5;
        
        // Filter envelope decay
        filterDecayKnob = [[customEnvelopeSlider alloc]initWithFrame:self.filterDecayPlaceholder.bounds];
        self.filterDecayPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.filterDecayPlaceholder addSubview:self.filterDecayKnob];
        [self.view addSubview:self.filterDecayPlaceholder];
        self.filterDecayKnob.minimumValue = 0;
        self.filterDecayKnob.maximumValue = 2;
        self.filterDecayKnob.value = 0.75;
        
        // Filter envelope sustain
        filterSustainKnob = [[customEnvelopeSlider alloc]initWithFrame:self.filterSustainPlaceholder.bounds];
        self.filterSustainPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.filterSustainPlaceholder addSubview:self.filterSustainKnob];
        [self.view addSubview:self.filterSustainPlaceholder];
        self.filterSustainKnob.minimumValue = 0;
        self.filterSustainKnob.maximumValue = 1;
        self.filterSustainKnob.value = 1;
        
        // Filter envelope release
        filterReleaseKnob = [[customEnvelopeSlider alloc]initWithFrame:self.filterReleasePlaceholder.bounds];
        self.filterReleasePlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.filterReleasePlaceholder addSubview:self.filterReleaseKnob];
        [self.view addSubview:self.filterReleasePlaceholder];
        self.filterReleaseKnob.minimumValue = 0.01;
        self.filterReleaseKnob.maximumValue = .5;
        self.filterReleaseKnob.value = 0.5;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
