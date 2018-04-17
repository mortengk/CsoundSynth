//
//  envelopeView.m
//  test1
//
//  Created by Morten Kleveland on 20.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "envelopeView.h"

@implementation envelopeView

@synthesize ampEnvelopeView;
@synthesize filterEnvelopeView;
@synthesize pitchEnvelopeView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *a = [[UINib nibWithNibName:@"envelopeView" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"envelopeViewBackground.png"]];
        
        ampEnvelopeView = [[AmpEnvelopeView alloc]initWithFrame:CGRectZero];
        [self.envelopePlaceholder addSubview:ampEnvelopeView];
        [self.view addSubview:self.envelopePlaceholder];
        [self.view bringSubviewToFront:ampEnvelopeView];
        
        pitchEnvelopeView = [[PitchEnvelopeView alloc]initWithFrame:CGRectZero];
        [self.envelopePlaceholder addSubview:pitchEnvelopeView];
        [self.view addSubview:self.envelopePlaceholder];
        [self.view bringSubviewToFront:pitchEnvelopeView];
        
        filterEnvelopeView = [[FilterEnvelopeView alloc]initWithFrame:CGRectZero];
        [self.envelopePlaceholder addSubview:filterEnvelopeView];
        [self.view addSubview:self.envelopePlaceholder];
        [self.view bringSubviewToFront:filterEnvelopeView];
        
        filterEnvelopeView.hidden = YES;
        pitchEnvelopeView.hidden = YES;
        [self.envelopePlaceholder sendSubviewToBack:filterEnvelopeView];
    }
    return self;
}

- (IBAction)envelopeSelectionButtonPressed:(UIButton *)sender {
    UIImage *buttonImageOn = [UIImage imageNamed:@"powerButtonOn.png"];
    UIImage *buttonImageOff = [UIImage imageNamed:@"powerButtonOff.png"];

    if (ampEnvelopeView.hidden == NO) {
        ampEnvelopeView.hidden = YES;
        filterEnvelopeView.hidden = NO;
        self.ampLight.image = buttonImageOff;
        self.filterLight.image = buttonImageOn;
    } else if (filterEnvelopeView.hidden == NO) {
        pitchEnvelopeView.hidden = NO;
        filterEnvelopeView.hidden = YES;
        self.pitchLight.image = buttonImageOn;
        self.filterLight.image = buttonImageOff;
    } else if (pitchEnvelopeView.hidden == NO) {
        pitchEnvelopeView.hidden = YES;
        ampEnvelopeView.hidden = NO;
        self.pitchLight.image = buttonImageOff;
        self.ampLight.image = buttonImageOn;
    }
}
@end
