//
//  HomeViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio Fung on 15/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "HomeViewController.h"
#import "CardsTableViewController.h"
#import "PreferencesViewController.h"
#import "TestSelectorViewController.h"
#import "CardsTableViewController.h"
#import "VerbsStore.h"
#import "HistoryViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

+ (void)initialize{
    
    //load default settings values
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]]];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UINavigationItem *item = [self navigationItem];
        [item setTitle:@"Home"];
   
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeViewbg.png"]];
    }
    return self;

}

-(void)viewWillAppear:(BOOL)animated{
    [self updateUI];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)updateUI{
    [[self labelNumberVerbs] setAttributedText:[self attributedHomeLabel]];
}


-(NSAttributedString *) attributedHomeLabel{
   NSString *str = [NSString stringWithFormat: @"%d verbs to learn",[[[VerbsStore sharedStore] alphabetic] count]  ];
    NSMutableAttributedString *result  = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSDictionary *attributesForNumber = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:30.0f],NSForegroundColorAttributeName:[UIColor orangeColor]};
    
    NSRange afterNumberRange = [str rangeOfString:@" verbs to learn"];
    
    [result setAttributes:attributesForNumber range: NSMakeRange(0,afterNumberRange.location)];
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

- (IBAction)openLearn:(id)sender {
    [[self navigationController] pushViewController:[[CardsTableViewController alloc] init]
                                           animated:YES];
}

- (IBAction)openTest:(id)sender {
    [[self navigationController] pushViewController:[[TestSelectorViewController alloc] init]
                                           animated:YES];
    
}

- (IBAction)openSetup:(id)sender {
    [[self navigationController] pushViewController:[[PreferencesViewController alloc] init]
                                           animated:YES];
}

- (IBAction)openHistory:(id)sender {
    /*
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    CardsStackViewController *vc;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeHistory;
    vc.title = @"History";
    */
    
    
    [[self navigationController] pushViewController:[[HistoryViewController alloc] init]  animated:YES];
    
}

@end
