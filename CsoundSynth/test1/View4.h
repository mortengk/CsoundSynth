//
//  View4.h
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "MGKViewController.h"
#import "MGKModMatrixDestinationViewController.h"
#import "MGKModMatrixSourceViewController.h"

@class MGKViewController;
@class MGKModMatrixDestinationViewController;
@class MGKModMatrixSourceViewController;

@interface View4 : UIView <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate>

@property (strong, nonatomic) MGKViewController *vc;
@property (strong, nonatomic) MGKModMatrixDestinationViewController *destViewController;
@property (strong, nonatomic) MGKModMatrixSourceViewController *sourceViewController;
@property (strong, nonatomic) IBOutlet UITableView *sourceTable1;
@property (strong, nonatomic) IBOutlet UITableView *destinationTable1;
@property (strong, nonatomic) NSArray* sourceArray;
@property (strong, nonatomic) NSArray* destinationArray;
- (IBAction)startMotionmanager:(id)sender;

@property (strong, nonatomic) UIPopoverController *destinationPopoverController;
@property (strong, nonatomic) UIPopoverController *sourcePopoverController;

@property (strong, nonatomic) IBOutlet UIButton *source1Button;
@property (strong, nonatomic) IBOutlet UIButton *source2Button;
@property (strong, nonatomic) IBOutlet UIButton *source3Button;
@property (strong, nonatomic) IBOutlet UIButton *source4Button;
@property (strong, nonatomic) IBOutlet UIButton *source5Button;
@property (strong, nonatomic) IBOutlet UIButton *source6Button;
@property (strong, nonatomic) IBOutlet UIButton *source7Button;
@property (strong, nonatomic) IBOutlet UIButton *source8Button;

@property (strong, nonatomic) IBOutlet UIButton *destination1Button;
@property (strong, nonatomic) IBOutlet UIButton *destination2Button;
@property (strong, nonatomic) IBOutlet UIButton *destination3Button;
@property (strong, nonatomic) IBOutlet UIButton *destination4Button;
@property (strong, nonatomic) IBOutlet UIButton *destination5Button;
@property (strong, nonatomic) IBOutlet UIButton *destination6Button;
@property (strong, nonatomic) IBOutlet UIButton *destination7Button;
@property (strong, nonatomic) IBOutlet UIButton *destination8Button;

- (IBAction)source1ButtonPressed:(UIButton*)sender;
- (IBAction)source2ButtonPressed:(UIButton*)sender;
- (IBAction)source3ButtonPressed:(UIButton*)sender;
- (IBAction)source4ButtonPressed:(UIButton*)sender;
- (IBAction)source5ButtonPressed:(UIButton*)sender;
- (IBAction)source6ButtonPressed:(UIButton*)sender;
- (IBAction)source7ButtonPressed:(UIButton*)sender;
- (IBAction)source8ButtonPressed:(UIButton*)sender;

- (IBAction)destination1ButtonPressed:(UIButton*)sender;
- (IBAction)destination2ButtonPressed:(UIButton*)sender;
- (IBAction)destination3ButtonPressed:(UIButton*)sender;
- (IBAction)destination4ButtonPressed:(UIButton*)sender;
- (IBAction)destination5ButtonPressed:(UIButton*)sender;
- (IBAction)destination6ButtonPressed:(UIButton*)sender;
- (IBAction)destination7ButtonPressed:(UIButton*)sender;
- (IBAction)destination8ButtonPressed:(UIButton*)sender;

@end
