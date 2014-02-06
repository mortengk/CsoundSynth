//
//  PresetView.m
//  test1
//
//  Created by Morten Kleveland on 03.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "PresetView.h"
#import "CustomCell.h"

@implementation PresetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vc = [[MGKViewController alloc]init];
    }
    return self;
}

- (void)awakeFromNib
{
    [self.myTable registerNib:[UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    self.myTable.backgroundColor = [UIColor clearColor];
}



//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInViewTableView:(UITableView*)tableView
//{
//    return 1;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Factory presets";
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.myPresetArray count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
//{
//    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    NSString *cellValue = [NSString stringWithFormat:@"%@", [self.myPresetArray objectAtIndex:indexPath.row]];
//    cell.textLabel.text = cellValue;
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView
//commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
//forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.myPresetArray removeObjectAtIndex:[indexPath row]];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *preset = [self.myPresetArray objectAtIndex:indexPath.row];
//    [self setParametersFromPreset:preset];
//    
//}


- (IBAction)saveCurrentParameterValuesToDict:(id)sender
{
    // 1. Fill a dictionary with all parameters...
    NSDictionary *currentParameters = [self getDictOfCurrentParameters];
    NSLog(@"%@", currentParameters);
    
    //-----------------------------------------------------------------------------------
    // IMPORTANT SHIT
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"presets.plist"];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    
    NSArray* tempArray = [dict allKeys];
    self.myPresetArray = [NSMutableArray arrayWithArray:tempArray];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:filePath]) {
        [fm createFileAtPath:filePath contents:nil attributes:nil];
        NSLog(@"Created new file");
    }
    
    [dict setObject:currentParameters forKey:@"PresetXXX"];
    [dict writeToFile:filePath atomically:YES];
    //-----------------------------------------------------------------------------------
    
    [self.myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setParametersFromPreset:(NSString*)presetName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"presets.plist"];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    
    // Check if the given string actually exists in the dictionary
    if ([dict objectForKey:presetName]) {
        // Get the selected preset dictionary from the big dictionary
        NSDictionary* theParameters = [[NSDictionary alloc]initWithDictionary:[dict objectForKey:presetName]];
        self.vc.v1.mhKnob1.value = [[theParameters valueForKey:@"knob1value"] floatValue];
        self.vc.v1.mhKnob2.value = [[theParameters valueForKey:@"knob2value"] floatValue];
        self.vc.v1.mhKnob3.value = [[theParameters valueForKey:@"knob3value"] floatValue];
        self.vc.v1.mhKnob4.value = [[theParameters valueForKey:@"knob4value"] floatValue];
    }
}

- (NSMutableDictionary*)getDictOfCurrentParameters
{
    NSMutableDictionary* currentValues = [[NSMutableDictionary alloc]init];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.mhKnob1.value] forKey:@"knob1value"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.mhKnob2.value] forKey:@"knob2value"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.mhKnob3.value] forKey:@"knob3value"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.mhKnob4.value] forKey:@"knob4value"];
    return currentValues;
}

- (void)copyPlistFromMainBundleToDocumentFolder
{
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"presets.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"presets" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }
}

- (IBAction)closeButtonPressed:(id)sender {
    [self removeFromSuperview];
}

@end
