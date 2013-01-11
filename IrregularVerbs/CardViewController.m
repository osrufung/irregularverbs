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
#import "VerbsStore.h"

#define TEST_TIMER_INTERVAL 1/30.f

@interface CardViewController ()
{
    float _beginTestTime, _endTestTime;
    NSTimer *_testTimer;
}

@property (nonatomic,strong) UISwipeGestureRecognizer *swUp;
@property (nonatomic,strong) UISwipeGestureRecognizer *swDown;


@end

@implementation CardViewController

#pragma mark - Setup

- (UISwipeGestureRecognizer *)swUp {
    if(!_swUp) {
        _swUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(EndTestWithGesture:)];
        _swUp.direction = UISwipeGestureRecognizerDirectionUp;
    }
    return _swUp;
}

- (UISwipeGestureRecognizer *)swDown {
    if(!_swDown) {
        _swDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(EndTestWithGesture:)];
        _swDown.direction = UISwipeGestureRecognizerDirectionDown;
    }
    return _swDown;
}


- (void)addGestureRecognizers {
    [self.view addGestureRecognizer:self.swUp];
    [self.view addGestureRecognizer:self.swDown];
}

- (void)removeGestureRecognizers {
    [self.view removeGestureRecognizer:self.swUp];
    [self.view removeGestureRecognizer:self.swDown];
}

#pragma mark - User Interface

- (void)testTimerTick:(NSTimer *)timer {
    float elapsedTime = CACurrentMediaTime() - _beginTestTime;
    self.testProgress.progress=[[Referee sharedReferee] performanceForValue:elapsedTime];
    self.testProgress.backgroundColor = [[Referee sharedReferee] colorForValue:elapsedTime];
    if (self.testProgress.progress>=1.0f) {
        [self endTestWithFailure:YES];
        [self showResultsWithAnimation:YES];
    }
}

- (void)beginTest {
    if (self.presentationMode!=CardViewControllerPresentationModeTest) return;
    if (!_testTimer) {
        _beginTestTime = CACurrentMediaTime();
        _testTimer = [NSTimer timerWithTimeInterval:TEST_TIMER_INTERVAL
                                             target:self
                                           selector:@selector(testTimerTick:)
                                           userInfo:nil
                                            repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_testTimer forMode:NSRunLoopCommonModes];
        self.testProgress.hidden = NO;
        self.testProgress.progress = 0.f;
        [self addGestureRecognizers];
    }
}

- (void)endTestWithFailure:(BOOL)failure {
    if (self.presentationMode!=CardViewControllerPresentationModeTest) return;
    if (_testTimer) {
        _endTestTime = CACurrentMediaTime();
        [_testTimer invalidate];
        _testTimer = nil;
        self.testProgress.hidden=YES;
        [self removeGestureRecognizers];
        if (failure)
            [self.verb failTest];
        else
            [self.verb passTestWithTime:self.responseTime];
    }
}

- (float)responseTime {
    if (_endTestTime) {
        return _endTestTime-_beginTestTime;
    }
    return 0.f;
}

- (void)defaultsChanged:(NSNotification *)notification {
    self.shuffleIndicator.hidden=![[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self showVerb];
    self.shuffleIndicator.hidden=![[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"];
    self.imageTestResult.image=nil;
    if (self.presentationMode == CardViewControllerPresentationModeReview) [self showResultsWithAnimation:NO];
    if (self.presentationMode == CardViewControllerPresentationModeHistory) [self showResultsWithAnimation:NO];
    if (self.presentationMode == CardViewControllerPresentationModeTest) [self beginTest];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(defaultsChanged:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
}

// Important
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setVerb:(Verb *)verb {
    if (verb!=_verb) _verb=verb;
}

- (void)showVerb {
    self.labelPresent.text = self.verb.simple;
    self.labelTranslation.text = @"";
    self.labelPast.text = @"" ;
    self.labelParticiple.text = @"" ;
    self.labelElapsedTime.text = @"";
    self.labelFailureRatio.text = @"";
    
    if(self.presentationMode != CardViewControllerPresentationModeTest) {
        self.labelTranslation.text = self.verb.translation;
        self.labelPast.text = self.verb.past;
        self.labelParticiple.text = self.verb.participle;
    }
}

- (void)showResultsWithAnimation:(BOOL)animation {
    self.labelTranslation.text = self.verb.translation;
    self.labelPast.text = self.verb.past;
    self.labelParticiple.text = self.verb.participle;
    
    if ((self.presentationMode == CardViewControllerPresentationModeTest)||(self.presentationMode == CardViewControllerPresentationModeReview)){
        if(!self.verb.failed) self.labelElapsedTime.text = [NSString stringWithFormat:@"%.2fs",self.verb.responseTime];
    }
    else if (self.presentationMode == CardViewControllerPresentationModeHistory) {
        self.labelFailureRatio.text = [NSString stringWithFormat:@"Failures %d%%",(int)(self.verb.failureRatio*100.0)];
        self.labelElapsedTime.text = [NSString stringWithFormat:@"Average %.2fs",self.verb.averageResponseTime];
    }
        
    if ((self.presentationMode == CardViewControllerPresentationModeTest)||(self.presentationMode == CardViewControllerPresentationModeReview)){
        if (self.verb.failed) {
            self.labelElapsedTime.textColor = [[Referee sharedReferee] colorForFail];
            self.imageTestResult.image = [[Referee sharedReferee] imageForFail];
        } else {
            self.labelElapsedTime.textColor = [[Referee sharedReferee] colorForValue:self.verb.responseTime];
            self.imageTestResult.image = [[Referee sharedReferee] imageForValue:self.verb.responseTime];
        }
    } else if (self.presentationMode == CardViewControllerPresentationModeHistory) {
        self.labelFailureRatio.textColor = [[Referee sharedReferee] colorForFail];
        self.labelElapsedTime.textColor = [[Referee sharedReferee] colorForValue:self.verb.averageResponseTime];
        self.imageTestResult.image = nil;
    }
    
    if ((animation)&&(self.labelPast.text==@"")) {
        [self fadeView:self.labelPast from:0.0 to:1.0 ];
        [self fadeView:self.labelParticiple from:0.0 to:1.0];
        [self fadeView:self.labelTranslation from:0.0 to:1.0];
        [self fadeView:self.labelElapsedTime from:0.0 to:1.0 ];
        [self fadeView:self.labelFailureRatio from:0.0 to:1.0 ];

    }
}

- (void)EndTestWithGesture:(UISwipeGestureRecognizer *)gestureRecognizer {
    BOOL failGesture = (gestureRecognizer.direction==UISwipeGestureRecognizerDirectionDown);
    [self endTestWithFailure:failGesture];
    [self showResultsWithAnimation:YES];
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

@end
