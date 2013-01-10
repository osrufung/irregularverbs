//
//  CardsStackViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 07/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "CardsStackViewController.h"

@interface CardsStackViewController ()
//Object Data Model
//@property (nonatomic, strong) VerbsStore *store;
//@property (nonatomic, weak) IrregularVerb *verbs;
//@property (nonatomic, strong) NSArray *verbs;
//@property (nonatomic) int currentLevel;
//@property (nonatomic) BOOL includeLowerLevels;
@property (nonatomic, strong) NSMutableArray *timeStamps;
@property (nonatomic) int currentIndex;
@end

@implementation CardsStackViewController

 
//@synthesize   currentLevel = _currentLevel, includeLowerLevels = _includeLowerLevels;
@synthesize timeStamps = _timeStamps, currentIndex=_currentIndex, presentationMode;

+ (void)initialize{
    
    //load default settings values
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    
    //self.currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"difficultyLevel"];
    //self.includeLowerLevels = [[NSUserDefaults standardUserDefaults] boolForKey:@"includeLowerLevels"];
    
    self.currentIndex = [[NSUserDefaults standardUserDefaults] boolForKey:@"currentPos"];

    [self setViewControllers:@[[self verbCardAtIndex:self.currentIndex forPresentationMode:self.presentationMode]]
                   direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self.viewControllers[0] beginTest];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    CardViewController *vc = (CardViewController *) viewController;
    vc = [self verbCardAtIndex:vc.verbIndex+1 forPresentationMode:self.presentationMode];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    CardViewController *vc = (CardViewController *) viewController;
    vc = [self verbCardAtIndex:vc.verbIndex-1 forPresentationMode:self.presentationMode];
    return vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        CardViewController *vc;
        vc = previousViewControllers[0];
        [vc endTest];
        vc = pageViewController.viewControllers[0];
        [vc beginTest];
    }
}

#pragma mark - Model Managment
/*
- (VerbsStore *)store {
    if (!_store) {
        _store = [[VerbsStore alloc] init];
        _store.delegate = self;
    }
    return _store;
}
*/
/*
- (NSArray *)verbs {
 
    return [[VerbsStore sharedStore] verbsForLevel:2 includeLowerLevels:NO];
}
*/
- (CardViewController *)verbCardAtIndex:(int)index forPresentationMode:(enum CardViewControllerPresentationMode)mode {
    CardViewController *vc=nil;
    if((index>=0)&&(index< [[[VerbsStore sharedStore] allVerbs] count])){
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardViewController"];
        vc.verb = [[[VerbsStore sharedStore] allVerbs] objectAtIndex:index];
        vc.presentationMode = mode;
        vc.verbIndex=index;
        vc.randomOrder = [[VerbsStore sharedStore] randomOrder];
        
  
    }
    return vc;
}

- (void)flipsideViewControllerDidFinish:(PreferencesViewController *)controller
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
 
    
    [[VerbsStore sharedStore] setRandomOrder:[[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"]];
 
    
    // Reassign the current card with the new preferences
    [self setViewControllers:@[[self verbCardAtIndex:self.currentIndex forPresentationMode:self.presentationMode]]
                   direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


/*
 #pragma mark - IrregularVerbDelegate
 
 - (void)updateBegin {
 dispatch_async(dispatch_get_main_queue(), ^{
 [self.activityIndicator startAnimating];
 });
 }
 
 - (void)updateEnd {
 dispatch_async(dispatch_get_main_queue(), ^{
 [self.activityIndicator stopAnimating];
 [self showVerb];
 });
 }
 
 - (void)updateFailedWithError:(NSError *)error {
 dispatch_async(dispatch_get_main_queue(), ^{
 [self.activityIndicator stopAnimating];
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain
 message:error.localizedDescription
 delegate:nil
 cancelButtonTitle:@"Dimiss"
 otherButtonTitles:nil];
 [alert show];
 });
 }
 
*/


@end
