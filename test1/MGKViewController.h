//
//  MGKViewController.h
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderView.h"
#import "View1.h"
#import "View2.h"
#import "View3.h"
#import "View4.h"

@interface MGKViewController : UIViewController {
    NSNumber* knob1value;
    NSNumber* knob2value;
    NSNumber* knob3value;
    NSNumber* knob4value;
}

// GUI
@property (nonatomic, retain) IBOutlet PlaceholderView *pView;
@property (nonatomic, retain) View1 *v1;
@property (nonatomic, retain) View2 *v2;
@property (nonatomic, retain) View3 *v3;
@property (nonatomic, retain) View4 *v4;
@property (nonatomic, weak) IBOutlet UITableView *myTable;

- (IBAction)segmentedControlPressed:(id)sender;
- (IBAction)presetButtonPressed:(id)sender;

// Database 2
@property (nonatomic, retain) NSMutableArray* myPresetArray;
- (IBAction)saveCurrentParameterValuesToDict:(id)sender;
- (void)setParametersFromPreset:(NSString*)presetName;



@end
