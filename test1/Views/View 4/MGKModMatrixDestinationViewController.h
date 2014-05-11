//
//  MGKModMatrixDestinationViewController.h
//  test1
//
//  Created by Morten Kleveland on 28.04.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKViewController.h"

@class MGKViewController;
@interface MGKModMatrixDestinationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MGKViewController *vc;
@property (strong, nonatomic) NSArray* destinationArray;
@property (strong, nonatomic) IBOutlet UITableView *destinationTableView;
@property (strong, nonatomic) UIButton *button;
@property (nonatomic, strong) NSString *dictionaryKey;


@end
