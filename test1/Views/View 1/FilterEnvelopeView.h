//
//  FilterEnvelopeView.h
//  test1
//
//  Created by Morten Kleveland on 21.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHRotaryKnob.h"
#import "customEnvelopeSlider.h"

@interface FilterEnvelopeView : UIView

@property (strong, nonatomic) FilterEnvelopeView *view;

@property (weak, nonatomic) IBOutlet UIView *filterAttackPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *filterDecayPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *filterSustainPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *filterReleasePlaceholder;
@property (strong, nonatomic) customEnvelopeSlider *filterAttackKnob;
@property (strong, nonatomic) customEnvelopeSlider *filterDecayKnob;
@property (strong, nonatomic) customEnvelopeSlider *filterSustainKnob;
@property (strong, nonatomic) customEnvelopeSlider *filterReleaseKnob;

@end
