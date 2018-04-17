//
//  PresetView.m
//  test1
//
//  Created by Morten Kleveland on 03.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "PresetView.h"
#import "CustomCell.h"

@implementation PresetView


@synthesize vc;

- (id)initWithFrame:(CGRect)frame andViewController:(MGKViewController*)theVC
{
    self = [super initWithFrame:frame];
    vc = theVC;
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAlpha:.96];
        [self setFrame:frame];
        [self.layer setCornerRadius:12];
        [self.layer setBorderWidth:1];
        [self.layer setBorderColor:[self.tintColor CGColor]];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.myTable registerNib:[UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    self.myTable.backgroundColor = [UIColor clearColor];
}


- (IBAction)saveCurrentParameterValuesToDict:(id)sender
{
    [vc.databaseHandler saveCurrentParameterValuesToDict:sender];
}


- (IBAction)closeButtonPressed:(id)sender {
    [self removeFromSuperview];
}

@end
