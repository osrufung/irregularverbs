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


@interface PreferencesViewController ()
{
    NSArray * _verbs;
}

@end

@implementation PreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.aboutLabel setText:[NSString stringWithFormat:@"Version %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] ];

    if([[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"]){
        [self.segmentedSortControl setSelectedSegmentIndex:1];
    }else{
        [self.segmentedSortControl setSelectedSegmentIndex:0];
    }
    
    self.sliderDifficulty.value=[[NSUserDefaults standardUserDefaults] floatForKey:@"frequency"];
    [self setLabelNumberOfVerbsForDifficulty:self.sliderDifficulty.value];

    
}

- (void)setLabelNumberOfVerbsForDifficulty:(float)difficulty {
 
    int idx = [[VerbsStore sharedStore] numberOfVerbsForDifficulty:difficulty];
    
    NSArray *selectedVerbs = [[VerbsStore sharedStore] verbsForDifficulty:difficulty];
    NSLog(@"verbos dentro de dificultad %f -> %d %@",difficulty, [selectedVerbs count], selectedVerbs );
    
    self.labelNumberOfVerbs.text = [NSString stringWithFormat:@"(including %d verbs)",idx];
 
}

- (IBAction)difficultyChanged:(UISlider *)sender {
    [self setLabelNumberOfVerbsForDifficulty:sender.value];
    [[NSUserDefaults standardUserDefaults] setFloat:self.sliderDifficulty.value forKey:@"frequency"];
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
 
- (IBAction)selectionChanged:(id)sender {
    NSInteger index = ((UISegmentedControl*)sender).selectedSegmentIndex;
    NSLog(@"Selected %d",index);    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:(index == 1) forKey:@"randomOrder"];
    
    [settings synchronize];
}

 
-(IBAction)showAboutLink:(id)sender
{
    NSString *launchUrl= [[NSUserDefaults standardUserDefaults] stringForKey:@"aboutProjectURL"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}
@end
