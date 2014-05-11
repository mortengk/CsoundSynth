//
//  PitchEnvelopeView.m
//  test1
//
//  Created by Morten Kleveland on 28.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "PitchEnvelopeView.h"

@implementation PitchEnvelopeView

@synthesize attackKnob;
@synthesize decayKnob;
@synthesize sustainKnob;
@synthesize releaseKnob;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"PitchEnvelopeView" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"envelopeViewBackground.png"]];
        
        
        // Pitch envelope attack
        attackKnob = [[customEnvelopeSlider alloc]initWithFrame:self.attackPlaceholder.bounds];
        self.attackPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.attackPlaceholder addSubview:attackKnob];
        [self.view addSubview:self.attackPlaceholder];
        self.attackKnob.minimumValue = 0.0015;
        self.attackKnob.maximumValue = 4;
        self.attackKnob.value = 0;
        
        // Pitch envelope decay
        decayKnob = [[customEnvelopeSlider alloc]initWithFrame:self.decayPlaceholder.bounds];
        self.decayPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.decayPlaceholder addSubview:self.decayKnob];
        [self.view addSubview:self.decayPlaceholder];
        self.decayKnob.minimumValue = 0;
        self.decayKnob.maximumValue = 2;
        self.decayKnob.value = 0.75;
        
        // Pitch envelope sustain
        sustainKnob = [[customEnvelopeSlider alloc]initWithFrame:self.sustainPlaceholder.bounds];
        self.sustainPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.sustainPlaceholder addSubview:self.sustainKnob];
        [self.view addSubview:self.sustainPlaceholder];
        self.sustainKnob.minimumValue = 0;
        self.sustainKnob.maximumValue = 1;
        self.sustainKnob.value = 1;
        
        // Pitch envelope release
        releaseKnob = [[customEnvelopeSlider alloc]initWithFrame:self.releasePlaceholder.bounds];
        self.releasePlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.releasePlaceholder addSubview:self.releaseKnob];
        [self.view addSubview:self.releasePlaceholder];
        self.releaseKnob.minimumValue = 0.01;
        self.releaseKnob.maximumValue = .5;
        self.releaseKnob.value = 0;
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
