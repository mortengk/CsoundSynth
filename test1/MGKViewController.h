//
//  MGKViewController.h
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "DatabaseHandler.h"
#import <UIKit/UIKit.h>
#import "KeyboardView.h"
#import "View1.h"
#import "View2.h"
#import "View3.h"
#import "View4.h"
#import "View5.h"
#import "CsoundObj.h"
#import "MidiWidgetsManager.h"
#import "PGMidi.h"
#import "MGKPresetViewController.h"
#import "MGKSoundfontSelectionViewController.h"
#import <AVFoundation/AVFoundation.h>


@class TouchForwardingUIScrollView;
@class View4;
@class PresetView;
@class MGKPresetViewController;
@class MGKSoundfontSelectionViewController;
@class DatabaseHandler;

@interface MGKViewController : UIViewController <KeyboardDelegate, CsoundObjCompletionListener, AVAudioPlayerDelegate, UIPopoverControllerDelegate> {
    CsoundObj* mCsound;
    @private
    TouchForwardingUIScrollView* keyboardScrollView;
    KeyboardView* keyboardView;
}

// Csound
@property (nonatomic, strong) CsoundObj* csound;
@property (nonatomic, strong) MidiWidgetsManager* widgetsManager;
@property (nonatomic) BOOL isPolyphonic;

- (IBAction)polyphonySwitch:(id)sender;
- (void)updateCsoundValues;
- (void)noteOn:(int)note;
- (void)noteOff:(int)note;


// Midi
@property (nonatomic, strong) PGMidi *midiConnection;


// Motion
@property (nonatomic, strong) CMMotionManager* motionManager;
@property (nonatomic) double gravityX;
@property (nonatomic) double gravityY;
@property (nonatomic) double gravityZ;
@property (nonatomic) double magneticFieldX;
@property (nonatomic) double magneticFieldY;
@property (nonatomic) double magneticFieldZ;
@property (nonatomic) double accelerometerX;
@property (nonatomic) double accelerometerY;
@property (nonatomic) double accelerometerZ;


// Mod matrix
@property (nonatomic, strong) NSMutableArray* controlDestinations;
@property (nonatomic, strong) NSMutableArray* controlSources;


// Soundfont
@property (nonatomic, strong) MGKSoundfontSelectionViewController* soundfontSelectionViewController;
@property (strong, nonatomic) UIPopoverController *soundfontPopoverController;

- (IBAction)showSoundfontPresets:(UIButton *)sender;


// GUI
@property (nonatomic, retain) IBOutlet UIView *pView;
@property (nonatomic, retain) IBOutlet UIScrollView *keyboardScrollView;
@property (nonatomic, weak) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet UIButton *presetButton;
@property (strong, nonatomic) IBOutlet UISwitch *lockSwitch;
@property (nonatomic, strong) View1 *v1;
@property (nonatomic, retain) View2 *v2;
@property (nonatomic, retain) View3 *v3;
@property (nonatomic, retain) View4 *v4;
@property (nonatomic, strong) View5 *v5;
@property (nonatomic) BOOL isRecording;

- (IBAction)segmentedControlPressed:(id)sender;
- (IBAction)presetButtonPressed:(id)sender;
- (IBAction)scrollLockButton:(UISwitch*)sender;
- (IBAction)octaveDownButtonPressed:(UIButton *)sender;
- (IBAction)octaveUpButtonPressed:(UIButton *)sender;
- (IBAction)stepperPressed:(UIStepper*)sender;
- (void)startMotionManager;
- (void)record;

// Database
@property (nonatomic, strong) DatabaseHandler* databaseHandler;
@property (nonatomic, strong) NSMutableArray* myTestArray;

- (void)myTestMethod;
- (NSMutableDictionary*)getDictOfCurrentParameters;


@property (strong, nonatomic) MGKPresetViewController* presetViewController;
@property (strong, nonatomic) MGKSoundfontSelectionViewController* soundfontViewController;
@property (nonatomic, strong) NSString* selectedPreset;

- (void)changeSoundfontInstrumentTo:(NSString*)numberString;

@end
