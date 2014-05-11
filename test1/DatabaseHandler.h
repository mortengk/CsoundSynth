//
//  DatabaseHandler.h
//  test1
//
//  Created by Morten Kleveland on 11.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGKViewController.h"
#import "View1.h"

@class MGKViewController;
@interface DatabaseHandler : NSObject

@property (nonatomic, strong) NSMutableArray* userPresetArray;
@property (nonatomic, strong) NSMutableArray* myPresetArray;
@property (nonatomic, strong) MGKViewController* mainViewController;
@property (nonatomic, strong) NSMutableDictionary* dict;

- (void)setParametersFromPreset:(NSString*)presetName;
- (IBAction)saveCurrentParameterValuesToDict:(id)sender;
- (IBAction)saveCurrentParameterValuesToDict:(id)sender withName:(NSString*)name;
- (DatabaseHandler*)initWithViewController:(MGKViewController*)vc;

@end
