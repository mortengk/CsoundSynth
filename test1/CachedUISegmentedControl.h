
#import <Foundation/Foundation.h>
#import "BaseValueCacheable.h"
#import "CsoundObj.h"

@interface CachedUISegmentedControl : BaseValueCacheable {
    float cachedValue;
    float* channelPtr;
    NSString* mChannelName;
    UISegmentedControl* segmentedControl;
}

@property (nonatomic, strong) NSString* channelName;

- (CachedUISegmentedControl*)init:(UISegmentedControl*)segmentedControl channelName:(NSString*)channelName;

@end

