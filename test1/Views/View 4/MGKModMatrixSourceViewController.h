//
//  MGKModMatrixSourceViewController.h
//  test1
//
//  Created by Morten Kleveland on 30.04.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKViewController.h"

@class MGKViewController;

@interface MGKModMatrixSourceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MGKViewController *vc;
@property (nonatomic, strong) NSArray *sourceArray;
@property (nonatomic, strong) IBOutlet UITableView *sourceTableView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSString *dictionaryKey;

@end
