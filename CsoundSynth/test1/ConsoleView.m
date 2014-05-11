//
//  ConsoleView.m
//  test1
//
//  Created by Morten Kleveland on 07.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "ConsoleView.h"

@implementation ConsoleView

@synthesize currentMessage = mCurrentMessage;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        mTextView.text = @"Halla";
    }
    return self;
}

- (void)viewDidLoad {
}

- (void)updateUIWithNewMessage:(NSString *)newMessage
{
	NSString *oldText = mTextView.text;
	NSString *fullText = [oldText stringByAppendingString:newMessage];
	mTextView.text = fullText;
}

- (void)messageCallback:(NSValue *)infoObj
{
    @autoreleasepool {
        
        Message info;
        [infoObj getValue:&info];
        char message[1024];
        vsnprintf(message, 1024, info.format, info.valist);
        NSString *messageStr = [NSString stringWithFormat:@"%s", message];
        [self performSelectorOnMainThread:@selector(updateUIWithNewMessage:)
                               withObject:messageStr
                            waitUntilDone:NO];
    }
}

- (void)csoundObjDidStart:(CsoundObj *)csoundObj {
}


- (void)csoundObjComplete:(CsoundObj *)csoundObj {
}

@end
