//
//  MGKPreset2ViewController.m
//  test1
//
//  Created by Morten Kleveland on 17.04.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "MGKPresetViewController.h"

@interface MGKPresetViewController ()

@end

@implementation MGKPresetViewController

@synthesize presetString;
@synthesize db;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)awakeFromNib
{
//    [self.myTable registerNib:[UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
//    self.myTable.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInViewTableView:(UITableView*)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Default presets";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vc1.databaseHandler.myPresetArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    
//    cell.textLabel.text = [self.vc1.databaseHandler.myPresetArray objectAtIndex:indexPath.row];
//    return cell;
    
    NSString *cellIdentifier = @"MyCellIdentifier"; // Attempt to request the reusable cell.
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // No cell available - create one.
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }

    // If preset is the selected one.
    if ([self.vc1.selectedPreset isEqualToString:[self.vc1.databaseHandler.myPresetArray objectAtIndex:indexPath.row]]) {
        [self.myTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    // Set the text of the cell to the row index.
    cell.textLabel.text = [self.vc1.databaseHandler.myPresetArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.vc1.databaseHandler.myPresetArray removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.vc1.myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *preset = [self.vc1.databaseHandler.myPresetArray objectAtIndex:indexPath.row];
    [self.vc1.databaseHandler setParametersFromPreset:preset];
    [self.vc1.presetButton setTitle:preset forState:UIControlStateNormal];
    self.vc1.selectedPreset = [self.vc1.databaseHandler.myPresetArray objectAtIndex:indexPath.row];
}

- (IBAction)saveButtonPressed:(id)sender
{
    // 1. open uialertview and write in a new name
    db = [[DatabaseHandler alloc]init];
    [self noteInput];
    
}

- (void)noteInput
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Name your new preset"
                                                        message:@"Please give it a beautiful name!"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Save", nil];
    
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}

- (void)noteInput2
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"That name is already taken"
                                                        message:@"Please try again"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Save", nil];
    
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UITextField *noteText = [alertView textFieldAtIndex:0];
        presetString = noteText.text;
        
        // 2. If the string already exists as a key in the preset dictionary, ask for a new preset name.
        if([db.myPresetArray containsObject:presetString]) {
            [self noteInput2];
        } else {
            // Insert the current settings as a new preset.
            [db saveCurrentParameterValuesToDict:nil withName:presetString];
        }
        NSLog(@"%@", db.myPresetArray);
    }

}

@end
