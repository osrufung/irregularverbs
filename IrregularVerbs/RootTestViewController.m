//
//  RootTestViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá on 30/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "RootTestViewController.h"
#import "TestCardViewController.h"
#import "TestScoreCardViewController.h"
#import "TestCase.h"
#import "TestProgressView.h"
#import "Referee.h"
#import "Verb.h"
#import "ImgIndependentHelper.h"
#import <QuartzCore/QuartzCore.h>

#define TEST_TIMER_INTERVAL 1/60.0f

@interface RootTestViewController ()

@property (nonatomic,strong) UIPageViewController *pager;

@property (nonatomic) BOOL buttonsHidden;
@property (nonatomic) float beginTime;
@property (nonatomic) float endTime;
@property (strong,nonatomic) NSTimer *testTimer;
@property (weak,nonatomic) TestCardViewController *currentCard;

@end

@implementation RootTestViewController

- (id)initWithTestCase:(TestCase *)testCase andPresenterDelegate:(id<PresentedViewControllerDelegate>) presenterDelegate {
    self = [super init];
    if (self) {
        self.testCase = testCase;
        self.pager = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                    options:@{UIPageViewControllerOptionInterPageSpacingKey:@12.0f}];
        self.pager.dataSource = self;
        self.pager.delegate = self;
        self.presentedDelegate = presenterDelegate;
        [self.view addSubview:self.pager.view];
        self.buttonsHidden = NO;
        self.progressView.backgroundColor = [UIColor clearColor];
        
        UIBarButtonItem *statsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                                     target:self
                                                                                     action:@selector(goToResults)];
        statsButton.style = UIBarButtonItemStylePlain;
        self.navigationItem.rightBarButtonItem = statsButton;
    }
    return self;
}

#pragma mark - User actions

- (IBAction)testPassed:(UIButton *)sender {
    [self endTestWithFailure:NO];
}

- (IBAction)testFailed:(UIButton *)sender {
    [self endTestWithFailure:YES];
}

#pragma mark - Test Timming

- (void)testTimerTick:(NSTimer *)timer {
    float elapsedTime = CACurrentMediaTime() - self.beginTime;
    self.progressView.progress=[[Referee sharedReferee] performanceForValue:elapsedTime];
    self.progressView.backgroundColor = [[Referee sharedReferee] colorForValue:elapsedTime];

    if ((self.progressView.progress>=0.5f)&&(self.useHints)) {
        [self.currentCard revealHint];
    }
    
    if (self.progressView.progress>=1.0f) {
        [self endTestWithFailure:YES];
    }
}

- (void)beginTest {
    if (!self.testTimer) {
        self.beginTime = CACurrentMediaTime();
        self.testTimer = [NSTimer timerWithTimeInterval:TEST_TIMER_INTERVAL
                                             target:self
                                           selector:@selector(testTimerTick:)
                                           userInfo:nil
                                            repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.testTimer forMode:NSRunLoopCommonModes];
        self.progressView.hidden = NO;
        self.progressView.progress = 0.f;
    }
}

- (void)endTestWithFailure:(BOOL)failure {
    if (self.testTimer) {
        self.endTime = CACurrentMediaTime();
        [self.testTimer invalidate];
        self.testTimer = nil;
        self.progressView.hidden=YES;
        if (failure)
            [self.currentCard.verb failTest];
        else
            [self.currentCard.verb passTestWithTime:self.responseTime];
        [self.currentCard revealResults];
    } else if (failure) {
        [self.currentCard.verb failTest];
        [self.currentCard hideTime];
    }
    [self updateButtonState];
}

- (void)cancelTest {
    if (self.testTimer) {
        [self.testTimer invalidate];
        self.testTimer = nil;
        self.progressView.progress=0;
    }
}

- (float)responseTime {
    if (self.endTime) {
        return self.endTime-self.beginTime;
    }
    return 0.f;
}


#pragma mark - View Visibility

- (void)viewWillAppear:(BOOL)animated {
    self.title = self.testCase.description;
    CGRect pbFrame = self.view.frame;
    CGRect pgFrame = self.progressView.frame;
    CGRect btFrame = self.passButton.frame;
    CGRect pagerFrame = CGRectMake(pbFrame.origin.x, pbFrame.origin.y,
                                   self.view.bounds.size.width, pbFrame.size.height-btFrame.size.height-pgFrame.size.height);
    self.pager.view.frame = pagerFrame;
    [self.pager setViewControllers:@[[self testCardViewAtIndex:0]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
     [[self view] insertSubview: [ImgIndependentHelper getBackgroundImageView] atIndex:0];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.presentedDelegate presentedViewControllerWillDisapear:self];
}

#pragma mark - UI Status

- (void)updateButtonState {
    [UIView animateWithDuration:0.3 animations:^{
        if (self.currentCard.verb.testPending) {
            self.passButton.alpha = 1;
            self.failButton.alpha = 1;
            self.passImage.alpha = 1;
            self.failImage.alpha = 1;
        } else {
            if (self.currentCard.verb.failed) {
                self.passButton.alpha = 0;
                self.failButton.alpha = 0;
                self.passImage.alpha = 0.2;
            } else {
                self.passButton.alpha = 0;
                self.failButton.alpha = 1;
                self.passImage.alpha = 1;
            }
        }
    }];
}

- (void)updateButtonFrames {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frameRect;
        if (self.buttonsHidden) {
            self.navigationItem.rightBarButtonItem.enabled = NO;

            frameRect = self.passButton.frame;
            frameRect.origin.y += frameRect.size.height;
            self.passButton.frame = frameRect;
            frameRect = self.passImage.frame;
            frameRect.origin.y += frameRect.size.height;
            self.passImage.frame = frameRect;
            frameRect = self.failButton.frame;
            frameRect.origin.y += frameRect.size.height;
            self.failButton.frame = frameRect;
            frameRect = self.failImage.frame;
            frameRect.origin.y += frameRect.size.height;
            self.failImage.frame = frameRect;
            
            frameRect = self.pager.view.frame;
            frameRect.size.height += self.passButton.frame.size.height + self.progressView.frame.size.height;
            self.pager.view.frame = frameRect;
            
        } else {
            self.navigationItem.rightBarButtonItem.enabled = YES;

            frameRect = self.passButton.frame;
            frameRect.origin.y -= frameRect.size.height;
            self.passButton.frame = frameRect;
            frameRect = self.passImage.frame;
            frameRect.origin.y -= frameRect.size.height;
            self.passImage.frame = frameRect;
            frameRect = self.failButton.frame;
            frameRect.origin.y -= frameRect.size.height;
            self.failButton.frame = frameRect;
            frameRect = self.failImage.frame;
            frameRect.origin.y -= frameRect.size.height;
            self.failImage.frame = frameRect;
            
            frameRect = self.pager.view.frame;
            frameRect.size.height -= self.passButton.frame.size.height + self.progressView.frame.size.height;
            self.pager.view.frame = frameRect;
        }
        
    }];
}

#pragma mark - TestCardViewControllerDelegate

- (void)testCardWillApperar:(TestCardViewController *)cardView {
    self.currentCard = cardView;
    [self updateButtonState];
}

- (void)testCardDidApperar:(TestCardViewController *)cardView {
    if (self.currentCard.verb.testPending) [self beginTest];
}

- (void)testCardWillDisappear:(TestCardViewController *)cardView {
    [self cancelTest];
}

#pragma mark - UIPageViewControllerDelegate


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        if ([pageViewController.viewControllers[0] isKindOfClass:[TestScoreCardViewController class]]) {
            if (!self.buttonsHidden) {
                self.buttonsHidden = YES;
                [self updateButtonFrames];
            }
        } else {
            if (self.buttonsHidden) {
                self.buttonsHidden = NO;
                [self updateButtonFrames];
            }
        }
    }
    NSLog(@"%@",pageViewController.viewControllers);
}


#pragma mark - UIPageViewControllerDataSource

- (void)goToResults {

    // We need a pager's views cache empty to ensure navigation. So we reverse the direction hidding the transition
    self.pager.view.alpha=0;
    [self.pager setViewControllers:@[[[TestScoreCardViewController alloc] initWithTestCase:self.testCase]]
                         direction:UIPageViewControllerNavigationDirectionReverse
                          animated:NO
                        completion:nil];

    // Restore visibility
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.pager.view.alpha=1;
                     }];
    if (!self.buttonsHidden) {
        self.buttonsHidden=YES;
        [self updateButtonFrames];
    }
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

- (UIViewController *)testCardViewAtIndex:(int)index {
    TestCardViewController *vc=nil;
    if((index>=0)&&(index< self.testCase.totalCount)){
        vc = [[TestCardViewController alloc] init];
        vc.delegate = self;
        vc.verb = self.testCase.verbs[index];
    }
    return vc;
}

@end
