//
//  PreferencesViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import "PreferencesViewController.h"


@interface PreferencesViewController ()

@end

@implementation PreferencesViewController

 

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
    
    [self.aboutLabel setText:[NSString stringWithFormat:@"Version %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] ];
    
	// set the segmented control current state
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"]){
        [self.segmentedSortControl setSelectedSegmentIndex:1];
    }else{
        [self.segmentedSortControl setSelectedSegmentIndex:0];
    }
    self.segmentedDifficultyLevel.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"difficultyLevel"]-1;
    
    
    //set the default sametime value (
    [self.switchShowSameTime setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"sameTime"]];

    [self.switchLowerLevels setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"includeLowerLevels"]];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)done:(id)sender
{
     NSLog(@"did finish flipside %@",self.delegate);
    
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)diffycultyLevelChanged:(UISegmentedControl *)sender {
    NSInteger index = ((UISegmentedControl*)sender).selectedSegmentIndex+1;
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"difficultyLevel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)selectionChanged:(id)sender {
    NSInteger index = ((UISegmentedControl*)sender).selectedSegmentIndex;
    NSLog(@"Selected %d",index);    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:(index == 1) forKey:@"randomOrder"];
    [settings synchronize];
}

-(IBAction)sameTimeChanged:(id)sender{
    
    BOOL checked  = [self switchShowSameTime].on;
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:checked forKey:@"sameTime"];
    [settings synchronize];
}

- (IBAction)lowerLevelsChanged {
    BOOL checked  = [self switchLowerLevels].on;
    [[NSUserDefaults standardUserDefaults] setBool:checked forKey:@"includeLowerLevels"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(IBAction)showAboutLink:(id)sender
{
    NSString *launchUrl= [[NSUserDefaults standardUserDefaults] stringForKey:@"aboutProjectURL"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}
@end
