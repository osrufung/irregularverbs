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


@interface ModeViewController ()
{
    BOOL _cacheRandomOrder;
    float _cacheFrequency;
}

@property (nonatomic,readonly) BOOL defaultsChanged;

@end

@implementation ModeViewController

- (void)viewDidLoad
{
    CardsStackViewController *vc;

    [super viewDidLoad];
    
    self.delegate=self;
    
    _cacheFrequency = [[NSUserDefaults standardUserDefaults] floatForKey:@"frequency"];
    _cacheRandomOrder = [[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"];
    [self loadVerbs];
    
    // Create the CardsStackViewControllers
    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeLearn;
    vc.title = @"Learn";
    vc.tabBarItem.image = [UIImage imageNamed:@"book_bookmark_24.png"];
    vc.verbs = _verbs;
    [self addChildViewController:vc];

    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeTest;
    vc.title = @"Test";
    vc.tabBarItem.image = [UIImage imageNamed:@"clock_24.png"];
    vc.verbs = _verbs;
    [self addChildViewController:vc];

    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeReview;
    vc.title = @"Review";
    vc.tabBarItem.image = [UIImage imageNamed:@"chart_bar_24.png"];
    vc.verbs = _verbs;
    [self addChildViewController:vc];

    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardsStackViewController"];
    vc.presentationMode = CardViewControllerPresentationModeHistory;
    vc.title = @"History";
    vc.tabBarItem.image = [UIImage imageNamed:@"calendar_24.png"];
    vc.verbs = _verbs;
    [self addChildViewController:vc];
    
    PreferencesViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PreferencesViewController"];
    pvc.title = @"Config";
    pvc.tabBarItem.image = [UIImage imageNamed:@"gear_24.png"];
    [self addChildViewController:pvc];

    // Time limit
    [[Referee sharedReferee] setMaxValue:5.0f];
    
}

- (void)loadVerbs {
    if (_cacheFrequency==0) _cacheFrequency=0.2;
    _verbs = [[VerbsStore sharedStore] verbsForDifficulty:_cacheFrequency];
    NSLog(@"Using %d verbs for freq=%.2f",_verbs.count,_cacheFrequency);
    
    if (_cacheRandomOrder) {
        _verbs = [_verbs shuffledCopy];
    } else {
        _verbs = [_verbs sortedArrayUsingComparator:compareVerbsAlphabeticaly];
    }
}



- (BOOL)defaultsChanged {
    float newFreq = [[NSUserDefaults standardUserDefaults] floatForKey:@"frequency"];
    BOOL newOrder = [[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"];
    
    if((newFreq!=_cacheFrequency)||(newOrder!=_cacheRandomOrder))
    {
        NSLog(@"Defaults changed");
        _cacheFrequency=newFreq;
        _cacheRandomOrder=newOrder;
        [self loadVerbs];
        return YES;
    } else return NO;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (self.defaultsChanged) {
        for (UIViewController *vc in self.viewControllers) {
            if ([vc isKindOfClass:[CardsStackViewController class]]) {
                CardsStackViewController *csvc = (CardsStackViewController *)viewController;
                csvc.verbs = _verbs;
            }
        }
    }
}

@end
