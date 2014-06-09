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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInViewTableView:(UITableView*)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"Factory presets";
    } else if(section == 1) {
        return @"User presets";
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!db) {
        db = [[DatabaseHandler alloc]init];
        // Updating reference to db
        self.db.mainViewController = self.mainViewController;
    }
    return [db.myPresetArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!db) {
        db = [[DatabaseHandler alloc]init];
        // Updating reference to db
        self.db.mainViewController = self.mainViewController;
    }

    
    NSString *cellIdentifier = @"MyCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }

    // If preset is the selected one.
    if ([self.mainViewController.selectedPreset isEqualToString:[db.myPresetArray objectAtIndex:indexPath.row]]) {
        [self.myTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    // Set the text of the cell to the row index.
    if (indexPath.section == 0) {
        cell.textLabel.text = [db.myPresetArray objectAtIndex:indexPath.row];
    } else if(indexPath.section == 1) {
        cell.textLabel.text = [db.myPresetArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.mainViewController.databaseHandler.myPresetArray removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.mainViewController.myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!db) {
        db = [[DatabaseHandler alloc]init];
        // Updating reference to db
        self.db.mainViewController = self.mainViewController;
    }
    NSString *preset = [db.myPresetArray objectAtIndex:indexPath.row];
    self.mainViewController.databaseHandler.mainViewController = self.mainViewController;
    [self.mainViewController.databaseHandler setParametersFromPreset:preset];
    [self.mainViewController.presetButton setTitle:preset forState:UIControlStateNormal];
    self.mainViewController.selectedPreset = [db.myPresetArray objectAtIndex:indexPath.row];
}

- (IBAction)saveButtonPressed:(id)sender
{
    db = [[DatabaseHandler alloc]init];
    
    // Updating reference to db
    self.db.mainViewController = self.mainViewController;
    
    // Show UIAlertView with preset name input
    [self showPresetSavePopup];
}

- (void)showPresetSavePopup
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Name your new preset"
                                                        message:@"Please give it a beautiful name!"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Save", nil];
    
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}

- (void)showPresetSavePopupIfUserEnteredTakenPresetName
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
        
        // If the string already exists as a key in the preset dictionary, ask for a new preset name.
        if([db.myPresetArray containsObject:presetString]) {
            [self showPresetSavePopupIfUserEnteredTakenPresetName];
        } else {
            // Insert the current settings as a new preset.
            [db saveCurrentParameterValuesToDict:nil withName:presetString];
        }
    }
}

- (void)updateTableView
{
    UITableView *t = self.myTable;
    [t reloadData];
    NSLog(@"mitable: %@", t);
}

@end
