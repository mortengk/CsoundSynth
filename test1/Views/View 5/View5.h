//
//  View5.h
//  test1
//
//  Created by Morten Kleveland on 25.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKRotaryKnob.h"
#import "DistortionView.h"
#import "PhaserView.h"
#import "ReverbView.h"

@interface View5 : UIView

@property (strong, nonatomic) View5* view;
@property (nonatomic, retain) DistortionView* distortionView;
@property (nonatomic, retain) PhaserView* phaserView;
@property (nonatomic, retain) ReverbView* reverbView;
@property (weak, nonatomic) IBOutlet UIView *distortionPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *phaserPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *reverbPlaceholder;


@end
