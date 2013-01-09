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
    
    // We neeed a copy sorted by frequency to select the verbs
    _verbs = [[VerbsStore sharedStore] allVerbs];
    _verbs = [_verbs sortedArrayUsingComparator:^(id ob1,id ob2) {
        Verb *v1 = (Verb *) ob1;
        Verb *v2 = (Verb *) ob2;
        
        return v1.frequency<v2.frequency;
    }];

	// set the segmented control current state
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"]){
        [self.segmentedSortControl setSelectedSegmentIndex:1];
    }else{
        [self.segmentedSortControl setSelectedSegmentIndex:0];
    }
    
    self.sliderDifficulty.value=0.2;
    [self setLabelNumberOfVerbsForDifficulty:0.2];

    
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

- (void)setLabelNumberOfVerbsForDifficulty:(float)difficulty {
    int idx;
    float freqAcum=0.0f;
    for (idx=0;idx<_verbs.count;idx++) {
        Verb *v = _verbs[idx];
        freqAcum += v.frequency;
        if (difficulty<=freqAcum) {
            break;
        }
    }
    if (difficulty==1.0f) idx=_verbs.count;
    self.labelNumberOfVerbs.text = [NSString stringWithFormat:@"(including %d verbs)",idx];
    
    NSRange range;
    range.location=0;
    range.length=idx;
    NSArray *selectedVerbs = [_verbs subarrayWithRange:range];
    NSLog(@"%@",selectedVerbs);
}

- (IBAction)difficultyChanged:(UISlider *)sender {
    [self setLabelNumberOfVerbsForDifficulty:sender.value];
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
