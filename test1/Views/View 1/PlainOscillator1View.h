//
//  PlainOscillatorView.h
//  test1
//
//  Created by Morten Kleveland on 04.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHRotaryKnob.h"

@interface PlainOscillator1View : UIView

@property (retain, nonatomic) PlainOscillator1View* view;
@property (weak, nonatomic) IBOutlet UIView *oscillator1FineTunePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *oscillator1AmplitudePlaceholder;

@property (strong, nonatomic) MHRotaryKnob *oscillator1FineTuneKnob;
@property (strong, nonatomic) MHRotaryKnob *oscillator1AmplitudeKnob;

@end