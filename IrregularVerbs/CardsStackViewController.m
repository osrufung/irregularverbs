//
//  CardsStackViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 07/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "CardsStackViewController.h"

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
        vc = previousViewControllers[0];
        [vc endTest];
        vc = pageViewController.viewControllers[0];
        [vc beginTest];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.presentationMode==CardViewControllerPresentationModeReview) {
        self.verbs =[self.verbs sortedArrayUsingComparator:^(id ob1, id ob2){
            Verb *v1=ob1;
            Verb *v2=ob2;
            
            if (v1.failed && v2.failed) {
                return [v1.simple compare:v2.simple];
            } else if (v1.failed && !v2.failed) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if (!v1.failed && v2.failed) {
                return (NSComparisonResult)NSOrderedDescending;
            } else {
                if (v1.responseTime>v2.responseTime) {
                    return (NSComparisonResult)NSOrderedAscending;
                } else if(v1.responseTime<v2.responseTime) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                else return [v1.simple compare:v2.simple];
            }
        }];
        self.currentIndex=0;
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
        vc.randomOrder = self.randomOrder;
    }
    return vc;
}

- (void)flipsideViewControllerDidFinish:(PreferencesViewController *)controller
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
 
    
    //[[VerbsStore sharedStore] setRandomOrder:[[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"]];
 
    
    // Reassign the current card with the new preferences
    [self setViewControllers:@[[self verbCardAtIndex:self.currentIndex forPresentationMode:self.presentationMode]]
                   direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

@end
