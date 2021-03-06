//
//  AmpEnvelopeView.h
//  test1
//
//  Created by Morten Kleveland on 21.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customEnvelopeSlider.h"

@interface AmpEnvelopeView : UIView

@property (nonatomic, strong) AmpEnvelopeView *view;

@property (weak, nonatomic) IBOutlet UIView *ampAttackPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *knobPlaceholder2;
@property (weak, nonatomic) IBOutlet UIView *knobPlaceholder3;
@property (weak, nonatomic) IBOutlet UIView *knobPlaceholder4;
@property (strong, nonatomic) customEnvelopeSlider *ampAttackKnob;
@property (strong, nonatomic) customEnvelopeSlider *ampDecayKnob;
@property (strong, nonatomic) customEnvelopeSlider *ampSustainKnob;
@property (strong, nonatomic) customEnvelopeSlider *ampReleaseKnob;

@end
