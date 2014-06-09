//
//  MGKRecordViewController.h
//  test1
//
//  Created by Morten Kleveland on 20.04.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKViewController.h"

@class MGKViewController;
@interface MGKRecordViewController : UIViewController

- (IBAction)recordButtonPressed:(id)sender;
@property(nonatomic, strong) MGKViewController *vc;

@end
