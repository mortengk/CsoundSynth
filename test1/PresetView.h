//
//  PresetView.h
//  test1
//
//  Created by Morten Kleveland on 03.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKViewController.h"

@interface PresetView : UIView

@property (nonatomic, retain) MGKViewController* vc;
@property (nonatomic, retain) NSMutableArray* myPresetArray;
@property (nonatomic, weak) IBOutlet UITableView *myTable;

- (IBAction)closeButtonPressed:(id)sender;
- (IBAction)saveCurrentParameterValuesToDict:(id)sender;

@end
