//
//  View5.h
//  test1
//
//  Created by Morten Kleveland on 25.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryKnob.h"
#import "DistortionView.h"
#import "PhaserView.h"
#import "ReverbView.h"
#import "ChorusView.h"
#import "DelayView.h"
#import "FlangerView.h"


@interface View5 : UIView

@property (strong, nonatomic) View5* view;
@property (nonatomic, retain) DistortionView* distortionView;
@property (nonatomic, retain) PhaserView* phaserView;
@property (nonatomic, retain) ReverbView* reverbView;
@property (nonatomic, retain) ChorusView* chorusView;
@property (nonatomic, retain) DelayView* delayView;
@property (nonatomic, retain) FlangerView* flangerView;

@property (weak, nonatomic) IBOutlet UIView *distortionPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *phaserPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *reverbPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *chorusPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *delayPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *flangerPlaceholder;



@end
