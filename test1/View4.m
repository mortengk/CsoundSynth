
//
//  View4.m
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "View4.h"
//#import "CustomCell.h"

@implementation View4

@synthesize sourceTable1;
@synthesize destinationTable1;
@synthesize destination1Button;
@synthesize destinationPopoverController;
@synthesize source1Button;
@synthesize sourceArray;
@synthesize sourceViewController;
@synthesize sourcePopoverController;
@synthesize destViewController;
@synthesize destinationArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"View4" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor clearColor];
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
    if (tableView == self.sourceTable1) {
        return @"Sources";
    } else if (tableView == self.destinationTable1) {
        return @"Destinations";
    }
    return @"Drit";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%li", (unsigned long)[self.sourceArray count]);
    if (tableView == self.sourceTable1) {
        NSLog(@"NUmber of sources: %lu", (unsigned long)[self.sourceArray count]);
        return (unsigned long)[self.sourceArray count];
    } else if (tableView == self.destinationTable1) {
        NSLog(@"NUmber of destinations: %lu", (unsigned long)[self.destinationArray count]);
        return (unsigned long)[self.destinationArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(indexPath.row == 0)
    {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        [[tableView delegate]tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    if (tableView == self.sourceTable1) {
        cell.textLabel.text = [self.sourceArray objectAtIndex:indexPath.row];
    } else if (tableView == self.destinationTable1) {
        cell.textLabel.text = [self.destinationArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* chosenCell;
    if (tableView == self.sourceTable1) {
        chosenCell = [self.sourceArray objectAtIndex:indexPath.row];
//        id result = [self getObjectFromDict:sourceDict withKey:chosenCell];
//        if (result != nil) {
//            //self.vc.controlSources[0] = result;
//        }
//        NSLog(@"Før metodekallet");
//        [self.vc setControlSourceNumber:1 toObject:result];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setValue:chosenCell forKey:@"sourceTable1"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"modMatrixSourceCellPressed" object:nil userInfo:dict];
    } else if (tableView == self.destinationTable1) {
        chosenCell = [self.destinationArray objectAtIndex:indexPath.row];
//        id result = [self getObjectFromDict:destDict withKey:chosenCell];
//        if (result != nil) {
//            [self.vc setControlDestinationNumber:1 toObject:result];
//            //self.vc.controlDestinations[0] = result;
//        }
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setValue:chosenCell forKey:@"destinationTable1"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"modMatrixDestinationCellPressed" object:nil userInfo:dict];
    }
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"cellPressed" object:nil];


    //[self.databaseHandler setParametersFromPreset:preset];
    //[presetButton setTitle:preset forState:UIControlStateNormal];
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


- (void)awakeFromNib
{
    [self.sourceTable1 registerNib:[UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    self.sourceTable1.backgroundColor = [UIColor clearColor];
    [self.destinationTable1 registerNib:[UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    self.destinationTable1.backgroundColor = [UIColor clearColor];
}


- (IBAction)startMotionmanager:(id)sender {
    self.vc = [[MGKViewController alloc]init];
    NSLog(@"Motion");
    [self.vc startMotionManager];
}


- (void)openDestinationPopoverControllerFromButton:(UIButton*)sender withDictionaryKey:(NSString*)dictionaryKey
{
    destViewController = [[MGKModMatrixDestinationViewController alloc] initWithNibName:@"MGKModMatrixDestinationViewController" bundle:nil];
    destViewController.button = (UIButton*)sender;
    destViewController.dictionaryKey = dictionaryKey;
    destinationPopoverController = [[UIPopoverController alloc] initWithContentViewController:destViewController];
    destinationPopoverController.delegate = self;
    destinationPopoverController.popoverContentSize = CGSizeMake(300, 400);
    [destinationPopoverController presentPopoverFromRect:destViewController.button.frame inView:self permittedArrowDirections: UIPopoverArrowDirectionUp | UIPopoverArrowDirectionRight animated:YES];
    destViewController.destinationArray = destinationArray;
}


- (void)openSourcePopoverControllerFromButton:(UIButton*)sender withDictionaryKey:(NSString*)dictionaryKey
{
    sourceViewController = [[MGKModMatrixSourceViewController alloc] initWithNibName:@"MGKModMatrixSourceViewController" bundle:nil];
    sourceViewController.button = sender;
    sourceViewController.dictionaryKey = dictionaryKey;
    sourcePopoverController = [[UIPopoverController alloc] initWithContentViewController:sourceViewController];
    sourcePopoverController.delegate = self;
    sourcePopoverController.popoverContentSize = CGSizeMake(300, 400);
    [sourcePopoverController presentPopoverFromRect:sourceViewController.button.frame inView:self permittedArrowDirections: UIPopoverArrowDirectionUp | UIPopoverArrowDirectionLeft animated:YES];
    //[sourcePopoverController setPassthroughViews:[NSArray arrayWithObject:self.vc.keyboardScrollView]];
    sourceViewController.sourceArray = sourceArray;
}


// Source buttons
- (IBAction)source1ButtonPressed:(UIButton*)sender
{
    [self openSourcePopoverControllerFromButton:sender withDictionaryKey:@"sourceTable1"];
}

- (IBAction)source2ButtonPressed:(UIButton*)sender
{
    [self openSourcePopoverControllerFromButton:sender withDictionaryKey:@"sourceTable2"];
}

- (IBAction)source3ButtonPressed:(UIButton*)sender
{
    [self openSourcePopoverControllerFromButton:sender withDictionaryKey:@"sourceTable3"];
}

- (IBAction)source4ButtonPressed:(UIButton*)sender
{
    [self openSourcePopoverControllerFromButton:sender withDictionaryKey:@"sourceTable4"];
}

- (IBAction)source5ButtonPressed:(UIButton*)sender
{
    [self openSourcePopoverControllerFromButton:sender withDictionaryKey:@"sourceTable5"];
}

- (IBAction)source6ButtonPressed:(UIButton*)sender
{
    [self openSourcePopoverControllerFromButton:sender withDictionaryKey:@"sourceTable6"];
}

- (IBAction)source7ButtonPressed:(UIButton*)sender
{
    [self openSourcePopoverControllerFromButton:sender withDictionaryKey:@"sourceTable7"];
}

- (IBAction)source8ButtonPressed:(UIButton*)sender
{
    [self openSourcePopoverControllerFromButton:sender withDictionaryKey:@"sourceTable8"];
}

// Destination buttons
- (IBAction)destination1ButtonPressed:(UIButton*)sender
{
    [self openDestinationPopoverControllerFromButton:sender withDictionaryKey:@"destinationTable1"];
}

- (IBAction)destination2ButtonPressed:(UIButton *)sender
{
    [self openDestinationPopoverControllerFromButton:sender withDictionaryKey:@"destinationTable2"];
}

- (IBAction)destination3ButtonPressed:(UIButton *)sender
{
    [self openDestinationPopoverControllerFromButton:sender withDictionaryKey:@"destinationTable3"];
}

- (IBAction)destination4ButtonPressed:(UIButton *)sender
{
    [self openDestinationPopoverControllerFromButton:sender withDictionaryKey:@"destinationTable4"];
}

- (IBAction)destination5ButtonPressed:(UIButton *)sender
{
    [self openDestinationPopoverControllerFromButton:sender withDictionaryKey:@"destinationTable5"];
}

- (IBAction)destination6ButtonPressed:(UIButton *)sender
{
    [self openDestinationPopoverControllerFromButton:sender withDictionaryKey:@"destinationTable6"];
}

- (IBAction)destination7ButtonPressed:(UIButton *)sender
{
    [self openDestinationPopoverControllerFromButton:sender withDictionaryKey:@"destinationTable7"];
}

- (IBAction)destination8ButtonPressed:(UIButton *)sender
{
    [self openDestinationPopoverControllerFromButton:sender withDictionaryKey:@"destinationTable8"];
}

@end
