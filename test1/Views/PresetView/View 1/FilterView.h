//
//  FilterView.h
//  test1
//
//  Created by Morten Kleveland on 20.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryKnob.h"

@interface FilterView : UIView

@property (strong, nonatomic) FilterView *view;
@property (weak, nonatomic) IBOutlet UIView *knobPlaceholder5;
@property (weak, nonatomic) IBOutlet UIView *knobPlaceholder6;
@property (weak, nonatomic) IBOutlet UIView *filterEnvAmtPlaceholder;
@property (strong, nonatomic) RotaryKnob *filterCutoffKnob;
@property (strong, nonatomic) RotaryKnob *filterResonanceKnob;
@property (strong, nonatomic) RotaryKnob *filterEnvAmtKnob;
@property (strong, nonatomic) IBOutlet UISegmentedControl *filterSegmentedControl;

- (IBAction)filterTypeChanged:(UISegmentedControl *)sender;

@end
