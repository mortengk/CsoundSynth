//
//  LFOView.h
//  test1
//
//  Created by Morten Kleveland on 20.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryKnob.h"

@interface LFOView : UIView

@property (strong, nonatomic) LFOView *view;
@property (weak, nonatomic) IBOutlet UIView *lfoFreqPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *lfoAmpPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *lfoDelayPlaceholder;

@property (strong, nonatomic) RotaryKnob *lfoFreqKnob;
@property (strong, nonatomic) RotaryKnob *lfoAmpKnob;
@property (strong, nonatomic) RotaryKnob *lfoDelayKnob;

@property (strong, nonatomic) IBOutlet UISegmentedControl *lfoSegmentedControl;
- (IBAction)lfoShapeChanged:(UISegmentedControl *)sender;

@end
