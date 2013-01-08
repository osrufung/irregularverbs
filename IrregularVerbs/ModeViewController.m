//
//  ModeViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 08/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

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
    
    // Create the CardsStackViewControllers
    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeLearn;
    vc.title = @"Learn";
    vc.tabBarItem.image = [UIImage imageNamed:@"book_bookmark_24.png"];
    [self addChildViewController:vc];

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
    
    // Time limit
    [[Referee sharedReferee] setMaxValue:5.0f];
}

@end
