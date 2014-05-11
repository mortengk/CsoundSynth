//
//  PitchEnvelopeView.h
//  test1
//
//  Created by Morten Kleveland on 28.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customEnvelopeSlider.h"

@interface PitchEnvelopeView : UIView

@property (strong, nonatomic) PitchEnvelopeView *view;

@property (weak, nonatomic) IBOutlet UIView *attackPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *decayPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *sustainPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *releasePlaceholder;
@property (strong, nonatomic) customEnvelopeSlider *attackKnob;
@property (strong, nonatomic) customEnvelopeSlider *decayKnob;
@property (strong, nonatomic) customEnvelopeSlider *sustainKnob;
@property (strong, nonatomic) customEnvelopeSlider *releaseKnob;

@end
