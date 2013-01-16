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
#import "CardsStackViewController.h" 
#import "TestSelectorViewController.h"
#import "VerbsStore.h"

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
        [item setTitle:@"a list of Verbs"];
   
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeViewbg.png"]];
    }
    return self;

}

-(void)viewWillAppear:(BOOL)animated{
    [self updateUI];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)updateUI{
 
    [[self labelNumberVerbs] setAttributedText:[self attributedHomeLabel]];
}
- (IBAction)openLearn:(id)sender {
    CardsTableViewController   *ctvc = [[CardsTableViewController alloc] init];
    ctvc.title = @"Learn";
    [[self navigationController] pushViewController:ctvc animated:YES];
}

 
-(NSAttributedString *) attributedHomeLabel{
   NSString *str = [NSString stringWithFormat: @"%d verbs to learn",[[[VerbsStore sharedStore] alphabetic] count]  ];
    NSMutableAttributedString *result  = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSDictionary *attributesForNumber = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:30.0f],NSForegroundColorAttributeName:[UIColor orangeColor]};
    
    NSRange afterNumberRange = [str rangeOfString:@" verbs to learn"];
    
    [result setAttributes:attributesForNumber range: NSMakeRange(0,afterNumberRange.location)];
    return [[NSAttributedString alloc] initWithAttributedString:result];
}
- (IBAction)openTest:(id)sender {
    TestSelectorViewController *tsvc = [[TestSelectorViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tsvc.title = @"Test";
    tsvc.tabBarItem.image = [UIImage imageNamed:@"clock_24.png"];
    [[self navigationController] pushViewController:tsvc animated:YES];
    
}

- (IBAction)openHistory:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    CardsStackViewController *vc;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeHistory;
    vc.title = @"History";
    
    [[self navigationController] pushViewController:vc animated:YES];
    
}

- (IBAction)openSetup:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    
//    PreferencesViewController *pvc = (PreferencesViewController*)[mainStoryboard
 //                                                                 instantiateViewControllerWithIdentifier: @"PreferencesViewController"];
    PreferencesViewController *pvc = [[PreferencesViewController alloc] init];
    
    pvc.title = @"Config";
    [[self navigationController] pushViewController:pvc animated:YES];
}
@end
