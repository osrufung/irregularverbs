//
//  ModeViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 08/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "VerbsStore.h"
#import "ModeViewController.h"
#import "CardsStackViewController.h"
#import "Referee.h"
#import "PreferencesViewController.h"
#import "NSArray+Shuffling.h"
#import "CardsTableViewController.h"

@interface ModeViewController ()

@property (nonatomic,readonly) BOOL defaultsChanged;

@end

@implementation ModeViewController

- (void)viewDidLoad
{
    CardsStackViewController *vc;

    [super viewDidLoad];
    
    // Create the CardsStackViewControllers

    CardsTableViewController *tmvc = [[CardsTableViewController alloc] init];
    tmvc.title = @"Learn";
    tmvc.tabBarItem.image = [UIImage imageNamed:@"book_bookmark_24.png"];
    
    [self addChildViewController:tmvc];

    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeTest;
    vc.title = @"Test";
    vc.tabBarItem.image = [UIImage imageNamed:@"clock_24.png"];
    [self addChildViewController:vc];

    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeReview;
    vc.title = @"Review";
    vc.tabBarItem.image = [UIImage imageNamed:@"chart_bar_24.png"];
    [self addChildViewController:vc];

    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeHistory;
    vc.title = @"History";
    vc.tabBarItem.image = [UIImage imageNamed:@"calendar_24.png"];
    [self addChildViewController:vc];
    
    PreferencesViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PreferencesViewController"];
    pvc.title = @"Config";
    pvc.tabBarItem.image = [UIImage imageNamed:@"gear_24.png"];
    [self addChildViewController:pvc];

    // Time limit
    [[Referee sharedReferee] setMaxValue:5.0f];
    
}

@end
