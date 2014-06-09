//
//  FilterView.m
//  test1
//
//  Created by Morten Kleveland on 20.03.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView

@synthesize filterCutoffKnob;
@synthesize filterResonanceKnob;
@synthesize filterEnvAmtKnob;
@synthesize filterSegmentedControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *a = [[UINib nibWithNibName:@"FilterView" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"envelopeViewBackground.png"]];
        
        [self initFilterUISegmentedControl];

        // Filter cutoff
        filterCutoffKnob = [[MGKRotaryKnob alloc]initWithFrame:self.knobPlaceholder5.bounds];
        self.knobPlaceholder5.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.knobPlaceholder5 addSubview:self.filterCutoffKnob];
        [self.view addSubview:self.knobPlaceholder5];
        self.filterCutoffKnob.minimumValue = 0;
        self.filterCutoffKnob.maximumValue = 1;
        self.filterCutoffKnob.value = 1;
        self.filterCutoffKnob.defaultValue = self.filterCutoffKnob.value;
        
        // Filter resonance
        filterResonanceKnob = [[MGKRotaryKnob alloc]initWithFrame:self.knobPlaceholder6.bounds];
        self.knobPlaceholder6.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.knobPlaceholder6 addSubview:self.filterResonanceKnob];
        [self.view addSubview:self.knobPlaceholder6];
        self.filterResonanceKnob.minimumValue = 0;
        self.filterResonanceKnob.maximumValue = 1;
        self.filterResonanceKnob.value = .2;
        self.filterResonanceKnob.defaultValue = self.filterResonanceKnob.value;
        
        // Filter envelope amount
        filterEnvAmtKnob = [[MGKRotaryKnob alloc]initWithFrame:self.filterEnvAmtPlaceholder.bounds];
        self.filterEnvAmtPlaceholder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.filterEnvAmtPlaceholder addSubview:self.filterEnvAmtKnob];
        [self.view addSubview:self.filterEnvAmtPlaceholder];
        self.filterEnvAmtKnob.minimumValue = 0;
        self.filterEnvAmtKnob.maximumValue = 1;
        self.filterEnvAmtKnob.value = 1;
        self.filterEnvAmtKnob.defaultValue = 1;
    }
    return self;
}

- (void) initFilterUISegmentedControl
{
    UIImage *orgimg0 = [[UIImage imageNamed:@"filterSelectorLPon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg1off = [[UIImage imageNamed:@"filterSelectorHPoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg2off = [[UIImage imageNamed:@"filterSelectorBPoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg3off = [[UIImage imageNamed:@"filterSelectorBRoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIImage *img0 = [[[UIImage alloc] initWithCGImage:orgimg0.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img1off = [[[UIImage alloc] initWithCGImage:orgimg1off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img2off = [[[UIImage alloc] initWithCGImage:orgimg2off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img3off = [[[UIImage alloc] initWithCGImage:orgimg3off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [filterSegmentedControl setImage:img0 forSegmentAtIndex:0];
    [filterSegmentedControl setImage:img1off forSegmentAtIndex:1];
    [filterSegmentedControl setImage:img2off forSegmentAtIndex:2];
    [filterSegmentedControl setImage:img3off forSegmentAtIndex:3];
    
    filterSegmentedControl.transform = CGAffineTransformMakeRotation(M_PI / 2.0);


}

- (IBAction)filterTypeChanged:(UISegmentedControl *)sender {
    UIImage *orgimg0 = [[UIImage imageNamed:@"filterSelectorLPon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg1 = [[UIImage imageNamed:@"filterSelectorHPon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg2 = [[UIImage imageNamed:@"filterSelectorBPon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg3 = [[UIImage imageNamed:@"filterSelectorBRon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg0off = [[UIImage imageNamed:@"filterSelectorLPoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg1off = [[UIImage imageNamed:@"filterSelectorHPoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg2off = [[UIImage imageNamed:@"filterSelectorBPoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *orgimg3off = [[UIImage imageNamed:@"filterSelectorBRoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img0 = [[[UIImage alloc] initWithCGImage:orgimg0.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img1 = [[[UIImage alloc] initWithCGImage:orgimg1.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img2 = [[[UIImage alloc] initWithCGImage:orgimg2.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img3 = [[[UIImage alloc] initWithCGImage:orgimg3.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img0off = [[[UIImage alloc] initWithCGImage:orgimg0off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img1off = [[[UIImage alloc] initWithCGImage:orgimg1off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img2off = [[[UIImage alloc] initWithCGImage:orgimg2off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img3off = [[[UIImage alloc] initWithCGImage:orgimg3off.CGImage scale:1.0 orientation:UIImageOrientationLeft] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (sender.selectedSegmentIndex == 0) {
        [filterSegmentedControl setImage:img0 forSegmentAtIndex:0];
        [filterSegmentedControl setImage:img1off forSegmentAtIndex:1];
        [filterSegmentedControl setImage:img2off forSegmentAtIndex:2];
        [filterSegmentedControl setImage:img3off forSegmentAtIndex:3];
    } else if (sender.selectedSegmentIndex == 1) {
        [filterSegmentedControl setImage:img0off forSegmentAtIndex:0];
        [filterSegmentedControl setImage:img1 forSegmentAtIndex:1];
        [filterSegmentedControl setImage:img2off forSegmentAtIndex:2];
        [filterSegmentedControl setImage:img3off forSegmentAtIndex:3];
    } else if (sender.selectedSegmentIndex == 2) {
        [filterSegmentedControl setImage:img0off forSegmentAtIndex:0];
        [filterSegmentedControl setImage:img1off forSegmentAtIndex:1];
        [filterSegmentedControl setImage:img2 forSegmentAtIndex:2];
        [filterSegmentedControl setImage:img3off forSegmentAtIndex:3];
    } else if (sender.selectedSegmentIndex == 3) {
        [filterSegmentedControl setImage:img0off forSegmentAtIndex:0];
        [filterSegmentedControl setImage:img1off forSegmentAtIndex:1];
        [filterSegmentedControl setImage:img2off forSegmentAtIndex:2];
        [filterSegmentedControl setImage:img3 forSegmentAtIndex:3];
    }
}
@end
