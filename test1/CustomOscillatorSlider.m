//
//  customOscillatorSlider.m
//  test1
//
//  Created by Morten Kleveland on 20.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "CustomOscillatorSlider.h"

@implementation CustomOscillatorSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *image = [[UIImage imageNamed:@"oscillatorBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        UIImage *slider = [UIImage imageNamed:@"oscillatorSlider.png"];
        //UIImage *thumbImage = [UIImage imageNamed:@"slider-cap.png"];
        
        
        [self setMaximumTrackImage:image forState:UIControlStateNormal];
        [self setMinimumTrackImage:image forState:UIControlStateNormal];
        [self setThumbImage:slider forState:UIControlStateNormal];
        //[[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateHighlighted];
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
