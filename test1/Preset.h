//
//  Preset.h
//  test1
//
//  Created by Morten Kleveland on 28.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Preset : NSManagedObject

@property (nonatomic, retain) NSNumber * knob1;
@property (nonatomic, retain) NSNumber * knob2;

@end
