//
//  customEnvelopeSlider.m
//  test1
//
//  Created by Morten Kleveland on 20.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "customEnvelopeSlider.h"

@implementation customEnvelopeSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *image = [[UIImage imageNamed:@"envelopeSliderBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        UIImage *slider = [UIImage imageNamed:@"envelopeSliderSlider.png"];
        //UIImage *thumbImage = [UIImage imageNamed:@"slider-cap.png"];
        
        [self setMaximumTrackImage:image forState:UIControlStateNormal];
        [self setMinimumTrackImage:image forState:UIControlStateNormal];
        [self setThumbImage:slider forState:UIControlStateNormal];
        
//        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 0.5);
//        self.transform = trans;
        
        UIView *superView = self.superview;
        [self removeFromSuperview];
        [self removeConstraints:self.constraints];
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [superView addSubview:self];
        //[self thumbRectForBounds:imag trackRect:image value:self.value];
        
//        CGRect sliderFrame = self.frame;
//        sliderFrame.size.height = 150.0;
//        [self setFrame:sliderFrame];
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
