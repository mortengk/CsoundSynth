//
//  MGKFMSelectionViewController.m
//  test1
//
//  Created by Morten Kleveland on 12.05.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "MGKFMSelectionViewController.h"

@interface MGKFMSelectionViewController ()

@end

@implementation MGKFMSelectionViewController

@synthesize mainViewController;
@synthesize fmKnob1;
@synthesize fmKnob2;
@synthesize fmKnob1Placeholder;
@synthesize fmKnob2Placeholder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    
    //fmKnob1Placeholder = [[UIView alloc]init];
    fmKnob1 = [[MGKRotaryKnob alloc]initWithFrame:fmKnob1Placeholder.bounds];
    fmKnob1Placeholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
    [fmKnob1Placeholder addSubview:fmKnob1];
    [self.view addSubview:fmKnob1Placeholder];
    fmKnob1.defaultValue = 0.01;
    fmKnob1.minimumValue = 0;
    fmKnob1.maximumValue = 1;
    fmKnob1.value = fmKnob1.defaultValue;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
