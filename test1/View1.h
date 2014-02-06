//
//  View1.h
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHRotaryKnob.h"

@interface View1 : UIView

@property (nonatomic, retain) IBOutlet View1 *view;

// Knobs
@property (weak, nonatomic) IBOutlet UISlider *valueSlider;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UIView *knobPlaceholder1;
@property (weak, nonatomic) IBOutlet UIView *knobPlaceholder2;
@property (weak, nonatomic) IBOutlet UIView *knobPlaceholder3;
@property (weak, nonatomic) IBOutlet UIView *knobPlaceholder4;

@property (strong, nonatomic) MHRotaryKnob *mhKnob1;
@property (strong, nonatomic) MHRotaryKnob *mhKnob2;
@property (strong, nonatomic) MHRotaryKnob *mhKnob3;
@property (strong, nonatomic) MHRotaryKnob *mhKnob4;

- (IBAction)handleValueChanged:(id)sender;

@end
