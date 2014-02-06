//
//  View1.m
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "View1.h"

@implementation View1 {

}

@synthesize mhKnob1;
@synthesize mhKnob2;
@synthesize mhKnob3;
@synthesize mhKnob4;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"View1" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        
        [self addObserver:self forKeyPath:@"value" options:0 context:NULL];
        
        self.backgroundColor = [UIColor clearColor];
        
        // Knob 1
        mhKnob1 = [[MHRotaryKnob alloc]initWithFrame:self.knobPlaceholder1.bounds];
        [mhKnob1 addTarget:self action:@selector(handleValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.knobPlaceholder1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.knobPlaceholder1 addSubview:mhKnob1];
        [self.view addSubview:self.knobPlaceholder1];
        self.mhKnob1.value = 0.5;
        
        // Knob 2
        mhKnob2 = [[MHRotaryKnob alloc]initWithFrame:self.knobPlaceholder2.bounds];
        [mhKnob2 addTarget:self action:@selector(handleValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.knobPlaceholder2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.knobPlaceholder2 addSubview:self.mhKnob2];
        [self.view addSubview:self.knobPlaceholder2];
        self.mhKnob2.value = 0.75;
        
        // Knob 3
        mhKnob3 = [[MHRotaryKnob alloc]initWithFrame:self.knobPlaceholder3.bounds];
        [mhKnob3 addTarget:self action:@selector(handleValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.knobPlaceholder3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.knobPlaceholder3 addSubview:self.mhKnob3];
        [self.view addSubview:self.knobPlaceholder3];
        self.mhKnob3.value = 0.5;
        
        // Knob 4
        mhKnob4 = [[MHRotaryKnob alloc]initWithFrame:self.knobPlaceholder4.bounds];
        [mhKnob4 addTarget:self action:@selector(handleValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.knobPlaceholder4.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_image"]];
        [self.knobPlaceholder4 addSubview:self.mhKnob4];
        [self.view addSubview:self.knobPlaceholder4];
        self.mhKnob1.value = 0.5;

    }
    return self;
}

- (IBAction)handleValueChanged:(id)sender
{
    if (sender == mhKnob1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"knob1Moved" object:nil];
    } else if (sender == mhKnob2) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"knob2Moved" object:nil];
    } else if (sender == mhKnob3) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"knob3Moved" object:nil];
    } else if (sender == mhKnob4) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"knob4Moved" object:nil];
    }

    if(sender == self.valueSlider) {
        mhKnob2.value = self.valueSlider.value;
    } else if(sender == mhKnob2) {
        self.valueSlider.value = mhKnob2.value;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if(object == mhKnob2 && [keyPath isEqualToString:@"value"]) {
        self.valueLabel.text = [NSString stringWithFormat:@"%0.2f", mhKnob2.value];
    }
}

@end
