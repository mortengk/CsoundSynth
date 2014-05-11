//
//  ConsoleView.h
//  test1
//
//  Created by Morten Kleveland on 07.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGKViewController.h"

@interface ConsoleView : UIView <CsoundObjCompletionListener> {
    IBOutlet UITextView *mTextView;
}

@property (nonatomic, strong) NSString *currentMessage;

@end
