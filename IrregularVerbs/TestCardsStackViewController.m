//
//  TestCardsStackViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 16/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "TestCardsStackViewController.h"
#import "TestCardViewController.h"
#import "TestScoreCardViewController.h"
#import "VerbsStore.h"
#import "TestCase.h"
#import "Verb.h"

@interface TestCardsStackViewController ()

@end

@implementation TestCardsStackViewController

- (id)initWithTestCase:(TestCase *)testCase {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@12.0f}];
    if (self) {
        self.dataSource = self;
        self.testCase = testCase;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = self.testCase.description;
    
 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
   
    [self setViewControllers:@[[self testCardViewAtIndex:0]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
 
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.presentedDelegate presentedViewControllerWillDisapear:self];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isMemberOfClass:[TestScoreCardViewController class]]) {
        return nil;
    }
    if ([viewController isMemberOfClass:[TestCardViewController class]]) {
        TestCardViewController *current = (TestCardViewController *)viewController;
        UIViewController *next = [self testCardViewAtIndex:[self.testCase.verbs indexOfObject:current.verb]+1];
        if (!next) {
            return [[TestScoreCardViewController alloc] initWithTestCase:self.testCase];
        }
        return next;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isMemberOfClass:[TestScoreCardViewController class]]) {
        return [self testCardViewAtIndex:self.testCase.totalCount-1];
    }
    if ([viewController isMemberOfClass:[TestCardViewController class]]) {
        TestCardViewController *current = (TestCardViewController *)viewController;
        return [self testCardViewAtIndex:[self.testCase.verbs indexOfObject:current.verb]-1];
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.testCase.totalCount+1;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    TestCardViewController *current = (TestCardViewController *)pageViewController.childViewControllers[0];
    return [self.testCase.verbs indexOfObject:current.verb];
}

- (UIViewController *)testCardViewAtIndex:(int)index {
    TestCardViewController *vc=nil;
    if((index>=0)&&(index< self.testCase.totalCount)){
        vc = [[TestCardViewController alloc] init];
        vc.verb = self.testCase.verbs[index];
    }
    return vc;   
}

@end
