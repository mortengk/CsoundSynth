//
//  DatabaseHandler.m
//  test1
//
//  Created by Morten Kleveland on 11.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "DatabaseHandler.h"
#import "MGKViewController.h"
#import "View1.h"

@implementation DatabaseHandler

@synthesize myPresetArray;
@synthesize userPresetArray;
@synthesize mainViewController;

NSString* USER_PRESETS = @"userPresets";
NSString* DEFAULT_PRESETS = @"defaultPresets";
NSString* ALL_PRESETS = @"allPresets";

- (DatabaseHandler*)init
{
    self = [super init];
    if (self) {
        [self initParametersFromPlistInDocumentsFolder];
    }
    return self;
}

- (DatabaseHandler*)initWithViewController:(MGKViewController*)currentVC
{
    self = [super init];
    if (self) {
        // THE FOLLOWING IS POTENTIALLY DANGEROUS (FOR HUMANITY)
        // Uncomment the following line to update presets.plist whenever defaultPresets.plist has been edited manually.
        //[self copyPlistFromMainBundleToDocumentFolder];
        [self initParametersFromPlistInDocumentsFolder];
        NSLog(@"%@", [self getPresetDictFromUserDocumentFolder]);
        NSLog(@"%@", [self getPresetDictFromMainBundle]);
    }
    return self;
}

- (IBAction)saveCurrentParameterValuesToDict:(id)sender
{
    // NEW
    
    // 1. Check if defaultPresets.plist exists in the userdocument folder
    //    if not: copy defaultPresets.plist into user document folder, name it
    //      FINISHED!!!
    // 2. Check if
    
    
    // 1. Fill a dictionary with all parameters...
    NSDictionary *currentParameters = [self getDictOfCurrentParameters];
    
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
    
}


- (IBAction)saveCurrentParameterValuesToDict:(id)sender withName:(NSString*)name
{
    // NEW
    
    // 1. Check if defaultPresets.plist exists in the userdocument folder
    //    if not: copy defaultPresets.plist into user document folder, name it
    //      FINISHED!!!
    // 2. Check if
    
    
    // 1. Fill a dictionary with all parameters...
    NSDictionary *currentParameters = [mainViewController getDictOfCurrentParameters];
    NSLog(@"currentParameters dict: %@", currentParameters);
    
    //-----------------------------------------------------------------------------------
    // IMPORTANT SHIT
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"presets.plist"];
    
    self.dict = [self getPresetDictFromUserDocumentFolder];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:filePath]) {
        [fm createFileAtPath:filePath contents:nil attributes:nil];
        NSLog(@"Created new file");
    }
    
    [self.dict setObject:currentParameters forKey:name];
    [self.dict writeToFile:filePath atomically:YES];
    
    NSArray* tempArray = [self.dict allKeys];
    
    // Sort the array
    tempArray = [tempArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    myPresetArray = [NSMutableArray arrayWithArray:tempArray];

    //-----------------------------------------------------------------------------------
    
    //[self.myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //[mainViewController.presetView removeFromSuperview];
    [mainViewController presetButtonPressed:nil];
    
    //[mainViewController.presetViewController updateTableView];
    [mainViewController.presetViewController.myTable reloadData];
    
}


- (void)initParametersFromPlistInDocumentsFolder
{
    // Documents folder path
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"presets.plist"];
    
    [self printContentOfDocumentsFolder];


    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:destPath]) {
        [self copyPlistFromMainBundleToDocumentFolder];
        NSLog(@"Created new file");
    }
    self.dict = [[NSMutableDictionary alloc]initWithContentsOfFile:destPath];
    NSArray* tempArray = [self.dict allKeys];
    myPresetArray = [NSMutableArray arrayWithArray:tempArray];

    //[self.mainViewController.myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSMutableDictionary*)getDictFromFileInDocumentsDirectoryWithName:(NSString*)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, name];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    return dict;
}


- (NSMutableDictionary*)getPresetDictFromUserDocumentFolder
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory
                                        inDomains:NSUserDomainMask];
    if ([urls count] > 0){
        NSURL *documentsFolder = urls[0];
        NSURL* presetFilePath = [documentsFolder URLByAppendingPathComponent:@"presets.plist"];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithContentsOfURL:presetFilePath];
        //NSLog(@"GOT PRESET DICT FROM USER DOCUMENT FOLDER WITH CONTENTS: %@", dict);
        return dict;
    } else {
        NSLog(@"Could not find the Documents folder.");
    }
    return nil;
}

- (NSMutableDictionary*)getPresetDictFromMainBundle
{
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSURL* url = [mainBundle URLForResource:@"defaultPresets" withExtension:@"plist"];

    if (url){
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithContentsOfURL:url];
        NSLog(@"Got preset dict from MAIN BUNDLE with contents: %@", dict);
        return dict;
    } else {
        NSLog(@"Could not find the preset plist.");
    }
    return nil;
}

- (void)setParametersFromPreset:(NSString*)presetName
{
    NSDictionary* dict = [self getPresetDictFromUserDocumentFolder];
    // Check if the given string actually exists in the dictionary
    if ([dict objectForKey:presetName]) {
        // Get the selected preset dictionary from the big dictionary
        NSDictionary* theParameters = [[NSDictionary alloc]initWithDictionary:[dict objectForKey:presetName]];
        mainViewController.v1.envView.ampEnvelopeView.ampAttackKnob.value = [[theParameters valueForKey:@"ampAttack"] floatValue];
        mainViewController.v1.envView.ampEnvelopeView.ampDecayKnob.value = [[theParameters valueForKey:@"ampDecay"] floatValue];
        mainViewController.v1.envView.ampEnvelopeView.ampSustainKnob.value = [[theParameters valueForKey:@"ampSustain"] floatValue];
        mainViewController.v1.envView.ampEnvelopeView.ampReleaseKnob.value = [[theParameters valueForKey:@"ampRelease"] floatValue];
        mainViewController.v1.filterView.filterCutoffKnob.value = [[theParameters valueForKey:@"filterCutoff"] floatValue];
        mainViewController.v1.filterView.filterResonanceKnob.value = [[theParameters valueForKey:@"filterResonance"] floatValue];
        mainViewController.v1.envView.filterEnvelopeView.filterAttackKnob.value = [[theParameters valueForKey:@"filterAttack"] floatValue];
        mainViewController.v1.envView.filterEnvelopeView.filterDecayKnob.value = [[theParameters valueForKey:@"filterDecay"] floatValue];
        mainViewController.v1.envView.filterEnvelopeView.filterSustainKnob.value = [[theParameters valueForKey:@"filterSustain"] floatValue];
        mainViewController.v1.envView.filterEnvelopeView.filterReleaseKnob.value = [[theParameters valueForKey:@"filterRelease"] floatValue];
        mainViewController.v1.envView.pitchEnvelopeView.attackKnob.value = [[theParameters valueForKey:@"pitchAttack"] floatValue];
        mainViewController.v1.envView.pitchEnvelopeView.decayKnob.value = [[theParameters valueForKey:@"pitchDecay"] floatValue];
        mainViewController.v1.envView.pitchEnvelopeView.sustainKnob.value = [[theParameters valueForKey:@"pitchSustain"] floatValue];
        mainViewController.v1.envView.pitchEnvelopeView.releaseKnob.value = [[theParameters valueForKey:@"pitchRelease"] floatValue];
        
        mainViewController.v1.oscillator1SegmentedControl.selectedSegmentIndex = [[theParameters valueForKey:@"oscillator1SegmentedControl"] doubleValue];
        mainViewController.v1.oscillator2SegmentedControl.selectedSegmentIndex = [[theParameters valueForKey:@"oscillator2SegmentedControl"] doubleValue];

        [mainViewController updateCsoundValues];
    }
}

- (NSMutableDictionary*)getDictOfCurrentParameters
{
    NSMutableDictionary* currentValues = [[NSMutableDictionary alloc]init];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.ampEnvelopeView.ampAttackKnob.value] forKey:@"ampAttack"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.ampEnvelopeView.ampDecayKnob.value] forKey:@"ampDecay"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.ampEnvelopeView.ampSustainKnob.value] forKey:@"ampSustain"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.ampEnvelopeView.ampReleaseKnob.value] forKey:@"ampRelease"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.filterView.filterCutoffKnob.value] forKey:@"filterCutoff"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.filterView.filterResonanceKnob.value] forKey:@"filterResonance"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.filterEnvelopeView.filterAttackKnob.value] forKey:@"filterAttack"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.filterEnvelopeView.filterDecayKnob.value] forKey:@"filterDecay"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.filterEnvelopeView.filterSustainKnob.value] forKey:@"filterSustain"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.filterEnvelopeView.filterReleaseKnob.value] forKey:@"filterRelease"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.pitchEnvelopeView.attackKnob.value] forKey:@"pitchAttack"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.pitchEnvelopeView.decayKnob.value] forKey:@"pitchDecay"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.pitchEnvelopeView.sustainKnob.value] forKey:@"pitchSustain"];
    [currentValues setValue:[NSNumber numberWithFloat:self.mainViewController.v1.envView.pitchEnvelopeView.releaseKnob.value] forKey:@"pitchRelease"];
    
    [currentValues setValue:[NSNumber numberWithInt:self.mainViewController.v1.oscillator1Slider.value] forKey:@"oscillator1SegmentedControl"];
    [currentValues setValue:[NSNumber numberWithInt:self.mainViewController.v1.oscillator2Slider.value] forKey:@"oscillator2SegmentedControl"];

    NSLog(@"MGKViewController:\n%@, View: %@", currentValues, self.mainViewController.v1);
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
}

- (void)findAllUserPresetsNotInDefaultPresets
{
    
}

- (void)printContentOfDocumentsFolder
{
    NSFileManager *filemgr;
    NSArray *filelist;
    long count;
    int i;
    
    filemgr =[NSFileManager defaultManager];
    filelist = [filemgr contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] error:NULL];
    count = [filelist count];
    
    for (i = 0; i < count; i++)
        NSLog(@"%@", [filelist objectAtIndex: i]);
    
}


@end
