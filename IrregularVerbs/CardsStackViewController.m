//
//  CardsStackViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 07/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "CardsStackViewController.h"
#import "TestCardViewController.h"
#import "VerbsStore.h"

@interface CardsStackViewController ()
@property (nonatomic, strong) NSArray *verbs;
@end

@implementation CardsStackViewController

+ (void)initialize{
    
    //load default settings values
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]]];
}

- (NSArray *)verbs {
    if (!_verbs) {
        switch (self.presentationMode) {
            case CardViewControllerPresentationModeLearn:
                _verbs = [[VerbsStore sharedStore] alphabetic];
                break;

            case CardViewControllerPresentationModeTest:
                [[VerbsStore sharedStore] resetTest];
                _verbs = [[VerbsStore sharedStore] testSubSet];
                break;

            case CardViewControllerPresentationModeReview:
                _verbs = [[VerbsStore sharedStore] results];
                break;

            case CardViewControllerPresentationModeHistory:
                _verbs = [[VerbsStore sharedStore] history];
                break;

            default:
                break;
        }
    }
    return _verbs;
}

- (void)viewWillAppear:(BOOL)animated {
    // Everytime the view appear it begins with the current dataset
    self.verbs = nil;
    
    [self setViewControllers:@[[self verbCardAtIndex:0 forPresentationMode:self.presentationMode]]
                   direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    CardViewController *vc = (CardViewController *) viewController;
    int idx=[self.verbs indexOfObject:vc.verb];
    vc = [self verbCardAtIndex:idx+1 forPresentationMode:self.presentationMode];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    CardViewController *vc = (CardViewController *) viewController;
    int idx=[self.verbs indexOfObject:vc.verb];
    vc = [self verbCardAtIndex:idx-1 forPresentationMode:self.presentationMode];
    return vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        CardViewController *vc;
        
        //Flip a card without finishing the test implies a failure
        vc = previousViewControllers[0];
//        [vc endTestWithFailure:YES];
        vc = pageViewController.viewControllers[0];
//        [vc beginTest];
    }
}

#pragma mark - Model Managment

- (UIViewController *)verbCardAtIndex:(int)index forPresentationMode:(enum CardViewControllerPresentationMode)mode {
    if (mode!=CardViewControllerPresentationModeTest) {
        CardViewController *vc=nil;
        if((index>=0)&&(index< self.verbs.count)){
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardViewController"];
            vc.verb = [self.verbs objectAtIndex:index];
            vc.presentationMode = mode;
        }
        return vc;
    } else {
        TestCardViewController *vc=nil;
        if((index>=0)&&(index< self.verbs.count)){
            vc = [[TestCardViewController alloc] init];
            vc.verb = [self.verbs objectAtIndex:index];
        }
        return vc;
    }
}

@end
