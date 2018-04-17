

#import "CachedCustomKnob.h"

@implementation CachedCustomKnob

@synthesize channelName = mChannelName;

-(void)updateValueCache:(id)sender {
    //cachedValue = ((UISlider*)sender).value;
    cachedValue = ((RotaryKnob*)sender).value;
    self.cacheDirty = YES;
}

-(CachedCustomKnob*)init:(RotaryKnob*)knob channelName:(NSString*)channelName {
    if (self = [super init]) {
        mhKnob = knob;
        self.channelName = channelName;
    }
    return self;
}

-(void)setup:(CsoundObj*)csoundObj {
    channelPtr = [csoundObj getInputChannelPtr:self.channelName
                                   channelType:CSOUND_CONTROL_CHANNEL];
    cachedValue = mhKnob.value;
    self.cacheDirty = YES;
    [mhKnob addTarget:self action:@selector(updateValueCache:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)updateValuesToCsound {
    if (self.cacheDirty) {
        *channelPtr = cachedValue;
        self.cacheDirty = NO;
    }
}

-(void)cleanup {
    [mhKnob removeTarget:self action:@selector(updateValueCache:) forControlEvents:UIControlEventValueChanged];
}


@end
