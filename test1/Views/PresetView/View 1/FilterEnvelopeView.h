//
//  FilterEnvelopeView.h
//  test1
//
//  Created by Morten Kleveland on 21.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomEnvelopeSlider.h"

@interface FilterEnvelopeView : UIView

@property (strong, nonatomic) FilterEnvelopeView *view;

@property (weak, nonatomic) IBOutlet UIView *filterAttackPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *filterDecayPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *filterSustainPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *filterReleasePlaceholder;
@property (strong, nonatomic) CustomEnvelopeSlider *filterAttackKnob;
@property (strong, nonatomic) CustomEnvelopeSlider *filterDecayKnob;
@property (strong, nonatomic) CustomEnvelopeSlider *filterSustainKnob;
@property (strong, nonatomic) CustomEnvelopeSlider *filterReleaseKnob;

@end
