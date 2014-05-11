//
//  MGKSoundfontSelectionViewController.h
//  test1
//
//  Created by Morten Kleveland on 18.04.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGKViewController.h"

@interface MGKSoundfontSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MGKViewController* mainViewController;

@end
