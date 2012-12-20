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
	// set the segmented control current state
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"]){
        [self.segmentedSortControl setSelectedSegmentIndex:1];
    }else{
        [self.segmentedSortControl setSelectedSegmentIndex:0];
    }
    
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
- (IBAction)selectionChanged:(id)sender {
    NSInteger index = ((UISegmentedControl*)sender).selectedSegmentIndex;
    NSLog(@"Selected %d",index);
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    [settings setBool:(index == 1) forKey:@"randomOrder"];
    
    // Write them to disk - this is optional here,
    // but should be done when the app exits.
    [settings synchronize];
    
    
}
@end
