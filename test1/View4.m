//
//  View4.m
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "View4.h"

@implementation View4

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"View4" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
