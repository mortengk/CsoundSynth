//
//  CustomCell.m
//  test1
//
//  Created by Morten Kleveland on 03.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CustomCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    CustomCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[CustomCell class]]) {
            customCell = (CustomCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

@end
