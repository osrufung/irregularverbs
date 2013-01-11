//
//  CardsStackViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 07/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "CardsStackViewController.h"
#import "VerbsStore.h"

@interface CardsStackViewController ()
@property (nonatomic, strong) NSMutableArray *timeStamps;
@property (nonatomic) int currentIndex;
@end

@implementation CardsStackViewController

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
    
    self.currentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentPos"];
    if (self.currentIndex>=self.verbs.count) self.currentIndex=self.verbs.count-1;

    [self setViewControllers:@[[self verbCardAtIndex:self.currentIndex forPresentationMode:self.presentationMode]]
                   direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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
        
        //Flip a card without finishing the test implies a failure
        vc = previousViewControllers[0];
        [vc endTestWithFailure:YES];
        vc = pageViewController.viewControllers[0];
        [vc beginTest];
    }
}

- (NSArray *)verbsSortedByPerformance {
    return [self.verbs sortedArrayUsingSelector:@selector(compareVerbsByTestResults:)];
}

- (NSArray *)verbsSortedByHistory {
    return [self.verbs sortedArrayUsingSelector:@selector(compareVerbsByHistoricalPerformance:)];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.presentationMode==CardViewControllerPresentationModeReview) {
        self.currentIndex=0;
        self.verbs = [self verbsSortedByPerformance];
        [self setViewControllers:@[[self verbCardAtIndex:self.currentIndex forPresentationMode:self.presentationMode]]
                       direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];        
    } else if (self.presentationMode==CardViewControllerPresentationModeHistory) {
        self.currentIndex=0;
        self.verbs = [self verbsSortedByHistory];
        [self setViewControllers:@[[self verbCardAtIndex:self.currentIndex forPresentationMode:self.presentationMode]]
                       direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else if (self.presentationMode==CardViewControllerPresentationModeTest) {
        self.currentIndex=0;
        for (Verb *verb in self.verbs) [verb resetCurrentTest];
        [self setViewControllers:@[[self verbCardAtIndex:self.currentIndex forPresentationMode:self.presentationMode]]
                       direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
    }
}

#pragma mark - Model Managment

- (CardViewController *)verbCardAtIndex:(int)index forPresentationMode:(enum CardViewControllerPresentationMode)mode {
    CardViewController *vc=nil;
    if((index>=0)&&(index< self.verbs.count)){
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardViewController"];
        vc.verb = [self.verbs objectAtIndex:index];
        vc.presentationMode = mode;
        vc.verbIndex=index;
    }
    return vc;
}

@end
