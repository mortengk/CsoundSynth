//
//  MGKPreset2ViewController.h
//  test1
//
//  Created by Morten Kleveland on 17.04.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKViewController.h"
#import "DatabaseHandler.h"

@class DatabaseHandler;
@interface MGKPresetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MGKViewController* vc1;

@property (strong, nonatomic) DatabaseHandler* db;
@property (nonatomic, weak) IBOutlet UITableView *myTable;
@property (nonatomic, strong) NSString* presetString;
- (IBAction)saveButtonPressed:(id)sender;


@end
