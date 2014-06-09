

#import "CachedUISegmentedControl.h"

@implementation CachedUISegmentedControl

@synthesize channelName = mChannelName;

-(void)updateValueCache:(id)sender {
    cachedValue = ((UISegmentedControl*)sender).selectedSegmentIndex;
    self.cacheDirty = YES;
}

-(CachedUISegmentedControl*)init:(UISegmentedControl*)seg channelName:(NSString*)channelName {
    if (self = [super init]) {
        segmentedControl = seg;
        self.channelName = channelName;
    }
    return self;
}

-(void)setup:(CsoundObj*)csoundObj {
    channelPtr = [csoundObj getInputChannelPtr:self.channelName
                                   channelType:CSOUND_CONTROL_CHANNEL];
    cachedValue = segmentedControl.selectedSegmentIndex;
    self.cacheDirty = YES;
    [segmentedControl addTarget:self action:@selector(updateValueCache:) forControlEvents:UIControlEventValueChanged];
}

-(void)updateValuesToCsound {
    if (self.cacheDirty) {
        *channelPtr = cachedValue;
        self.cacheDirty = NO;
    }
}

-(void)cleanup {
    [segmentedControl removeTarget:self action:@selector(updateValueCache:) forControlEvents:UIControlEventValueChanged];
}


@end