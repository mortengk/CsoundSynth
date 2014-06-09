//
//  MGKViewController.m
//  test1
//
//  Created by Morten Kleveland on 22.01.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "MGKViewController.h"
#import "TouchForwardingUIScrollView.h"
#import "CachedCustomKnob.h"
#import "CachedUISegmentedControl.h"
#import <CoreMIDI/CoreMIDI.h>
#import "Audiobus.h"

#define DESTINATION_ADDRESS @"169.254.253.0"

@interface MGKViewController ()

-(void)connectToHost;
-(void)sendStatus:(Byte)status data1:(Byte)data1 data2:(Byte)data2;
-(void)sendNoteOnEvent:(Byte)key velocity:(Byte)velocity;
-(void)sendNoteOffEvent:(Byte)key velocity:(Byte)velocity;
@property (assign) MIDINetworkSession *midiSession;
@property (assign) MIDIEndpointRef destinationEndPoint;
@property (assign) MIDIPortRef outputPort;
@property (strong, nonatomic) ABAudiobusController *audiobusController;
@property (strong, nonatomic) ABAudiobusAudioUnitWrapper *audiobusAudioUnitWrapper;
@property (strong, nonatomic) ABOutputPort *output;
@end

// Sources
NSString* noneString = @"None";
NSString* gravityXAxisString = @"Gravity x-axis";
NSString* gravityYAxisString = @"Gravity y-axis";
NSString* gravityZAxisString = @"Gravity z-axis";
NSString* magneticFieldXAxisString = @"Magnetic field x-axis";
NSString* magneticFieldYAxisString = @"Magnetic field y-axis";
NSString* magneticFieldZAxisString = @"Magnetic field z-axis";
NSString* accelerometerXAxisString = @"Acceleration x-axis";
NSString* accelerometerYAxisString = @"Acceleration y-axis";
NSString* accelerometerZAxisString = @"Acceleration z-axis";

double* sourceTable1Pointer;
double *sourcePointerArray[8];

// Destinations
NSString* oscillator1FineTuneString = @"Oscillator 1 finetune";
NSString* oscillator2FineTuneString = @"Oscillator 2 finetune";
NSString* filterCutoffString = @"Filter cutoff";
NSString* filterResonanceString = @"Filter resonance";
NSString* LFOAmpString = @"LFO amplitude";
NSString* LFOFreqString = @"LFO frequency";
NSString* reverbMixString = @"Reverb mix";
NSString* reverbRoomsizeString = @"Reverb room size";
NSString* phaserSpeedString = @"Phaser speed";

@implementation MGKViewController

@synthesize keyboardScrollView;
@synthesize csound = mCsound;
@synthesize widgetsManager;
@synthesize v1;
@synthesize v5;
@synthesize databaseHandler;
@synthesize presetButton;
@synthesize isRecording;
@synthesize isPolyphonic;

// Motion variables
@synthesize motionManager;
@synthesize gravityX;
@synthesize gravityY;
@synthesize gravityZ;
@synthesize magneticFieldX;
@synthesize magneticFieldY;
@synthesize magneticFieldZ;
@synthesize accelerometerX;
@synthesize accelerometerY;
@synthesize accelerometerZ;

@synthesize controlDestinations;
@synthesize controlSources;

// Soundfont-popover
@synthesize soundfontOscillator1SelectionViewController;
@synthesize soundfontOscillator2SelectionViewController;
@synthesize soundfontPopoverController;

// FM-popover
@synthesize FMOscillator1SelectionViewController;
@synthesize FMOscillator2SelectionViewController;
@synthesize FMPopoverController;

// Audiobus
@synthesize audiobusController = _audiobusController;
@synthesize output = _output;
@synthesize audiobusAudioUnitWrapper;

// MIDI
@synthesize midiSession;
@synthesize destinationEndPoint;
@synthesize outputPort;
@synthesize midiConnection;

int NUMBER_OF_OSCILLATORS = 5;
int OCTAVE_WIDTH = 500;
int NUMBER_OF_OCTAVES = 8;
float lastStepperValue = 0;
NSString* CURRENT_INSTRUMENT_OSC1;
NSString* CURRENT_INSTRUMENT_OSC2;
NSInteger CURRENT_INSTRUMENT_OSC1_INT;
double CURRENT_INSTRUMENT_OSC1_NUMBER;
NSInteger CURRENT_INSTRUMENT_OSC2_INT;

- (void)viewDidLoad
{
    sourceTable1Pointer = &gravityX;
    for (int i = 0; i < 8; i++) {
        sourcePointerArray[i] = &gravityX;
    }
    
    [self initKeyboardViewWithWidth:OCTAVE_WIDTH over:NUMBER_OF_OCTAVES];
    databaseHandler = [[DatabaseHandler alloc]initWithViewController:self];
    //NSLog(@"MYPRESETARRAY:: \n%@", databaseHandler.myPresetArray);
    [super viewDidLoad];
    [self startMotionManager];
    [self initControlSources];
    [self initViews];
    [self initPopoverViewControllersAndKnobs];
    [self initTableViewDictionaries];
    [self initOscillatorTouchRecognizers];
    //[self initMidi];
    
    isRecording = NO;
    //NSLog(@"MYPRESETARRAY:: \n%@", databaseHandler.myPresetArray);
    self.selectedPreset = @"INIT";

    // It isn´t necessary to specificially add the placeholder view as a subview.
    
    [widgetsManager openMidiIn];

    NSString *tempFile = [[NSBundle mainBundle] pathForResource:@"midiTest" ofType:@"csd"];
    NSLog(@"FILE PATH: %@", tempFile);
    CURRENT_INSTRUMENT_OSC1 = @"1";
    CURRENT_INSTRUMENT_OSC2 = @"11";
    CURRENT_INSTRUMENT_OSC1_INT = 1;
    CURRENT_INSTRUMENT_OSC1_NUMBER = 1;
    CURRENT_INSTRUMENT_OSC2_INT = 11;
    
    isPolyphonic = NO;

    [self.csound stopCsound];
    self.csound = [[CsoundObj alloc] init];
    [self.csound addCompletionListener:self];
    [self.csound setMessageCallback:@selector(messageCallback:) withListener:self];
    
    [self.csound addSlider:v1.oscView.oscillator1Slider forChannelName:@"oscillator1State"];
    [self.csound addSlider:v1.oscView.oscillator2Slider forChannelName:@"oscillator2State"];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.oscView.oscillator1FineTuneKnob channelName:@"oscil1FineTune"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.oscView.oscillator1AmplitudeKnob channelName:@"oscil1Amp"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.oscView.oscillator1ModKnob channelName:@"oscil1Mod"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.oscView.oscillator1Mod2Knob channelName:@"oscil1Mod2"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.oscView.oscillator1FatnessKnob channelName:@"oscil1Fatness"]];

    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.oscView.oscillator2FineTuneKnob channelName:@"oscil2FineTune"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.oscView.oscillator2TuneKnob channelName:@"oscil2Tune"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.oscView.oscillator2AmplitudeKnob channelName:@"oscil2Amp"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.oscView.oscillator2ModKnob channelName:@"oscil2Mod"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.oscView.oscillator2Mod2Knob channelName:@"oscil2Mod2"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.oscView.oscillator2FatnessKnob channelName:@"oscil2Fatness"]];

    [self.csound addSlider:v1.envView.ampEnvelopeView.ampAttackKnob forChannelName:@"attack"];
    [self.csound addSlider:v1.envView.ampEnvelopeView.ampDecayKnob forChannelName:@"decay"];
    [self.csound addSlider:v1.envView.ampEnvelopeView.ampSustainKnob forChannelName:@"sustain"];
    [self.csound addSlider:v1.envView.ampEnvelopeView.ampReleaseKnob forChannelName:@"release"];
    
    [self.csound addSlider:v1.envView.pitchEnvelopeView.attackKnob forChannelName:@"pitchAttack"];
    [self.csound addSlider:v1.envView.pitchEnvelopeView.decayKnob forChannelName:@"pitchDecay"];
    [self.csound addSlider:v1.envView.pitchEnvelopeView.sustainKnob forChannelName:@"pitchSustain"];
    [self.csound addSlider:v1.envView.pitchEnvelopeView.releaseKnob forChannelName:@"pitchRelease"];
    
    [self.csound addValueCacheable:[[CachedUISegmentedControl alloc]init:v1.filterView.filterSegmentedControl channelName:@"filterType"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.filterView.filterCutoffKnob channelName:@"filterCutoff"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.filterView.filterResonanceKnob channelName:@"filterResonance"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.filterView.filterEnvAmtKnob channelName:@"filterEnvAmt"]];
    
    [self.csound addSlider:v1.envView.filterEnvelopeView.filterAttackKnob forChannelName:@"filterAttack"];
    [self.csound addSlider:v1.envView.filterEnvelopeView.filterDecayKnob forChannelName:@"filterDecay"];
    [self.csound addSlider:v1.envView.filterEnvelopeView.filterSustainKnob forChannelName:@"filterSustain"];
    [self.csound addSlider:v1.envView.filterEnvelopeView.filterReleaseKnob forChannelName:@"filterRelease"];
    
    [self.csound addValueCacheable:[[CachedUISegmentedControl alloc]init:v1.lfoView.lfoSegmentedControl channelName:@"lfoType"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.lfoView.lfoAmpKnob channelName:@"lfoAmp"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.lfoView.lfoFreqKnob channelName:@"lfoFreq"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v1.lfoView.lfoDelayKnob channelName:@"lfoDelay"]];
    
    [self.csound addSwitch:v5.distortionView.distSwitch forChannelName:@"distState"];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.distortionView.distGainKnob channelName:@"distGain"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.distortionView.distMixKnob channelName:@"distMix"]];
    
    [self.csound addSwitch:v5.phaserView.phaserSwitch forChannelName:@"phaserState"];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.phaserView.phaserFreqKnob channelName:@"phaserFreq"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.phaserView.phaserFeedbackKnob channelName:@"phaserFeed"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.phaserView.phaserMixKnob channelName:@"phaserMix"]];
    
    [self.csound addSwitch:v5.reverbView.reverbSwitch forChannelName:@"reverbState"];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.reverbView.reverbRoomSizeKnob channelName:@"reverbRoomSize"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.reverbView.reverbFreqKnob channelName:@"reverbFreq"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.reverbView.reverbMixKnob channelName:@"reverbMix"]];
    
    [self.csound addSwitch:v5.chorusView.powerSwitch forChannelName:@"chorusState"];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.chorusView.param1Knob channelName:@"chorusFreq"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.chorusView.param2Knob channelName:@"chorusDepth"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.chorusView.param3Knob channelName:@"chorusWidth"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.chorusView.mixKnob channelName:@"chorusMix"]];
    
    [self.csound addSwitch:v5.delayView.powerSwitch forChannelName:@"delayState"];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.delayView.param1Knob channelName:@"delayTime"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.delayView.param2Knob channelName:@"delayFeedback"]];
    [self.csound addValueCacheable:[[CachedCustomKnob alloc]init:v5.delayView.mixKnob channelName:@"delayMix"]];
    
    [self.csound startCsound:tempFile];

    self.stepper.minimumValue = 0;
    self.stepper.maximumValue = NUMBER_OF_OCTAVES;
    self.stepper.autorepeat = YES;
    self.stepper.wraps = NO;
    
    // init keyboard view in the mid keyboard range
    for (int i = 0; i < 4; i++) {
        [self octaveUpButtonPressed:nil];
        self.stepper.value++;
        lastStepperValue++;
    }
    [self.lockSwitch setOn:YES];
    [self.keyboardScrollView setScrollEnabled:NO];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modMatrixSourceUpdated:) name:@"modMatrixSourceCellPressed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modMatrixDestinationUpdated:) name:@"modMatrixDestinationCellPressed" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateDestinationSourceValues) name:@"cellPressed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateDestinationSourceValues) name:@"destinationValuesUpdated" object:nil];
    
    //[v5.reverbView.reverbSwitch addTarget:self action:@selector(updateCsoundValues) forControlEvents:UIControlEventValueChanged];
    //[v1.filterSegmentedControl addTarget:self action:@selector(filterTypeChanged) forControlEvents:UIControlEventValueChanged];
    
    // Init oscillators
    [self.v1.oscillator1SegmentedControl setSelectedSegmentIndex:0];
    [self.v1.oscillator2SegmentedControl setSelectedSegmentIndex:3];
    [self.v1 oscillator1Changed:self.v1.oscillator1SegmentedControl];
    [self.v1 oscillator2Changed:self.v1.oscillator2SegmentedControl];
    
    self.csound.midiInEnabled = YES;
    self.csound.useAudioInput = NO;
    
//    NSURL *soundfontURL = [[NSURL alloc]initFileURLWithPath:@"Zelda_3.sf2"];
//    NSLog(@"%@", [self getSoundfontPresets:soundfontURL]);
    
    //[self connectToHost];
    [self polyphonySwitch:nil];
    self.polyphonySwitcher.on = NO;
    
}

- (void)initViews
{
    // Placeholder view
    UIView *placeholder = [[UIView alloc]initWithFrame:CGRectZero];
    placeholder = [self.pView initWithFrame:CGRectZero];
    
    //LINE OF DOOM 1
    placeholder.backgroundColor = [UIColor clearColor];
    
    // View 1
    v1 = [[View1 alloc]initWithFrame:CGRectZero];
    // Setting the view position to the placeholder position
    v1.frame = CGRectMake(placeholder.frame.origin.x, placeholder.frame.origin.y, placeholder.bounds.size.width, placeholder.bounds.size.height);
    // init view1
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_grey"]];
    [self.view addSubview:v1];
    v1.alpha = 0;

    
    // View 2
    self.v2 = [[View2 alloc]initWithFrame:CGRectZero];
    self.v2.frame = CGRectMake(placeholder.frame.origin.x, placeholder.frame.origin.y, placeholder.bounds.size.width, placeholder.bounds.size.height);
    
    // View 3
    self.v3 = [[View3 alloc]initWithFrame:CGRectZero];
    self.v3.frame = CGRectMake(placeholder.frame.origin.x, placeholder.frame.origin.y, placeholder.bounds.size.width, placeholder.bounds.size.height);
    
    // View 4
    self.v4 = [[View4 alloc]initWithFrame:CGRectZero];
    self.v4.frame = CGRectMake(placeholder.frame.origin.x, placeholder.frame.origin.y, placeholder.bounds.size.width, placeholder.bounds.size.height);
    
    // View 5
    self.v5 = [[View5 alloc]initWithFrame:CGRectZero];
    self.v5.frame = CGRectMake(placeholder.frame.origin.x, placeholder.frame.origin.y, placeholder.bounds.size.width, placeholder.bounds.size.height);
    
    [UIView animateWithDuration:1 delay:.5 options:UIViewAnimationOptionTransitionNone animations:^{
        v1.alpha = 1.0;
    } completion:nil];
}

- (void)segmentedControlPressed:(UISegmentedControl*)sender
{
    if ([sender selectedSegmentIndex] == 0) {
        [self.v2 removeFromSuperview];
        [self.v3 removeFromSuperview];
        [self.v4 removeFromSuperview];
        [self.v5 removeFromSuperview];

        [self.view addSubview:v1];
        
    } else if ([sender selectedSegmentIndex] == 1) {
        [self.v1 removeFromSuperview];
        [self.v3 removeFromSuperview];
        [self.v4 removeFromSuperview];
        [self.v5 removeFromSuperview];

        [self.view addSubview:self.v2];
        
    } else if ([sender selectedSegmentIndex] == 2) {
        [self.v1 removeFromSuperview];
        [self.v2 removeFromSuperview];
        [self.v4 removeFromSuperview];
        [self.v5 removeFromSuperview];

        [self.view addSubview:self.v3];

    } else if ([sender selectedSegmentIndex] == 3) {
        [self.v1 removeFromSuperview];
        [self.v2 removeFromSuperview];
        [self.v3 removeFromSuperview];
        [self.v5 removeFromSuperview];

        [self.view addSubview:self.v4];
        
    } else if ([sender selectedSegmentIndex] == 4) {
        [self.v1 removeFromSuperview];
        [self.v2 removeFromSuperview];
        [self.v3 removeFromSuperview];
        [self.v4 removeFromSuperview];

        [self.view addSubview:self.v5];
    }
}

- (void)initAudiobus
{
    // Create an Audiobus instance
    self.audiobusController = [[ABAudiobusController alloc] initWithAppLaunchURL:[NSURL URLWithString:@"test1.audiobus://"]
                                                                           apiKey:@"MTM5OTE2Mjg3MSoqKnRlc3QxKioqdGVzdDEuYXVkaW9idXM6Ly8=:HyEKtliJLU2SSfwTnpzNUG26EYlJysczrsB4UYCz3dzEemNdyrkKA1ndo0pEkqgdwWeNRPLni3KHQ6t9t0hkvn3mTOLMMqP7HsXhZekgBCRA5IqPOE1OQ1LoS5BbOFJb"];
    
    self.audiobusController.connectionPanelPosition = ABAudiobusConnectionPanelPositionLeft;

//    AudioUnit au = *[self.csound getAudioUnit];
//
//    ABOutputPort *output = [self.audiobusController addOutputPortNamed:@"Audio Output" title:NSLocalizedString(@"Main App Output", @"")];
//    
//    self.audiobusAudioUnitWrapper = [[ABAudiobusAudioUnitWrapper alloc]
//                                     initWithAudiobusController:self.audiobusController
//                                     audioUnit:au
//                                     output:output
//                                     input:nil];
//    NSLog(@"AUDIOBUS: %@", self.audiobusAudioUnitWrapper);
}


#pragma mark KeyboardView

- (void)initKeyboardViewWithWidth:(int)width over:(int)NUMBER_OF_OCTAVES
{
    CGRect keyboardViewFrame;
    keyboardViewFrame.origin.x = 0;
    keyboardViewFrame.origin.y = 0;
    keyboardViewFrame.size.width = width * NUMBER_OF_OCTAVES;
    // Leave some empty space for scrolling
    keyboardViewFrame.size.height = keyboardScrollView.frame.size.height - 10;
    keyboardView = [[KeyboardView alloc] initWithFrame:keyboardViewFrame withOctaveCount:NUMBER_OF_OCTAVES];
    [keyboardView setKeyboardDelegate:self];
    [keyboardScrollView addSubview:keyboardView];
    [keyboardScrollView setContentSize:keyboardView.frame.size];
    [keyboardScrollView setScrollEnabled:YES];
    [self.view bringSubviewToFront:keyboardScrollView];
    
    // Forward touch events to the keyboard
    [keyboardScrollView setTouchView:keyboardView];
}

- (void)noteOff:(int)keyNum
{
    int midikey = keyNum;
	//[mCsound sendScore:[NSString stringWithFormat:@"i-%@.%003d 0 0", CURRENT_INSTRUMENT_OSC1, midikey]];
    //[mCsound sendScore:[NSString stringWithFormat:@"i-%@.%003d 0 0", CURRENT_INSTRUMENT_OSC2, midikey]];
    //[mCsound sendScore:[NSString stringWithFormat:@"i-1.%003d 0 0", midikey]];
    if (isPolyphonic) {
        [mCsound sendScore:[NSString stringWithFormat:@"i-1.%003d 0 0", midikey]];
    } else {
        NSLog(@"Monophonic MOno, mono");
        [mCsound sendScore:[NSString stringWithFormat:@"i-5.%003d 0 0", midikey]];
    }
}

- (void)noteOn:(int)keyNum
{
    int midikey = keyNum;
    // NSInteger note = midikey;
    //[self sendNoteOnEvent:(Byte)note velocity:127];
//	[mCsound sendScore:[NSString stringWithFormat:@"i%@.%003d 0 -2 %d 0", CURRENT_INSTRUMENT_OSC1, midikey, midikey]];
//    [mCsound sendScore:[NSString stringWithFormat:@"i%@.%003d 0 -2 %d 0", CURRENT_INSTRUMENT_OSC2, midikey, midikey]];
    
    if (isPolyphonic) {
        NSLog(@"Note on, polyphonic");
        [mCsound sendScore:[NSString stringWithFormat:@"i1.%003d 0 -2 %d 0", midikey, midikey]];
    } else {
        NSLog(@"Note on, mono");

        [mCsound sendScore:[NSString stringWithFormat:@"i5.%003d 0 -2 %d 0", midikey, midikey]];
    }
}

- (IBAction)scrollLockButton:(UISwitch*)sender
{
    if ([keyboardScrollView isScrollEnabled]) {
        keyboardScrollView.scrollEnabled = NO;
    } else {
        keyboardScrollView.scrollEnabled = YES;
    }
    //NSLog(@"%@", NSStringFromCGPoint(keyboardScrollView.contentOffset));
}

- (IBAction)stepperPressed:(UIStepper*)sender
{
    if (sender.value > lastStepperValue) {
        [self octaveUpButtonPressed:nil];
        lastStepperValue++;
    } else {
        [self octaveDownButtonPressed:nil];
        lastStepperValue--;
    }
}

- (IBAction)octaveDownButtonPressed:(UIButton *)sender
{
    NSInteger currentXPosition = keyboardScrollView.contentOffset.x;
    if (currentXPosition <= OCTAVE_WIDTH) {
        currentXPosition = OCTAVE_WIDTH;
    }
    keyboardScrollView.contentOffset = CGPointMake(currentXPosition - OCTAVE_WIDTH, 0);
}

- (IBAction)octaveUpButtonPressed:(UIButton *)sender
{
    NSInteger currentXPosition = keyboardScrollView.contentOffset.x;
    if (currentXPosition + OCTAVE_WIDTH >= OCTAVE_WIDTH * NUMBER_OF_OCTAVES - keyboardScrollView.bounds.size.width) {
        currentXPosition = OCTAVE_WIDTH * NUMBER_OF_OCTAVES - keyboardScrollView.bounds.size.width - OCTAVE_WIDTH;
    }
    keyboardScrollView.contentOffset = CGPointMake(currentXPosition + OCTAVE_WIDTH, 0);
}


#pragma mark Csound

- (void)csoundObjDidStart:(CsoundObj *)csoundObj
{
}


- (void)csoundObjComplete:(CsoundObj *)csoundObj
{
	//[mSwitch setOn:NO animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTable selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    //[self initAudiobus];
}


- (void)updateCsoundValues
{
    [v1.oscView.oscillator1Slider sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.oscView.oscillator1FineTuneKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.oscView.oscillator1ModKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.oscView.oscillator1Mod2Knob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.oscView.oscillator1AmplitudeKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.oscView.oscillator1FatnessKnob sendActionsForControlEvents:UIControlEventValueChanged];
    
    [v1.oscView.oscillator2Slider sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.oscView.oscillator2FineTuneKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.oscView.oscillator2TuneKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.oscView.oscillator2ModKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.oscView.oscillator2Mod2Knob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.oscView.oscillator2AmplitudeKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.oscView.oscillator2FatnessKnob sendActionsForControlEvents:UIControlEventValueChanged];
    
    [v1.envView.ampEnvelopeView.ampAttackKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.envView.ampEnvelopeView.ampDecayKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.envView.ampEnvelopeView.ampSustainKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.envView.ampEnvelopeView.ampReleaseKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.envView.filterEnvelopeView.filterAttackKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.envView.filterEnvelopeView.filterDecayKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.envView.filterEnvelopeView.filterSustainKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.envView.filterEnvelopeView.filterReleaseKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.filterView.filterCutoffKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.filterView.filterResonanceKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.filterView.filterEnvAmtKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.lfoView.lfoAmpKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v1.lfoView.lfoFreqKnob sendActionsForControlEvents:UIControlEventValueChanged];
    
    
    // EFFECTS
    [v5.distortionView.distGainKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v5.distortionView.distMixKnob sendActionsForControlEvents:UIControlEventValueChanged];
    
    [v5.phaserView.phaserFreqKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v5.phaserView.phaserFeedbackKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v5.phaserView.phaserMixKnob sendActionsForControlEvents:UIControlEventValueChanged];
    
    [v5.chorusView.param1Knob sendActionsForControlEvents:UIControlEventValueChanged];
    [v5.chorusView.param2Knob sendActionsForControlEvents:UIControlEventValueChanged];
    [v5.chorusView.param3Knob sendActionsForControlEvents:UIControlEventValueChanged];
    [v5.chorusView.mixKnob sendActionsForControlEvents:UIControlEventValueChanged];

    [v5.delayView.param1Knob sendActionsForControlEvents:UIControlEventValueChanged];
    [v5.delayView.param2Knob sendActionsForControlEvents:UIControlEventValueChanged];
    [v5.delayView.mixKnob sendActionsForControlEvents:UIControlEventValueChanged];
    
    [v5.reverbView.reverbRoomSizeKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v5.reverbView.reverbFreqKnob sendActionsForControlEvents:UIControlEventValueChanged];
    [v5.reverbView.reverbMixKnob sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark Motion methods

- (void)initControlSources
{
    int numberOFModMatrices = 8;
    self.controlSources = [[NSMutableArray alloc]initWithObjects:nil];
    self.controlDestinations = [[NSMutableArray alloc]initWithObjects:nil];
    MGKRotaryKnob* knob = [[MGKRotaryKnob alloc]init];
    NSNumber* num = [[NSNumber alloc]initWithFloat:0];
    for (int i = 0; i < numberOFModMatrices; i++) {
        [controlDestinations setObject:knob atIndexedSubscript:i];
        [controlSources setObject:num atIndexedSubscript:i];
    }
}

- (void)initTableViewDictionaries
{
    // This method initiates what we see in the UITableViews in view4.
    
    NSMutableDictionary* sourceDict = [[NSMutableDictionary alloc]init];
    [sourceDict setObject:[NSString stringWithFormat:@"%f", gravityX] forKey:gravityXAxisString];
    [sourceDict setObject:[NSString stringWithFormat:@"%f", gravityY] forKey:gravityYAxisString];
    [sourceDict setObject:[NSString stringWithFormat:@"%f", gravityZ] forKey:gravityZAxisString];
    [sourceDict setObject:[NSString stringWithFormat:@"%f", magneticFieldX] forKey:magneticFieldXAxisString];
    [sourceDict setObject:[NSString stringWithFormat:@"%f", magneticFieldY] forKey:magneticFieldYAxisString];
    [sourceDict setObject:[NSString stringWithFormat:@"%f", magneticFieldZ] forKey:magneticFieldZAxisString];
    [sourceDict setObject:[NSString stringWithFormat:@"%f", accelerometerX] forKey:accelerometerXAxisString];
    [sourceDict setObject:[NSString stringWithFormat:@"%f", accelerometerY] forKey:accelerometerYAxisString];
    [sourceDict setObject:[NSString stringWithFormat:@"%f", accelerometerZ] forKey:accelerometerZAxisString];
    
    NSMutableDictionary* destDict = [[NSMutableDictionary alloc]init];
    [destDict setObject:v1.oscView.oscillator1FineTuneKnob forKey:oscillator1FineTuneString];
    [destDict setObject:v1.oscView.oscillator2FineTuneKnob forKey:oscillator2FineTuneString];
    [destDict setObject:v1.filterView.filterCutoffKnob forKey:filterCutoffString];
    [destDict setObject:v1.filterView.filterResonanceKnob forKey:filterResonanceString];
    [destDict setObject:v1.lfoView.lfoAmpKnob forKey:LFOAmpString];
    [destDict setObject:v1.lfoView.lfoFreqKnob forKey:LFOFreqString];
    [destDict setObject:v5.reverbView.reverbMixKnob forKey:reverbMixString];
    [destDict setObject:v5.reverbView.reverbRoomSizeKnob forKey:reverbRoomsizeString];
    [destDict setObject:v5.phaserView.phaserFreqKnob forKey:phaserSpeedString];

    // Make two temp mutable arrays and sort them alfabetically.
    NSMutableArray* tempSourceArray = [[NSMutableArray alloc]initWithArray:[[sourceDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    NSMutableArray* tempDestinationArray = [[NSMutableArray alloc]initWithArray:[[destDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    
    // Add None to the top of each, don't want these to be alphabetic
    [tempDestinationArray insertObject:noneString atIndex:0];
    [tempSourceArray insertObject:noneString atIndex:0];

    // Populate the TableViews in the Mod Matrix View
    self.v4.sourceArray = tempSourceArray;
    self.v4.destinationArray = tempDestinationArray;
    self.v4.destViewController.destinationArray = tempDestinationArray;
}

- (void)startMotionManager
{
    if (motionManager) {
        NSLog(@"Motion off");
        motionManager = nil;
        [self stopMotionManager];
    } else {
        NSLog(@"Motion on");
        motionManager = [[CMMotionManager alloc]init];
        //Gyroscope
        if ([self.motionManager isGyroAvailable]) {
            if ([self.motionManager isGyroActive] == NO) {
                [self.motionManager setDeviceMotionUpdateInterval:1.0f / 20.0f];
                [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                        withHandler:^(CMDeviceMotion *deviceMotionData, NSError *error) {
                                                            gravityX = deviceMotionData.gravity.x;
                                                            gravityY = deviceMotionData.gravity.y;
                                                            gravityZ = deviceMotionData.gravity.z;
                                                            magneticFieldX = deviceMotionData.magneticField.field.x;
                                                            magneticFieldY = deviceMotionData.magneticField.field.y;
                                                            magneticFieldZ = deviceMotionData.magneticField.field.z;
                                                            
                                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"destinationValuesUpdated" object:nil];
                            
                                                        }];
            }
        } else {
            NSLog(@"Gyroscope not Available!");
        }
    }
}

- (void)stopMotionManager
{
    motionManager = nil;
}

- (void)updateDestinationSourceValues
{
    for (int i = 0; i < [controlSources count]; ++i) {
        [controlSources replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f", *sourcePointerArray[i]]];
        MGKRotaryKnob* currentDestination = controlDestinations[i];
        double d = [controlSources[i] doubleValue];
        if([currentDestination isEqual:[NSNull null]]) {
            continue;
        } else {
            currentDestination.value = fabsf(d)*currentDestination.maximumValue;
        }
    }
    [self updateCsoundValues];
}

- (void)modMatrixSourceUpdated:(NSNotification*)notification
{
    int sourceIndex = 0;
    NSDictionary* dict = [notification userInfo];
    
    // Get the selected source
    NSString* currentSource = [dict valueForKey:@"selectedSource"];
    
    // Get the index of the source
    if ([currentSource isEqualToString:@"sourceTable1"]) {
        sourceIndex = 0;
    } else if ([currentSource isEqualToString:@"sourceTable2"]) {
        sourceIndex = 1;
    } else if ([currentSource isEqualToString:@"sourceTable3"]) {
        sourceIndex = 2;
    } else if ([currentSource isEqualToString:@"sourceTable4"]) {
        sourceIndex = 3;
    } else if ([currentSource isEqualToString:@"sourceTable5"]) {
        sourceIndex = 4;
    } else if ([currentSource isEqualToString:@"sourceTable6"]) {
        sourceIndex = 5;
    } else if ([currentSource isEqualToString:@"sourceTable7"]) {
        sourceIndex = 6;
    } else if ([currentSource isEqualToString:@"sourceTable8"]) {
        sourceIndex = 7;
    }
    
    // Set the source address to the array
    if ([dict valueForKey:currentSource] == gravityXAxisString) {
        sourcePointerArray[sourceIndex] = &gravityX;
    } else if ([dict valueForKey:currentSource] == gravityYAxisString) {
        sourcePointerArray[sourceIndex] = &gravityY;
    } else if ([dict valueForKey:currentSource] == gravityZAxisString) {
        sourcePointerArray[sourceIndex] = &gravityZ;
    } else if ([dict valueForKey:currentSource] == magneticFieldXAxisString) {
        sourcePointerArray[sourceIndex] = &magneticFieldX;
    } else if ([dict valueForKey:currentSource] == magneticFieldYAxisString) {
        sourcePointerArray[sourceIndex] = &magneticFieldY;
    } else if ([dict valueForKey:currentSource] == magneticFieldZAxisString) {
        sourcePointerArray[sourceIndex] = &magneticFieldZ;
    } else {
        [controlSources replaceObjectAtIndex:sourceIndex withObject:[NSNull null]];
    }
}

- (void)modMatrixDestinationUpdated:(NSNotification*)notification
{
    int destinationIndex = 0;
    NSDictionary* dict = [notification userInfo];

    // Get the selected source
    NSString* currentDestination = [dict valueForKey:@"selectedDestination"];
    
    // Get the index of the source
    if ([currentDestination isEqualToString:@"destinationTable1"]) {
        destinationIndex = 0;
    } else if ([currentDestination isEqualToString:@"destinationTable2"]) {
        destinationIndex = 1;
    } else if ([currentDestination isEqualToString:@"destinationTable3"]) {
        destinationIndex = 2;
    } else if ([currentDestination isEqualToString:@"destinationTable4"]) {
        destinationIndex = 3;
    } else if ([currentDestination isEqualToString:@"destinationTable5"]) {
        destinationIndex = 4;
    } else if ([currentDestination isEqualToString:@"destinationTable6"]) {
        destinationIndex = 5;
    } else if ([currentDestination isEqualToString:@"destinationTable7"]) {
        destinationIndex = 6;
    } else if ([currentDestination isEqualToString:@"destinationTable8"]) {
        destinationIndex = 7;
    }
    
    if ([dict valueForKey:currentDestination] == oscillator1FineTuneString) {
        [controlDestinations replaceObjectAtIndex:destinationIndex withObject:v1.oscView.oscillator1FineTuneKnob];
    } else if ([dict valueForKey:currentDestination] == oscillator2FineTuneString) {
        [controlDestinations replaceObjectAtIndex:destinationIndex withObject:v1.oscView.oscillator2FineTuneKnob];
    } else if ([dict valueForKey:currentDestination] == filterCutoffString) {
        [controlDestinations replaceObjectAtIndex:destinationIndex withObject:v1.filterView.filterCutoffKnob];
    } else if ([dict valueForKey:currentDestination] == filterResonanceString) {
        [controlDestinations replaceObjectAtIndex:destinationIndex withObject:v1.filterView.filterResonanceKnob];
    } else if ([dict valueForKey:currentDestination] == LFOAmpString) {
        [controlDestinations replaceObjectAtIndex:destinationIndex withObject:v1.lfoView.lfoAmpKnob];
    } else if ([dict valueForKey:currentDestination] == LFOFreqString) {
        [controlDestinations replaceObjectAtIndex:destinationIndex withObject:v1.lfoView.lfoFreqKnob];
    } else if ([dict valueForKey:currentDestination] == reverbMixString) {
        [controlDestinations replaceObjectAtIndex:destinationIndex withObject:v5.reverbView.reverbMixKnob];
    } else if ([dict valueForKey:currentDestination] == reverbRoomsizeString) {
        [controlDestinations replaceObjectAtIndex:destinationIndex withObject:v5.reverbView.reverbRoomSizeKnob];
    } else if ([dict valueForKey:currentDestination] == phaserSpeedString) {
        [controlDestinations replaceObjectAtIndex:destinationIndex withObject:v5.phaserView.phaserFreqKnob];
    } else {
        [controlDestinations replaceObjectAtIndex:destinationIndex withObject:[NSNull null]];
    }
}


#pragma mark Console callback

- (void)updateUIWithNewMessage:(NSString *)newMessage
{
    NSLog(@"%@", newMessage);
}


- (void)messageCallback:(NSValue *)infoObj
{
    @autoreleasepool {
        Message info;
        [infoObj getValue:&info];
        char message[1024];
        vsnprintf(message, 1024, info.format, info.valist);
        NSString *messageStr = [NSString stringWithFormat:@"%s", message];
        [self performSelectorOnMainThread:@selector(updateUIWithNewMessage:)
                               withObject:messageStr
                            waitUntilDone:NO];
    }
}

- (void)filterTypeChanged
{
}


#pragma mark MIDI

static void CheckError(OSStatus error, const char *operation)
{
    if(error == noErr) return;
    
    char errorString[20];
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(error);
    if(isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    }
    else {
        sprintf(errorString, "%d", (int)error);
    }
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    
    exit(1);
}

-(void)connectToHost
{
    MIDINetworkHost *host = [MIDINetworkHost hostWithName:@"MyMIDIWifi"
                                                  address:DESTINATION_ADDRESS
                                                     port:5004];
    if(!host)
        return;
    
    MIDINetworkConnection *connection = [MIDINetworkConnection connectionWithHost:host];
    if(!connection)
        return;
    
    self.midiSession = [MIDINetworkSession defaultSession];
    if (self.midiSession) {
        NSLog(@"Got midi session");
        [self.midiSession addConnection:connection];
        self.midiSession.enabled = YES;
        self.destinationEndPoint = [self.midiSession destinationEndpoint];
        
        
        MIDIClientRef client;
        MIDIPortRef outport;
        CheckError(MIDIClientCreate(CFSTR("MyMIDIWifi Client"),
                                    NULL, NULL, &client), "Kunne ikke opprette MIDI-klient");
        CheckError(MIDIOutputPortCreate(client,
                                        CFSTR("MyMIDIWifi Output port"),
                                        &outport),
                   "Kunne ikke opprette output-port");
        self.outputPort = outport;
        NSLog(@"Got output port!");
        //MIDIInputPortCreate(client, CFSTR("MyMIDI Input port"), NULL, NULL, &outport);
    }
}

-(void)sendStatus:(Byte)status data1:(Byte)data1 data2:(Byte)data2
{
    MIDIPacketList packetList;
    
    packetList.numPackets = 1;
    packetList.packet[0].length = 3;
    packetList.packet[0].data[0] = status;
    packetList.packet[0].data[1] = data1;
    packetList.packet[0].data[2] = data2;
    packetList.packet[0].timeStamp = 0;
    
    CheckError(MIDISend(self.outputPort, self.destinationEndPoint, &packetList), "Kunne ikke sende MIDI-pakkelista");
}

- (void)initMidi
{
    midiConnection = [[PGMidi alloc]init];
    midiConnection.networkEnabled = NO;
    midiConnection.virtualDestinationEnabled = YES;
    [midiConnection setVirtualEndpointName:@"MyApp"];
}

-(void)sendNoteOnEvent:(Byte)key velocity:(Byte)velocity
{
    [self sendStatus:0x90 data1:key & 0x7F data2:velocity & 0x7F];
}

-(void)sendNoteOffEvent:(Byte)key velocity:(Byte)velocity
{
    [self sendStatus:0x80 data1:key & 0x7F data2:velocity & 0x7F];
}

-(IBAction)handleKeyDown:(id)sender
{
    NSInteger note = [sender tag];
    [self sendNoteOnEvent:(Byte)note velocity:127];
}

-(IBAction)handleKeyUp:(id)sender
{
    NSInteger note = [sender tag];
    [self sendNoteOffEvent:(Byte)note velocity:127];
}

- (IBAction)showSoundfontPresets:(UIButton *)sender
{
    NSLog(@"FMViewcontroller 1 is now: %@", FMOscillator1SelectionViewController);
    NSLog(@"The first button is: %@", FMOscillator1SelectionViewController.fmKnob1);

    [mCsound sendScore:[NSString stringWithFormat:@"i400 0 0"]];
}

- (void)changeOscillator1SoundfontInstrumentTo:(NSString*)numberString
{
    int number = [numberString intValue];
    [mCsound sendScore:[NSString stringWithFormat:@"i401 0 0 %i", number]];
}

- (void)changeOscillator2SoundfontInstrumentTo:(NSString*)numberString
{
    int number = [numberString intValue];
    [mCsound sendScore:[NSString stringWithFormat:@"i402 0 0 %i", number]];
}

- (void)initOscillatorTouchRecognizers
{
    // Get Oscillator image size
    UIImage *img = [UIImage imageNamed:@"oscillatorBackground.png"];
    int imgX = img.size.width;
    int imgY = img.size.height;
    
    // Insert a dummy subview under each oscillator selector.
    v1.oscView.oscillator1HiddenSubviewTouchRecognization = [[UIView alloc]initWithFrame:CGRectMake(v1.oscView.oscillator1Slider.frame.origin.x, v1.oscView.oscillator1Slider.frame.origin.y, imgX, imgY)];
    v1.oscView.oscillator1HiddenSubviewTouchRecognization.backgroundColor = [UIColor clearColor];
    [v1.oscView addSubview:v1.oscView.oscillator1HiddenSubviewTouchRecognization];
    [v1.oscView sendSubviewToBack:v1.oscView.oscillator1HiddenSubviewTouchRecognization];
    
    v1.oscView.oscillator2HiddenSubviewTouchRecognization = [[UIView alloc]initWithFrame:CGRectMake(v1.oscView.oscillator2Slider.frame.origin.x, v1.oscView.oscillator2Slider.frame.origin.y, imgX, imgY)];
    v1.oscView.oscillator2HiddenSubviewTouchRecognization.backgroundColor = [UIColor clearColor];
    [v1.oscView addSubview:v1.oscView.oscillator2HiddenSubviewTouchRecognization];
    [v1.oscView sendSubviewToBack:v1.oscView.oscillator2HiddenSubviewTouchRecognization];
    
    // Set up tap recognizers
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapOnOscSlider:)];
    [v1.oscView addGestureRecognizer:doubleTapRecognizer];
    doubleTapRecognizer.cancelsTouchesInView = NO;
    doubleTapRecognizer.numberOfTapsRequired = 2;
    
    UITapGestureRecognizer *tripleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTapOnOscSlider:)];
    [v1.oscView addGestureRecognizer:tripleTapRecognizer];
    tripleTapRecognizer.cancelsTouchesInView = NO;
    tripleTapRecognizer.numberOfTapsRequired = 3;
    
    // Even out positioning of the selector, and make it possible to triple click without triggering double click. (Adds latency)
    //[doubleTapRecognizer requireGestureRecognizerToFail:tripleTapRecognizer];

}

//The event handling method for OscillatorView
- (void)handleDoubleTapOnOscSlider:(UITapGestureRecognizer *)recognizer
{
    UISlider* slider;
    UIView* subview;
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    // Get correct oscillator tap (or return direct if double tap is outside both subview)
    if (CGRectContainsPoint(v1.oscView.oscillator1HiddenSubviewTouchRecognization.frame, location)) {
        NSLog(@"Double tap in osc1 registered");
        slider = v1.oscView.oscillator1Slider;
        subview = v1.oscView.oscillator1HiddenSubviewTouchRecognization;
    } else if(CGRectContainsPoint(v1.oscView.oscillator2HiddenSubviewTouchRecognization.frame, location)) {
        slider = v1.oscView.oscillator2Slider;
        subview = v1.oscView.oscillator2HiddenSubviewTouchRecognization;
    } else if(false) {
        
    }
    else {
        return;
    }
    
    double relativeXPositionInSubview = location.x - subview.frame.origin.x;
    double subviewWidth = subview.frame.size.width;
    
    // If double tapped, check relative position inside the selected subview.
    if (relativeXPositionInSubview >= 0 && relativeXPositionInSubview < subviewWidth*1/NUMBER_OF_OSCILLATORS) {
        [slider setValue:1. animated:YES];
    } else if (relativeXPositionInSubview > subviewWidth*1/NUMBER_OF_OSCILLATORS && relativeXPositionInSubview < subviewWidth*2/NUMBER_OF_OSCILLATORS) {
        [slider setValue:2. animated:YES];
    } else if (relativeXPositionInSubview > subviewWidth*2/NUMBER_OF_OSCILLATORS && relativeXPositionInSubview < subviewWidth*3/NUMBER_OF_OSCILLATORS) {
        [slider setValue:3. animated:YES];
    } else if (relativeXPositionInSubview > subviewWidth*3/NUMBER_OF_OSCILLATORS && relativeXPositionInSubview < subviewWidth*4/NUMBER_OF_OSCILLATORS) {
        [slider setValue:4. animated:YES];
    } else if (relativeXPositionInSubview > subviewWidth*4/NUMBER_OF_OSCILLATORS && relativeXPositionInSubview < subviewWidth*5/NUMBER_OF_OSCILLATORS) {
        [slider setValue:5. animated:YES];
    }
    [self updateCsoundValues];
}

- (void)handleTripleTapOnOscSlider:(UITapGestureRecognizer *)recognizer
{
    UISlider* slider;
    UIView* subview;
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    // Get correct oscillator tap (or return direct if double tap is outside both subview)
    if (CGRectContainsPoint(v1.oscView.oscillator1HiddenSubviewTouchRecognization.frame, location)) {
        NSLog(@"Triple tap in osc1slider registered!");
        slider = v1.oscView.oscillator1Slider;
        subview = v1.oscView.oscillator1HiddenSubviewTouchRecognization;
        
        double relativeXPositionInSubview = location.x - subview.frame.origin.x;
        double subviewWidth = subview.frame.size.width;
        
        if (relativeXPositionInSubview > subviewWidth*3/NUMBER_OF_OSCILLATORS && relativeXPositionInSubview < subviewWidth*4/NUMBER_OF_OSCILLATORS) {
            [self openOscillator1FMPopoverControllerFromSlider:slider withDictionaryKey:@"Barack Obama"];
        } else if (relativeXPositionInSubview > subviewWidth*4/NUMBER_OF_OSCILLATORS && relativeXPositionInSubview < subviewWidth*5/NUMBER_OF_OSCILLATORS) {
            [self openOscillator1SoundfontPopoverControllerFromSlider:slider withDictionaryKey:@"Vladimir Putin"];
        }
    } else if(CGRectContainsPoint(v1.oscView.oscillator2HiddenSubviewTouchRecognization.frame, location)) {
        NSLog(@"Triple tap in osc2slider registered!");
        slider = v1.oscView.oscillator2Slider;
        subview = v1.oscView.oscillator2HiddenSubviewTouchRecognization;
        
        double relativeXPositionInSubview = location.x - subview.frame.origin.x;
        double subviewWidth = subview.frame.size.width;
        
        if (relativeXPositionInSubview > subviewWidth*3/NUMBER_OF_OSCILLATORS && relativeXPositionInSubview < subviewWidth*4/NUMBER_OF_OSCILLATORS) {
            [self openOscillator1FMPopoverControllerFromSlider:slider withDictionaryKey:@"Barack Obama"];
        } else if (relativeXPositionInSubview > subviewWidth*4/NUMBER_OF_OSCILLATORS && relativeXPositionInSubview < subviewWidth*5/NUMBER_OF_OSCILLATORS) {
            [self openOscillator2SoundfontPopoverControllerFromSlider:slider withDictionaryKey:@"Vladimir Putin"];
        }
    } else {
        return;
    }
    

}

- (void)initPopoverViewControllersAndKnobs
{
    FMOscillator1SelectionViewController = [[MGKFMSelectionViewController alloc] initWithNibName:@"MGKFMSelectionViewController" bundle:nil];
    FMOscillator2SelectionViewController = [[MGKFMSelectionViewController alloc] initWithNibName:@"MGKFMSelectionViewController" bundle:nil];
    soundfontOscillator1SelectionViewController = [[MGKSoundfontSelectionViewController alloc] initWithNibName:@"MGKSoundfontSelectionViewController" bundle:nil];
    soundfontOscillator2SelectionViewController = [[MGKSoundfontSelectionViewController alloc] initWithNibName:@"MGKSoundfontSelectionViewController" bundle:nil];
}

- (void)openOscillator1FMPopoverControllerFromSlider:(UISlider*)slider withDictionaryKey:(NSString*)dictionaryKey
{
    FMPopoverController = [[UIPopoverController alloc] initWithContentViewController:FMOscillator1SelectionViewController];
    FMPopoverController.delegate = self;
    FMPopoverController.popoverContentSize = CGSizeMake(100, 200);
    
    CGRect correctPopoverPosition = slider.frame;
    correctPopoverPosition.origin.x += 66; // This number is just a hack.
    [FMPopoverController presentPopoverFromRect:correctPopoverPosition inView:self.v1.oscView permittedArrowDirections: UIPopoverArrowDirectionUp animated:YES];
    FMPopoverController.passthroughViews = [NSArray arrayWithObjects:v1.oscView.oscillator1ModKnob, v1.oscView.oscillator2ModKnob, keyboardView, nil];
}

- (void)openOscillator2FMPopoverControllerFromSlider:(UISlider*)slider withDictionaryKey:(NSString*)dictionaryKey
{
    FMPopoverController = [[UIPopoverController alloc] initWithContentViewController:FMOscillator2SelectionViewController];
    FMPopoverController.delegate = self;
    FMPopoverController.popoverContentSize = CGSizeMake(100, 200);
    
    CGRect correctPopoverPosition = slider.frame;
    correctPopoverPosition.origin.x += 66; // This number is just a hack.
    [FMPopoverController presentPopoverFromRect:correctPopoverPosition inView:self.v1.oscView permittedArrowDirections: UIPopoverArrowDirectionUp animated:YES];
    FMPopoverController.passthroughViews = [NSArray arrayWithObjects:v1.oscView.oscillator1ModKnob, v1.oscView.oscillator2ModKnob, keyboardView, nil];
}

- (void)openOscillator1SoundfontPopoverControllerFromSlider:(UISlider*)slider withDictionaryKey:(NSString*)dictionaryKey
{
    soundfontOscillator1SelectionViewController.mainViewController = self;
    //destViewController.dictionaryKey = dictionaryKey;
    soundfontPopoverController = [[UIPopoverController alloc] initWithContentViewController:soundfontOscillator1SelectionViewController];
    soundfontPopoverController.delegate = self;
    soundfontPopoverController.popoverContentSize = CGSizeMake(300, 400);
    
    CGRect correctPopoverPosition = slider.frame;
    correctPopoverPosition.origin.x += 127; // This number is just a hack.
    [soundfontPopoverController presentPopoverFromRect:correctPopoverPosition inView:self.v1.oscView permittedArrowDirections: UIPopoverArrowDirectionUp | UIPopoverArrowDirectionRight animated:YES];
    soundfontPopoverController.passthroughViews = [NSArray arrayWithObjects:v1.oscView.oscillator1ModKnob, v1.oscView.oscillator2ModKnob, keyboardView, nil];

    //destViewController.destinationArray = destinationArray;
}

- (void)openOscillator2SoundfontPopoverControllerFromSlider:(UISlider*)slider withDictionaryKey:(NSString*)dictionaryKey
{
    //destViewController.dictionaryKey = dictionaryKey;
    soundfontOscillator2SelectionViewController.mainViewController = self;
    soundfontPopoverController = [[UIPopoverController alloc] initWithContentViewController:soundfontOscillator2SelectionViewController];
    soundfontPopoverController.delegate = self;
    soundfontPopoverController.popoverContentSize = CGSizeMake(300, 400);
    
    CGRect correctPopoverPosition = slider.frame;
    correctPopoverPosition.origin.x += 127; // This number is just a hack.
    [soundfontPopoverController presentPopoverFromRect:correctPopoverPosition inView:self.v1.oscView permittedArrowDirections: UIPopoverArrowDirectionUp | UIPopoverArrowDirectionRight animated:YES];
    soundfontPopoverController.passthroughViews = [NSArray arrayWithObjects:v1.oscView.oscillator1ModKnob, v1.oscView.oscillator2ModKnob, keyboardView, nil];
    
    //destViewController.destinationArray = destinationArray;
}

- (IBAction)presetButtonPressed:(id)sender
{
    self.presetViewController.mainViewController = self;
    NSLog(@"\n%@", self.presetButton.titleLabel.text);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"presetSegue"]) {
        // Get reference to the destination view controller
        self.presetViewController = [segue destinationViewController];
        self.presetViewController.mainViewController = self;
        NSLog(@"\nAddress from main view controller: %@", self);

        // Pass any objects to the view controller here, like...
        //[vc setMyObjectHere:object];
    } else if ([[segue identifier] isEqualToString:@"soundfontSegue"]) {
        self.soundfontViewController = [segue destinationViewController];
        self.soundfontViewController.mainViewController = self;
    } else if ([[segue identifier] isEqualToString:@"recordingSegue"]) {

    }
}

- (void)record
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = @"newFile.m4a";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: fileName];
    NSLog(@"full path name: %@", filePath);
    
    // check if file exists
    if ([fileManager fileExistsAtPath: filePath] == YES){
        NSLog(@"File exists");
    } else {
        NSLog (@"File not found, file will be created");
        if (![fileManager createFileAtPath:filePath contents:nil attributes:nil]){
            NSLog(@"Create file returned NO");
        }
    }
    
    if (!isRecording) {
        NSURL *url = [[NSURL alloc]initFileURLWithPath:filePath];
        [self.csound recordToURL:url];
        NSLog(@"Recording started");
        isRecording = YES;
    } else {
        [self.csound stopRecording];
        NSLog(@"Recording stopped");
        isRecording = NO;
    }
    NSLog(@"%hhd", isRecording);
}

- (IBAction)polyphonySwitch:(id)sender
{
    if (isPolyphonic) {
        [mCsound sendScore:[NSString stringWithFormat:@"i450 0 0"]];
    } else {
        [mCsound sendScore:[NSString stringWithFormat:@"i451 0 0"]];
    }
    isPolyphonic = !isPolyphonic;
}

- (void)myTestMethod
{
    NSLog(@"hei");
}

- (NSMutableDictionary*)getDictOfCurrentParameters
{
    NSMutableDictionary* currentValues = [[NSMutableDictionary alloc]init];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.envView.ampEnvelopeView.ampAttackKnob.value] forKey:@"ampAttack"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.envView.ampEnvelopeView.ampDecayKnob.value] forKey:@"ampDecay"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.envView.ampEnvelopeView.ampSustainKnob.value] forKey:@"ampSustain"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.envView.ampEnvelopeView.ampReleaseKnob.value] forKey:@"ampRelease"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.filterView.filterCutoffKnob.value] forKey:@"filterCutoff"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.filterView.filterResonanceKnob.value] forKey:@"filterResonance"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.envView.filterEnvelopeView.filterAttackKnob.value] forKey:@"filterAttack"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.envView.filterEnvelopeView.filterDecayKnob.value] forKey:@"filterDecay"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.envView.filterEnvelopeView.filterSustainKnob.value] forKey:@"filterSustain"];
    [currentValues setValue:[NSNumber numberWithFloat:self.v1.envView.filterEnvelopeView.filterReleaseKnob.value] forKey:@"filterRelease"];
    
    //    [currentValues setValue:[NSNumber numberWithInt:self.vc.v1.oscillator1SegmentedControl.selectedSegmentIndex] forKey:@"oscillator1SegmentedControl"];
    //    [currentValues setValue:[NSNumber numberWithInt:self.vc.v1.oscillator2SegmentedControl.selectedSegmentIndex] forKey:@"oscillator2SegmentedControl"];
    
    NSLog(@"MGKViewController:\n%@, View: %@", currentValues, self.v1);
    return currentValues;
}

@end
