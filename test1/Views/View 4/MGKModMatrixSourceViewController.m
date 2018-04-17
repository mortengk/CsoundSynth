//
//  MGKModMatrixSourceViewController.m
//  test1
//
//  Created by Morten Kleveland on 30.04.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "MGKModMatrixSourceViewController.h"

@interface MGKModMatrixSourceViewController ()

@end

@implementation MGKModMatrixSourceViewController

@synthesize sourceArray;
@synthesize sourceTableView;
@synthesize button;
@synthesize dictionaryKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    return @"Sources";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"array: %@", sourceArray);
    
    NSLog(@"NUmber of destinations: %lu", (unsigned long)[sourceArray count]);
    return (unsigned long)[sourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [sourceArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* chosenCell;
    chosenCell = [sourceArray objectAtIndex:indexPath.row];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    // Send this mod source as a key value pair
    [dict setValue:dictionaryKey forKey:@"selectedSource"];
    [dict setValue:chosenCell forKey:dictionaryKey];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"modMatrixSourceCellPressed" object:nil userInfo:dict];
    [button setTitle:chosenCell forState:UIControlStateNormal];
}

@end
