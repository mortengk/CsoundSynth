//
//  MGKModMatrixDestinationViewController.m
//  test1
//
//  Created by Morten Kleveland on 28.04.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "MGKModMatrixDestinationViewController.h"


@interface MGKModMatrixDestinationViewController ()

@end

@implementation MGKModMatrixDestinationViewController

@synthesize destinationArray;
@synthesize destinationTableView;
@synthesize button;
@synthesize dictionaryKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        button = [[UIButton alloc]init];
        dictionaryKey = [[NSString alloc]init];
    }
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInViewTableView:(UITableView*)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Destinations";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (unsigned long)[self.destinationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [self.destinationArray objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* chosenCell;

    chosenCell = [self.destinationArray objectAtIndex:indexPath.row];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    // Send this mod source as a key value pair
    [dict setValue:dictionaryKey forKey:@"selectedDestination"];
    [dict setValue:chosenCell forKey:dictionaryKey];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"modMatrixDestinationCellPressed" object:nil userInfo:dict];
    [button setTitle:chosenCell forState:UIControlStateNormal];
}

- (id)getObjectFromDict:(NSMutableDictionary*)currentDict withKey:(NSString*)comparatorKey
{
    for (NSString* key in currentDict) {
        if (key == comparatorKey) {
            NSLog(@"suksess, %@  -  %@", key, [currentDict objectForKey:key]);
            return [currentDict objectForKey:key];
        }
    }
    return nil;
}

@end
