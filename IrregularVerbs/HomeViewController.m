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

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UINavigationItem *item = [self navigationItem];
        [item setTitle:@"a list of Verbs"];
    }
    return self;

}
- (IBAction)openLearn:(id)sender {
    CardsTableViewController   *ctvc = [[CardsTableViewController alloc] init];
    ctvc.title = @"Learn";
    [[self navigationController] pushViewController:ctvc animated:YES];
}

 

- (IBAction)openTest:(id)sender {
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
    
    PreferencesViewController *pvc = (PreferencesViewController*)[mainStoryboard
                                                                  instantiateViewControllerWithIdentifier: @"PreferencesViewController"];
    
    pvc.title = @"Config";
    [[self navigationController] pushViewController:pvc animated:YES];
}
@end
