//
//  PreferencesViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import "PreferencesViewController.h"
#import "VerbsStore.h"
#import "Verb.h"
#import "Referee.h"


@interface PreferencesViewController ()
{
    NSArray * _verbs;
}

@end

@implementation PreferencesViewController

#pragma mark - Load and store

- (void)viewWillAppear:(BOOL)animated {
    [self.aboutLabel setText:[NSString stringWithFormat:@"Version %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] ];
    
    self.sliderDifficulty.value=[[VerbsStore sharedStore] frequency];
    [self setLabelNumberOfVerbsForDifficulty:self.sliderDifficulty.value];
    self.stepperTestDuration.value = [[Referee sharedReferee] maxValue];
    [self setLabeTestDuration];
    self.useHints.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hintsInTest"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)setLabelNumberOfVerbsForDifficulty:(float)difficulty {
    int idx = [[[VerbsStore sharedStore] alphabetic] count];
    self.labelNumberOfVerbs.text = [NSString stringWithFormat:@"(including %d verbs)",idx];
}

- (void)setLabeTestDuration {
    self.labelTestDuration.text = [NSString stringWithFormat:@"Test time is %d sec",(int)[[Referee sharedReferee] maxValue]];
}


- (IBAction)testDurationChanged:(UIStepper *)sender {
    [[Referee sharedReferee] setMaxValue:sender.value];
    [self setLabeTestDuration];
}

- (IBAction)changeHintsInTests:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:self.useHints.on forKey:@"hintsInTest"];
}

- (IBAction)difficultyChanged:(UISlider *)sender {
    [[VerbsStore sharedStore] setFrequency:self.sliderDifficulty.value];
    [self setLabelNumberOfVerbsForDifficulty:sender.value];
}

- (IBAction)clearStatistics:(UIButton *)sender {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Clear Historical Data"
                                                 message:@"You will clear all the data from old tests"
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Clear All", nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [[VerbsStore sharedStore] resetHistory];
    }
}
 
-(IBAction)showAboutLink:(id)sender
{
    NSString *launchUrl= [[NSUserDefaults standardUserDefaults] stringForKey:@"aboutProjectURL"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

@end
