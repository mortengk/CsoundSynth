//
//  envelopeView.h
//  test1
//
//  Created by Morten Kleveland on 20.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customEnvelopeSlider.h"
#import "AmpEnvelopeView.h"
#import "PitchEnvelopeView.h"
#import "FilterEnvelopeView.h"

@interface envelopeView : UIView

@property (strong, nonatomic) envelopeView *view;
@property (strong, nonatomic) AmpEnvelopeView *ampEnvelopeView;
@property (strong, nonatomic) PitchEnvelopeView *pitchEnvelopeView;
@property (strong, nonatomic) FilterEnvelopeView *filterEnvelopeView;
@property (strong, nonatomic) IBOutlet UIView *envelopePlaceholder;
@property (strong, nonatomic) IBOutlet UIButton *envelopeSelectionButton;
@property (strong, nonatomic) IBOutlet UIImageView *ampLight;
@property (strong, nonatomic) IBOutlet UIImageView *filterLight;
@property (strong, nonatomic) IBOutlet UIImageView *pitchLight;

- (IBAction)envelopeSelectionButtonPressed:(UIButton *)sender;

@end
