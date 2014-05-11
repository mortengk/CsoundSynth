//
//  LFOView.m
//  test1
//
//  Created by Morten Kleveland on 20.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "LFOView.h"

@implementation LFOView

@synthesize lfoAmpKnob;
@synthesize lfoFreqKnob;
@synthesize lfoDelayKnob;
@synthesize lfoSegmentedControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *a = [[UINib nibWithNibName:@"LFOView" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"envelopeViewBackground.png"]];
        [self initSegmentedControl];
        
        // LFO1 amplitude
        lfoAmpKnob = [[MGKRotaryKnob alloc]initWithFrame:self.lfoAmpPlaceholder.bounds];
        self.lfoAmpPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.lfoAmpPlaceholder addSubview:self.lfoAmpKnob];
        [self.view addSubview:self.lfoAmpPlaceholder];
        self.lfoAmpKnob.defaultValue = 0.01;
        self.lfoAmpKnob.minimumValue = 0;
        self.lfoAmpKnob.maximumValue = 1;
        self.lfoAmpKnob.value = self.lfoAmpKnob.defaultValue;
        
        // LFO1 speed
        lfoFreqKnob = [[MGKRotaryKnob alloc]initWithFrame:self.lfoFreqPlaceholder.bounds];
        self.lfoFreqPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.lfoFreqPlaceholder addSubview:self.lfoFreqKnob];
        [self.view addSubview:self.lfoFreqPlaceholder];
        self.lfoFreqKnob.defaultValue = 0.13;
        self.lfoFreqKnob.minimumValue = 0;
        self.lfoFreqKnob.maximumValue = 1;
        self.lfoFreqKnob.value = self.lfoFreqKnob.defaultValue;
        
        // LFO1 delay
        lfoDelayKnob = [[MGKRotaryKnob alloc]initWithFrame:self.lfoDelayPlaceholder.bounds];
        self.lfoDelayPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.lfoDelayPlaceholder addSubview:self.lfoDelayKnob];
        [self.view addSubview:self.lfoDelayPlaceholder];
        self.lfoDelayKnob.defaultValue = 0;
        self.lfoDelayKnob.minimumValue = 0;
        self.lfoDelayKnob.maximumValue = 1;
        self.lfoDelayKnob.value = lfoDelayKnob.defaultValue;
    }
    return self;
}

- (void) initSegmentedControl
{
    UIImage *orgimg0 = [[UIImage imageNamed:@"waveformsSineOn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg1off = [[UIImage imageNamed:@"waveformsTriangleOff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg2off = [[UIImage imageNamed:@"waveformsSquareOff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg3off = [[UIImage imageNamed:@"waveformsRandomOff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img0 = [[[UIImage alloc] initWithCGImage:orgimg0.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img1off = [[[UIImage alloc] initWithCGImage:orgimg1off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img2off = [[[UIImage alloc] initWithCGImage:orgimg2off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img3off = [[[UIImage alloc] initWithCGImage:orgimg3off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [lfoSegmentedControl setImage:img0 forSegmentAtIndex:0];
    [lfoSegmentedControl setImage:img1off forSegmentAtIndex:1];
    [lfoSegmentedControl setImage:img2off forSegmentAtIndex:2];
    [lfoSegmentedControl setImage:img3off forSegmentAtIndex:3];
    
    lfoSegmentedControl.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
}

- (IBAction)lfoShapeChanged:(UISegmentedControl *)sender {
    UIImage *orgimg0 = [[UIImage imageNamed:@"waveformsSineOn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg1 = [[UIImage imageNamed:@"waveformsTriangleOn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg2 = [[UIImage imageNamed:@"waveformsSquareOn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg3 = [[UIImage imageNamed:@"waveformsRandomOn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg0off = [[UIImage imageNamed:@"waveformsSineOff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg1off = [[UIImage imageNamed:@"waveformsTriangleOff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg2off = [[UIImage imageNamed:@"waveformsSquareOff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg3off = [[UIImage imageNamed:@"waveformsRandomOff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img0 = [[[UIImage alloc] initWithCGImage:orgimg0.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img1 = [[[UIImage alloc] initWithCGImage:orgimg1.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img2 = [[[UIImage alloc] initWithCGImage:orgimg2.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img3 = [[[UIImage alloc] initWithCGImage:orgimg3.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img0off = [[[UIImage alloc] initWithCGImage:orgimg0off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img1off = [[[UIImage alloc] initWithCGImage:orgimg1off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img2off = [[[UIImage alloc] initWithCGImage:orgimg2off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img3off = [[[UIImage alloc] initWithCGImage:orgimg3off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (sender.selectedSegmentIndex == 0) {
        [lfoSegmentedControl setImage:img0 forSegmentAtIndex:0];
        [lfoSegmentedControl setImage:img1off forSegmentAtIndex:1];
        [lfoSegmentedControl setImage:img2off forSegmentAtIndex:2];
        [lfoSegmentedControl setImage:img3off forSegmentAtIndex:3];
    } else if (sender.selectedSegmentIndex == 1) {
        [lfoSegmentedControl setImage:img0off forSegmentAtIndex:0];
        [lfoSegmentedControl setImage:img1 forSegmentAtIndex:1];
        [lfoSegmentedControl setImage:img2off forSegmentAtIndex:2];
        [lfoSegmentedControl setImage:img3off forSegmentAtIndex:3];
    } else if (sender.selectedSegmentIndex == 2) {
        [lfoSegmentedControl setImage:img0off forSegmentAtIndex:0];
        [lfoSegmentedControl setImage:img1off forSegmentAtIndex:1];
        [lfoSegmentedControl setImage:img2 forSegmentAtIndex:2];
        [lfoSegmentedControl setImage:img3off forSegmentAtIndex:3];
    } else if (sender.selectedSegmentIndex == 3) {
        [lfoSegmentedControl setImage:img0off forSegmentAtIndex:0];
        [lfoSegmentedControl setImage:img1off forSegmentAtIndex:1];
        [lfoSegmentedControl setImage:img2off forSegmentAtIndex:2];
        [lfoSegmentedControl setImage:img3 forSegmentAtIndex:3];
    }
}
@end
