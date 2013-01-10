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

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    
    
}

#pragma mark - User Interface

- (void)testTimerTick:(NSTimer *)timer {
    float elapsedTime = CACurrentMediaTime() - _beginTestTime;
    self.testProgress.progress=[[Referee sharedReferee] performanceForValue:elapsedTime];
    self.testProgress.backgroundColor = [[Referee sharedReferee] colorForValue:elapsedTime];
    if (self.testProgress.progress>=1.0f) {
        [self endTest];
        self.verb.failed=YES;
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

- (void)endTest {
    if (self.presentationMode!=CardViewControllerPresentationModeTest) return;
    if (_testTimer) {
        _endTestTime = CACurrentMediaTime();
        [_testTimer invalidate];
        _testTimer = nil;
        self.testProgress.hidden=YES;
        [self.verb addNewResponseTime:self.responseTime];
        [self removeGestureRecognizers];
        
    }
}

- (float)responseTime {
    if (_endTestTime) {
        return _endTestTime-_beginTestTime;
    }
    return 0.f;
}


- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Cambio de pestaña en mdo %d", [self presentationMode]);
    
  
    [self showVerb];
    self.shuffleIndicator.hidden=!self.randomOrder;
    self.imageTestResult.image=nil;
    if (self.presentationMode == CardViewControllerPresentationModeReview) [self showResultsWithAnimation:NO];
    if (self.presentationMode == CardViewControllerPresentationModeTest) [self beginTest];
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
    
    if (self.presentationMode == CardViewControllerPresentationModeTest){
        self.labelElapsedTime.text = [NSString stringWithFormat:@"%.2fs",self.responseTime];
    }
    else if (self.presentationMode == CardViewControllerPresentationModeReview){
        if (self.verb.failed) self.labelElapsedTime.text=@"";
        else self.labelElapsedTime.text = [NSString stringWithFormat:@"%.2fs", [self.verb responseTime]];
    }
        
        
    if (self.verb.failed) {
        self.labelElapsedTime.textColor = [[Referee sharedReferee] colorForFail];
        self.imageTestResult.image = [[Referee sharedReferee] imageForFail];
    } else {
        if (self.presentationMode == CardViewControllerPresentationModeReview){
            self.labelElapsedTime.textColor = [[Referee sharedReferee] colorForValue:[self.verb responseTime]];
            self.imageTestResult.image = [[Referee sharedReferee] imageForValue:[self.verb responseTime]];
        } else {
            self.labelElapsedTime.textColor = [[Referee sharedReferee] colorForValue:self.responseTime];
            self.imageTestResult.image = [[Referee sharedReferee] imageForValue:self.responseTime];
        }
    }
    if ((animation)&&(self.labelPast.text==@"")) {
        [self fadeView:self.labelElapsedTime from:0.0 to:1.0 ];
        [self fadeView:self.labelPast from:0.0 to:1.0 ];
        [self fadeView:self.labelParticiple from:0.0 to:1.0];
        [self fadeView:self.labelTranslation from:0.0 to:1.0];
    }
}

- (void)EndTestWithGesture:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self endTest];
    switch (gestureRecognizer.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            self.verb.failed=NO;
            break;
        case UISwipeGestureRecognizerDirectionDown:
            self.verb.failed=YES;
            break;
        default:
            break;
    }
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

#pragma mark - Flipside View

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self.parentViewController];
    }
}

@end
