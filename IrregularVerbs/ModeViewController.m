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

@interface ModeViewController ()

@end

@implementation ModeViewController

- (void)viewDidLoad
{
    CardsStackViewController *vc;

    [super viewDidLoad];
    
  //  _verbs = [[VerbsStore sharedStore] allVerbs];
    float freq = [[NSUserDefaults standardUserDefaults] floatForKey:@"frequency"];
    if (freq==0) freq=0.2;
    _verbs = [[VerbsStore sharedStore] verbsForDifficulty:freq];
    
    // Create the CardsStackViewControllers
    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeLearn;
    vc.title = @"Learn";
    vc.tabBarItem.image = [UIImage imageNamed:@"book_bookmark_24.png"];
    vc.verbs = _verbs;
    vc.randomOrder = [[VerbsStore sharedStore] randomOrder];
    [self addChildViewController:vc];

    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeTest;
    vc.title = @"Test";
    vc.tabBarItem.image = [UIImage imageNamed:@"clock_24.png"];
    vc.verbs = _verbs;
    vc.randomOrder = [[VerbsStore sharedStore] randomOrder];
    [self addChildViewController:vc];

    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeReview;
    vc.title = @"Review";
    vc.tabBarItem.image = [UIImage imageNamed:@"chart_bar_24.png"];
    vc.verbs = _verbs;
    vc.randomOrder = [[VerbsStore sharedStore] randomOrder];
    [self addChildViewController:vc];
    
    // Time limit
    [[Referee sharedReferee] setMaxValue:5.0f];
}

@end
