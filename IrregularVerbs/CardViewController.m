//
//  ViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CardViewController.h"
#import "Referee.h"

#define TEST_TIMER_INTERVAL 1/30.f

@interface CardViewController ()
{
    float _beginTestTime, _endTestTime;
    NSTimer *_testTimer;
}

@end

@implementation CardViewController

@synthesize currentLevel = _currentLevel, includeLowerLevels = _includeLowerLevels;
@synthesize verb=_verb, presentationMode, verbIndex=_verbIndex, randomOrder=_randomOrder;

#pragma mark - Setup

- (void)setupGestureRecognizers {
    UISwipeGestureRecognizer *swUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(EndTestWithGesture:)];
    UISwipeGestureRecognizer *swDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(EndTestWithGesture:)];
    swUp.direction = UISwipeGestureRecognizerDirectionUp;
    swDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swUp];
    [self.view addGestureRecognizer:swDown];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureRecognizers];
}

#pragma mark - User Interface

- (void)testTimerTick:(NSTimer *)timer {
    float elapsedTime = CACurrentMediaTime() - _beginTestTime;
    self.testProgress.progress=[[Referee sharedReferee] performanceForValue:elapsedTime];
    self.testProgress.backgroundColor = [[Referee sharedReferee] colorForValue:elapsedTime];
    if (self.testProgress.progress>=1.0f) {
        [self endTest];
        [self showResultsWithAnimation:YES];
    }
}

- (void)beginTest {
    if (self.presentationMode!=CardViewControllerPresentationModeTest) return;
    if (!_testTimer) {
        _beginTestTime = CACurrentMediaTime();
        _testTimer = [NSTimer scheduledTimerWithTimeInterval:TEST_TIMER_INTERVAL
                                                      target:self
                                                    selector:@selector(testTimerTick:)
                                                    userInfo:nil
                                                     repeats:YES];
        self.testProgress.hidden = NO;
        self.testProgress.progress = 0.f;
    }
}

- (void)endTest {
    if (self.presentationMode!=CardViewControllerPresentationModeTest) return;
    if (_testTimer) {
        _endTestTime = CACurrentMediaTime();
        [_testTimer invalidate];
        _testTimer = nil;
        self.testProgress.hidden=YES;
        NSLog(@"ResponseTime %f for %@",self.responseTime, self.verb[@"simple"]);
    }
}

- (float)responseTime {
    if (_endTestTime) {
        return _endTestTime-_beginTestTime;
    }
    return 0.f;
}


-(void)setLabelLevelText {
    if(self.currentLevel < 4){
        NSString *format = (self.includeLowerLevels)?@"To level %d":@"Level %d";
        self.labelLevel.text = [NSString stringWithFormat:format, self.currentLevel];
    }
    else{
        self.labelLevel.text = [NSString stringWithFormat:@"All levels"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self showVerb];
    [self setLabelLevelText];
    self.shuffleIndicator.hidden=!self.randomOrder;
    self.imageTestResult.image=nil;
    if (self.presentationMode == CardViewControllerPresentationModeReview) [self showResultsWithAnimation:NO];
    if (self.presentationMode == CardViewControllerPresentationModeTest) [self beginTest];
}

- (void)setVerb:(NSDictionary *)verb {
    if (verb!=_verb) _verb=verb;
}

- (void)showVerb {
    self.labelPresent.text = self.verb[@"simple"];
    self.labelTranslation.text = @"";
    self.labelPast.text = @"" ;
    self.labelParticiple.text = @"" ;
    self.labelElapsedTime.text = @"";
    
    if(self.presentationMode != CardViewControllerPresentationModeTest) {
        self.labelTranslation.text = self.verb[@"translation"];
        self.labelPast.text = self.verb[@"past"];;
        self.labelParticiple.text = self.verb[@"participle"];;
    }
    
}

- (void)showResultsWithAnimation:(BOOL)animation {
    self.labelTranslation.text = self.verb[@"translation"];
    self.labelPast.text = self.verb[@"past"];;
    self.labelParticiple.text = self.verb[@"participle"];
    self.labelElapsedTime.text = [NSString stringWithFormat:@"%.2fs",self.responseTime];
    self.labelElapsedTime.textColor = [[Referee sharedReferee] colorForValue:self.responseTime];
    if ((animation)&&(self.labelPast.text==@"")) {
        [self fadeView:self.labelElapsedTime from:0.0 to:1.0 ];
        [self fadeView:self.labelPast from:0.0 to:1.0 ];
        [self fadeView:self.labelParticiple from:0.0 to:1.0];
        [self fadeView:self.labelTranslation from:0.0 to:1.0];
    }
}

- (void)EndTestWithGesture:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self endTest];
    [self showResultsWithAnimation:YES];
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        self.imageTestResult.image = [[Referee sharedReferee] checkedImageForValue:self.responseTime];
    }
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        self.imageTestResult.image = [[Referee sharedReferee] failedImage];
    }
}

#pragma mark - Helpers CAAnimation

- (void)fadeView:(UIView *)view from:(CGFloat)initialAlpha to:(CGFloat)finalAlpha {
    CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fader.duration=0.3;
    fader.fromValue= [NSNumber numberWithFloat:initialAlpha];
    fader.toValue=[NSNumber numberWithFloat:finalAlpha];
    [view.layer addAnimation:fader forKey:@"fadeAnimation"];
    view.layer.opacity = finalAlpha;
}

#pragma mark - Flipside View

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self.parentViewController];
    }
}

@end
