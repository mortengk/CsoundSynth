//
//  MGKFMSelectionViewController.h
//  test1
//
//  Created by Morten Kleveland on 12.05.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKViewController.h"
#import "RotaryKnob.h"

@interface MGKFMSelectionViewController : UIViewController

@property (strong, nonatomic) UIView *view;
@property (nonatomic, strong) MGKViewController* mainViewController;
@property (strong, nonatomic) IBOutlet UIView *fmKnob1Placeholder;
@property (weak, nonatomic) IBOutlet UIView *fmKnob2Placeholder;
@property (strong, nonatomic) RotaryKnob *fmKnob1;
@property (strong, nonatomic) RotaryKnob *fmKnob2;

@end
