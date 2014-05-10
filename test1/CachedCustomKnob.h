
#import <Foundation/Foundation.h>
#import "BaseValueCacheable.h"
#import "CsoundObj.h"
#import "MGKRotaryKnob.h"

@interface CachedCustomKnob : BaseValueCacheable {
    float cachedValue;
    float* channelPtr;
    NSString* mChannelName;
    MGKRotaryKnob* mhKnob;
}

@property (nonatomic, strong) NSString* channelName;

- (CachedCustomKnob*)init:(MGKRotaryKnob*)knob channelName:(NSString*)channelName;

@end

