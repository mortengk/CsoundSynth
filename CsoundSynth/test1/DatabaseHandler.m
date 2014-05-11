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
@synthesize vc;

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
        vc = currentVC;
        NSLog(@"jfgh");

        
        //vc = [[MGKViewController alloc]init];
        
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
    NSLog(@"jfgh");
    
    
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
    
    //[self.myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


- (IBAction)saveCurrentParameterValuesToDict:(id)sender withName:(NSString*)name
{
    // NEW
    
    // 1. Check if defaultPresets.plist exists in the userdocument folder
    //    if not: copy defaultPresets.plist into user document folder, name it
    //      FINISHED!!!
    // 2. Check if
    
    
    // 1. Fill a dictionary with all parameters...
    NSDictionary *currentParameters = [self getDictOfCurrentParameters];
    NSLog(@"Save method...\nCurrent value of envelope attack: %f", vc.v1.envView.ampEnvelopeView.ampAttackKnob.value);
    [vc myTestMethod];
    NSLog(@"after...");

    
    
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
    
    [dict setObject:currentParameters forKey:name];
    [dict writeToFile:filePath atomically:YES];
    //-----------------------------------------------------------------------------------
    
    //[self.myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //[vc.presetView removeFromSuperview];
    [vc presetButtonPressed:nil];
    
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
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithContentsOfFile:destPath];
    NSArray* tempArray = [dict allKeys];
    myPresetArray = [NSMutableArray arrayWithArray:tempArray];

    [self.vc.myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSMutableDictionary*)getDictFromFileInDocumentsDirectoryWithName:(NSString*)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, name];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    return dict;
}


- (NSDictionary*)getPresetDictFromUserDocumentFolder
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory
                                        inDomains:NSUserDomainMask];
    if ([urls count] > 0){
        NSURL *documentsFolder = urls[0];
        NSURL* presetFilePath = [documentsFolder URLByAppendingPathComponent:@"presets.plist"];
        NSDictionary* dict = [[NSDictionary alloc]initWithContentsOfURL:presetFilePath];
        NSLog(@"GOT PRESET DICT FROM USER DOCUMENT FOLDER WITH CONTENTS: %@", dict);
        return dict;
    } else {
        NSLog(@"Could not find the Documents folder.");
    }
    return nil;
}

- (NSDictionary*)getPresetDictFromMainBundle
{
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSURL* url = [mainBundle URLForResource:@"defaultPresets" withExtension:@"plist"];

    if (url){
        NSDictionary* dict = [[NSDictionary alloc]initWithContentsOfURL:url];
        NSLog(@"Got preset dict from MAIN BUNDLE with contents: %@", dict);
        return dict;
    } else {
        NSLog(@"Could not find the preset plist.");
    }
    return nil;
}

- (void)setParametersFromPreset:(NSString*)presetName
{
    NSMutableDictionary* dict = [self getDictFromFileInDocumentsDirectoryWithName:@"presets.plist"];
    // Check if the given string actually exists in the dictionary
    if ([dict objectForKey:presetName]) {
        // Get the selected preset dictionary from the big dictionary
        NSDictionary* theParameters = [[NSDictionary alloc]initWithDictionary:[dict objectForKey:presetName]];
        vc.v1.envView.ampEnvelopeView.ampAttackKnob.value = [[theParameters valueForKey:@"ampAttack"] floatValue];
        vc.v1.envView.ampEnvelopeView.ampDecayKnob.value = [[theParameters valueForKey:@"ampDecay"] floatValue];
        vc.v1.envView.ampEnvelopeView.ampSustainKnob.value = [[theParameters valueForKey:@"ampSustain"] floatValue];
        vc.v1.envView.ampEnvelopeView.ampReleaseKnob.value = [[theParameters valueForKey:@"ampRelease"] floatValue];
        vc.v1.filterView.filterCutoffKnob.value = [[theParameters valueForKey:@"filterCutoff"] floatValue];
        vc.v1.filterView.filterResonanceKnob.value = [[theParameters valueForKey:@"filterResonance"] floatValue];
        vc.v1.envView.filterEnvelopeView.filterAttackKnob.value = [[theParameters valueForKey:@"filterAttack"] floatValue];
        vc.v1.envView.filterEnvelopeView.filterDecayKnob.value = [[theParameters valueForKey:@"filterDecay"] floatValue];
        vc.v1.envView.filterEnvelopeView.filterSustainKnob.value = [[theParameters valueForKey:@"filterSustain"] floatValue];
        vc.v1.envView.filterEnvelopeView.filterReleaseKnob.value = [[theParameters valueForKey:@"filterRelease"] floatValue];
        
        vc.v1.oscillator1SegmentedControl.selectedSegmentIndex = [[theParameters valueForKey:@"oscillator1SegmentedControl"] integerValue];
        vc.v1.oscillator2SegmentedControl.selectedSegmentIndex = [[theParameters valueForKey:@"oscillator2SegmentedControl"] integerValue];



        [vc updateCsoundValues];
    }
}

- (NSMutableDictionary*)getDictOfCurrentParameters
{
    NSMutableDictionary* currentValues = [[NSMutableDictionary alloc]init];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.envView.ampEnvelopeView.ampAttackKnob.value] forKey:@"ampAttack"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.envView.ampEnvelopeView.ampDecayKnob.value] forKey:@"ampDecay"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.envView.ampEnvelopeView.ampSustainKnob.value] forKey:@"ampSustain"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.envView.ampEnvelopeView.ampReleaseKnob.value] forKey:@"ampRelease"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.filterView.filterCutoffKnob.value] forKey:@"filterCutoff"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.filterView.filterResonanceKnob.value] forKey:@"filterResonance"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.envView.filterEnvelopeView.filterAttackKnob.value] forKey:@"filterAttack"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.envView.filterEnvelopeView.filterDecayKnob.value] forKey:@"filterDecay"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.envView.filterEnvelopeView.filterSustainKnob.value] forKey:@"filterSustain"];
    [currentValues setValue:[NSNumber numberWithFloat:self.vc.v1.envView.filterEnvelopeView.filterReleaseKnob.value] forKey:@"filterRelease"];
    
//    [currentValues setValue:[NSNumber numberWithInt:self.vc.v1.oscillator1SegmentedControl.selectedSegmentIndex] forKey:@"oscillator1SegmentedControl"];
//    [currentValues setValue:[NSNumber numberWithInt:self.vc.v1.oscillator2SegmentedControl.selectedSegmentIndex] forKey:@"oscillator2SegmentedControl"];

    NSLog(@"MGKViewController:\n%@, View: %@", currentValues, self.vc.v1);
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
