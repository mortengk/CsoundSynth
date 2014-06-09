//
//  MGKRecordViewController.m
//  test1
//
//  Created by Morten Kleveland on 20.04.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "MGKRecordViewController.h"

@interface MGKRecordViewController ()

@end

@implementation MGKRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.vc = [[MGKViewController alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordButtonPressed:(id)sender
{
    [self.vc record];
}
@end
