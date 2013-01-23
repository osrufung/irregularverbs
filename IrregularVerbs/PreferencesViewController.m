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
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

-(void)viewDidLoad
{
    UIImage *buttonImage = [[UIImage imageNamed:@"greyButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"greyButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];

    [[self labelLevelOf] setText:NSLocalizedString(@"levelOfDifficulty", nil)];

    [self.buttonClear setTitle:NSLocalizedString(@"clearbuttontitle", nil) forState:UIControlStateNormal];
    [self.buttonClear setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.buttonClear setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.buttonAbout setTitle:NSLocalizedString(@"aboutbuttontitle", nil) forState:UIControlStateNormal];
    [self.buttonAbout setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.buttonAbout setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
}

- (void)setLabelNumberOfVerbsForDifficulty:(float)difficulty {
    int idx = [[[VerbsStore sharedStore] alphabetic] count];
    
    self.labelNumberOfVerbs.text = [NSString stringWithFormat:NSLocalizedString(@"includingverbs_format", nil),idx];
    
}

- (void)setLabeTestDuration {
    self.labelTestDuration.text = [NSString stringWithFormat:NSLocalizedString(@"testtime_format",nil),(int)[[Referee sharedReferee] maxValue]];
}


- (IBAction)testDurationChanged:(UIStepper *)sender {
    [[Referee sharedReferee] setMaxValue:sender.value];
    [self setLabeTestDuration];
}

- (IBAction)difficultyChanged:(UISlider *)sender {
    [[VerbsStore sharedStore] setFrequency:self.sliderDifficulty.value];
    [self setLabelNumberOfVerbsForDifficulty:sender.value];
}

- (IBAction)clearStatistics:(UIButton *)sender {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"clearhistorydata", nil)
                                                 message:NSLocalizedString(@"clearconsequence", nil)
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                       otherButtonTitles:NSLocalizedString(@"clearall", nil), nil];
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
