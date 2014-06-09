//
//  AmpEnvelopeView.m
//  test1
//
//  Created by Morten Kleveland on 21.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "AmpEnvelopeView.h"

@implementation AmpEnvelopeView

@synthesize ampAttackKnob;
@synthesize ampDecayKnob;
@synthesize ampSustainKnob;
@synthesize ampReleaseKnob;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"AmpEnvelopeView" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"envelopeViewBackground.png"]];
        
        // Amp envelope attack
        ampAttackKnob = [[CustomEnvelopeSlider alloc]initWithFrame:self.ampAttackPlaceholder.bounds];
        self.ampAttackPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.ampAttackPlaceholder addSubview:ampAttackKnob];
        [self.view addSubview:self.ampAttackPlaceholder];
        ampAttackKnob.minimumValue = 0.002;
        ampAttackKnob.maximumValue = 1;
        ampAttackKnob.value = ampAttackKnob.minimumValue;
        
        
        
        // Amp envelope decay
        ampDecayKnob = [[CustomEnvelopeSlider alloc]initWithFrame:self.knobPlaceholder2.bounds];
        self.knobPlaceholder2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.knobPlaceholder2 addSubview:self.ampDecayKnob];
        [self.view addSubview:self.knobPlaceholder2];
        self.ampDecayKnob.minimumValue = 0;
        self.ampDecayKnob.maximumValue = 2;
        self.ampDecayKnob.value = 0.75;
        
        
        
//        // Create a mask layer and the frame to determine what will be visible in the view.
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        CGRect maskRect = CGRectMake(0, 40, 128, 128-40);
//        
//        // Create a path with the rectangle in it.
//        CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
//        
//        // Set the path to the mask layer.
//        maskLayer.path = path;
//        //maskLayer.backgroundColor = [[UIColor redColor]CGColor];
//        
//        // Release the path since it's not covered by ARC.
//        CGPathRelease(path);
//        
//        // Set the mask of the view.
//        self.ampAttackKnob.layer.mask = maskLayer;
//        self.ampAttackKnob.clipsToBounds = NO;
//        
//        [self.view sendSubviewToBack:self.ampAttackPlaceholder];
//        [self.superview bringSubviewToFront:self.knobPlaceholder2];
        
        // Amp envelope sustain
        ampSustainKnob = [[CustomEnvelopeSlider alloc]initWithFrame:self.knobPlaceholder3.bounds];
        self.knobPlaceholder3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.knobPlaceholder3 addSubview:self.ampSustainKnob];
        [self.view addSubview:self.knobPlaceholder3];
        self.ampSustainKnob.minimumValue = 0;
        self.ampSustainKnob.maximumValue = 1;
        self.ampSustainKnob.value = 1;
        
        // Amp envelope release
        ampReleaseKnob = [[CustomEnvelopeSlider alloc]initWithFrame:self.knobPlaceholder4.bounds];
        self.knobPlaceholder4.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.knobPlaceholder4 addSubview:self.ampReleaseKnob];
        [self.view addSubview:self.knobPlaceholder4];
        self.ampReleaseKnob.minimumValue = 0.002;
        self.ampReleaseKnob.maximumValue = 1.5;
        self.ampReleaseKnob.value = ampReleaseKnob.minimumValue;
    
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
