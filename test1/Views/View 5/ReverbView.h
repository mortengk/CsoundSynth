//
//  ReverbView.h
//  test1
//
//  Created by Morten Kleveland on 25.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKRotaryKnob.h"

@interface ReverbView : UIView

@property (strong, nonatomic) ReverbView* view;
@property (strong, nonatomic) IBOutlet UISwitch *reverbSwitch;

@property (weak, nonatomic) IBOutlet UIView *reverbRoomSizePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *reverbFreqPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *reverbMixPlaceholder;

@property (strong, nonatomic) MGKRotaryKnob *reverbRoomSizeKnob;
@property (strong, nonatomic) MGKRotaryKnob *reverbFreqKnob;
@property (strong, nonatomic) MGKRotaryKnob *reverbMixKnob;

@end
