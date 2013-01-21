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
#import "ASDepthModalViewController.h"
#import <QuartzCore/QuartzCore.h>

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
        [item setTitle:NSLocalizedString(@"back",@"back button")];
   
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeViewbg.png"]];
    }
    return self;

}

-(void)viewDidLoad{
    [[self labelLearnButton] setText:NSLocalizedString(@"LearnLabel", @"Learn label button")];
    [[self labelTestButton] setText:NSLocalizedString(@"TestLabel", @"Test label button")];
    [[self labelHistoryButton] setText:NSLocalizedString(@"HistoryLabel", @"History label button")];
    [[self labelSetupButton] setText:NSLocalizedString(@"SetupLabel", @"Setup label button")];
    [[self labelPopUp] setText:NSLocalizedString(@"InfoPopupHome", @"info about App at home")];
    //setup popup view
   
    self.popUpView.layer.cornerRadius = 12;
    self.popUpView.layer.shadowOpacity = 0.7;
    self.popUpView.layer.shadowOffset = CGSizeMake(6, 6); 
    self.popUpView.layer.shouldRasterize = YES;
    self.popUpView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
 
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self updateUI];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    //firs time? show popupview assistant
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firsTimeAssistantShown"]){
         [ASDepthModalViewController presentView:self.popUpView withBackgroundColor:nil popupAnimationStyle:ASDepthModalAnimationShrink];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firsTimeAssistantShown"];
    }
    
}



-(void)updateUI{
    [[self labelNumberVerbs] setAttributedText:[self attributedHomeLabel]];
}


-(NSAttributedString *) attributedHomeLabel{
    
    int cntVerbs = [[[VerbsStore sharedStore] alphabetic] count] ;
   NSString *str = [NSString stringWithFormat: NSLocalizedString(@"verbstolearn", @"home label descriptor"), cntVerbs];
    NSMutableAttributedString *result  = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSDictionary *attributesForNumber = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:30.0f],NSForegroundColorAttributeName:[UIColor orangeColor]};
    
    [result setAttributes:attributesForNumber range: NSMakeRange(0,[[NSString stringWithFormat:@"%d",cntVerbs ] length])];
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

- (IBAction)showWizard:(id)sender {
    [ASDepthModalViewController presentView:self.popUpView withBackgroundColor:nil popupAnimationStyle:ASDepthModalAnimationDisplace];
}

- (IBAction)closePopUp:(id)sender {
    [ASDepthModalViewController dismiss];
}
@end
