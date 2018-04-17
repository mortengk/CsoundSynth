
#import <Foundation/Foundation.h>
#import "BaseValueCacheable.h"
#import "CsoundObj.h"
#import "RotaryKnob.h"

@interface CachedCustomKnob : BaseValueCacheable {
    float cachedValue;
    float* channelPtr;
    NSString* mChannelName;
    RotaryKnob* mhKnob;
}

@property (nonatomic, strong) NSString* channelName;

- (CachedCustomKnob*)init:(RotaryKnob*)knob channelName:(NSString*)channelName;

@end

