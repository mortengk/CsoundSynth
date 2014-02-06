//
//  MGKViewController.m
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "MGKViewController.h"

@interface MGKViewController ()

@property (nonatomic, retain) UIView *presetView;

@end

@implementation MGKViewController

@synthesize myPresetArray;
@synthesize presetView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Placeholder view
    UIView *placeholder = [[PlaceholderView alloc]initWithFrame:CGRectZero];
    placeholder = [self.pView initWithFrame:CGRectZero];
    
    //LINE OF DOOM 1
    placeholder.backgroundColor = [UIColor clearColor];

    // View 1
    self.v1 = [[View1 alloc]initWithFrame:CGRectZero];
    // Setting the view position to the placeholder position
    self.v1.frame = CGRectMake(placeholder.frame.origin.x, placeholder.frame.origin.y, placeholder.bounds.size.width, placeholder.bounds.size.height);
    
    // View 2
    self.v2 = [[View2 alloc]initWithFrame:CGRectZero];
    self.v2.frame = CGRectMake(placeholder.frame.origin.x, placeholder.frame.origin.y, placeholder.bounds.size.width, placeholder.bounds.size.height);
    
    // View 3
    self.v3 = [[View3 alloc]initWithFrame:CGRectZero];
    self.v3.frame = CGRectMake(placeholder.frame.origin.x, placeholder.frame.origin.y, placeholder.bounds.size.width, placeholder.bounds.size.height);
    
    // View 4
    self.v4 = [[View4 alloc]initWithFrame:CGRectZero];
    self.v4.frame = CGRectMake(placeholder.frame.origin.x, placeholder.frame.origin.y, placeholder.bounds.size.width, placeholder.bounds.size.height);
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundView1"]];
    [self.view addSubview:self.v1];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(knob1Moved) name:@"knob1Moved" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(knob2Moved) name:@"knob2Moved" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(knob3Moved) name:@"knob3Moved" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(knob4Moved) name:@"knob4Moved" object:nil];
    
    // It isn´t necessary to specificially add the placeholder view as subview.
    
    [self initParametersFromPlistInDocumentsFolder];
    
}

- (void)segmentedControlPressed:(UISegmentedControl*)sender
{
    [presetView removeFromSuperview];
    if ([sender selectedSegmentIndex] == 0) {
        [self.v2 removeFromSuperview];
        [self.v3 removeFromSuperview];
        [self.v4 removeFromSuperview];

        [self.view addSubview:self.v1];
        
    } else if ([sender selectedSegmentIndex] == 1) {
        [self.v1 removeFromSuperview];
        [self.v3 removeFromSuperview];
        [self.v4 removeFromSuperview];
        
        [self.view addSubview:self.v2];
        
    } else if ([sender selectedSegmentIndex] == 2) {
        [self.v1 removeFromSuperview];
        [self.v2 removeFromSuperview];
        [self.v4 removeFromSuperview];
        
        [self.view addSubview:self.v3];

    } else if ([sender selectedSegmentIndex] == 3) {
        [self.v1 removeFromSuperview];
        [self.v2 removeFromSuperview];
        [self.v3 removeFromSuperview];
        
        [self.view addSubview:self.v4];
    }
}

- (IBAction)presetButtonPressed:(id)sender
{
    if (presetView.superview == nil) {
        presetView = [[[NSBundle mainBundle] loadNibNamed:@"PresetView" owner:self options:nil] lastObject];
        int width = presetView.bounds.size.width;
        int height = presetView.bounds.size.height;
        [presetView setBackgroundColor:[UIColor whiteColor]];
        [presetView setFrame:CGRectMake(self.view.bounds.size.width - width - 20, 60, width, height)];
        [presetView.layer setCornerRadius:12];
        [presetView.layer setBorderWidth:1];
        [presetView.layer setBorderColor:[self.view.tintColor CGColor]];
        [self.view addSubview:presetView];
        [self.view bringSubviewToFront:presetView];
    }
}

- (void)knob1Moved
{
    knob1value = [NSNumber numberWithFloat:self.v1.mhKnob1.value];
    NSLog(@"%@", knob1value);
}

- (void)knob2Moved
{
    knob2value = [NSNumber numberWithFloat:self.v1.mhKnob2.value];
    NSLog(@"%@", knob2value);
}

- (void)knob3Moved
{
    knob3value = [NSNumber numberWithFloat:self.v1.mhKnob3.value];
    NSLog(@"%@", knob3value);
}

- (void)knob4Moved
{
    knob4value = [NSNumber numberWithFloat:self.v1.mhKnob4.value];
    NSLog(@"%@", knob4value);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInViewTableView:(UITableView*)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Presets";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myPresetArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.myPresetArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.myPresetArray removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *preset = [myPresetArray objectAtIndex:indexPath.row];
    [self setParametersFromPreset:preset];
}


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
    myPresetArray = [NSMutableArray arrayWithArray:tempArray];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:filePath]) {
        [fm createFileAtPath:filePath contents:nil attributes:nil];
        NSLog(@"Created new file");
    }
    
    [dict setObject:currentParameters forKey:@"PresetFoo"];
    [dict writeToFile:filePath atomically:YES];
    //-----------------------------------------------------------------------------------

    [self.myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.presetView removeFromSuperview];
    [self presetButtonPressed:nil];
}

- (void)initParametersFromPlistInDocumentsFolder
{
    // Documents folder path
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"presets.plist"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:destPath]) {
        [self copyPlistFromMainBundleToDocumentFolder];
        NSLog(@"Created new file");
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithContentsOfFile:destPath];
    NSArray* tempArray = [dict allKeys];
    myPresetArray = [NSMutableArray arrayWithArray:tempArray];

    [self.myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSMutableDictionary*)getDictFromFileInDocumentsDirectoryWithName:(NSString*)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, name];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    return dict;
}

- (void)setParametersFromPreset:(NSString*)presetName
{
    NSMutableDictionary* dict = [self getDictFromFileInDocumentsDirectoryWithName:@"presets.plist"];
    // Check if the given string actually exists in the dictionary
    if ([dict objectForKey:presetName]) {
        // Get the selected preset dictionary from the big dictionary
        NSDictionary* theParameters = [[NSDictionary alloc]initWithDictionary:[dict objectForKey:presetName]];
        self.v1.mhKnob1.value = [[theParameters valueForKey:@"knob1value"] floatValue];
        self.v1.mhKnob2.value = [[theParameters valueForKey:@"knob2value"] floatValue];
        self.v1.mhKnob3.value = [[theParameters valueForKey:@"knob3value"] floatValue];
        self.v1.mhKnob4.value = [[theParameters valueForKey:@"knob4value"] floatValue];
    }
}

- (NSMutableDictionary*)getDictOfCurrentParameters
{
    NSMutableDictionary* currentValues = [[NSMutableDictionary alloc]init];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.mhKnob1.value] forKey:@"knob1value"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.mhKnob2.value] forKey:@"knob2value"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.mhKnob3.value] forKey:@"knob3value"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.mhKnob4.value] forKey:@"knob4value"];
    return currentValues;
}

- (void)copyPlistFromMainBundleToDocumentFolder
{
    // Documents folder path
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"presets.plist"];
    
    // Main bundle path
    NSString* mainBundleFilePath = [[NSBundle mainBundle] pathForResource:@"defaultPresets" ofType:@"plist"];
    NSData *mainBundleFile = [NSData dataWithContentsOfFile:mainBundleFilePath];
    
    [[NSFileManager defaultManager] createFileAtPath:destPath
                                            contents:mainBundleFile
                                          attributes:nil];
    
//    // If the file doesn't exist in the Documents Folder, copy it.
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:destPath]) {
//        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"presets" ofType:@"plist"];
//        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
//    }

}

- (void)findAllUserPresetsNotInDefaultPresets
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTable selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
}


@end
