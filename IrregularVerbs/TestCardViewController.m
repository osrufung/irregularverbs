//
//  TestCardViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 15/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "Verb.h"
#import "TestCardViewController.h"
#import "TestProgressView.h"
#import "Referee.h"

#define TEST_TIMER_INTERVAL 1/60.0f

@interface TestCardViewController ()
{
    float _beginTestTime;
    float _endTestTime;
    NSTimer * _testTimer;
}
@property (weak, nonatomic) IBOutlet UILabel *labelSimple;
@property (weak, nonatomic) IBOutlet UILabel *labelTranslation;
@property (weak, nonatomic) IBOutlet UILabel *labelPast;
@property (weak, nonatomic) IBOutlet UILabel *labelParticiple;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonFail;
@property (weak, nonatomic) IBOutlet UIButton *buttonPass;
@property (weak, nonatomic) IBOutlet TestProgressView *testProgress;
@property (weak, nonatomic) IBOutlet UIImageView *imageFail;
@property (weak, nonatomic) IBOutlet UIImageView *imagePass;

@end

@implementation TestCardViewController

#pragma mark - Test events

- (void)testTimerTick:(NSTimer *)timer {
    float elapsedTime = CACurrentMediaTime() - _beginTestTime;
    self.testProgress.progress=[[Referee sharedReferee] performanceForValue:elapsedTime];
    self.testProgress.backgroundColor = [[Referee sharedReferee] colorForValue:elapsedTime];
    if (self.testProgress.progress>=1.0f) {
        [self endTestWithFailure:YES];
        [self refreshUIForTestEnd:YES];
    }
}

- (void)beginTest {
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
    }
}

- (void)endTestWithFailure:(BOOL)failure {
    if (_testTimer) {
        _endTestTime = CACurrentMediaTime();
        [_testTimer invalidate];
        _testTimer = nil;
        self.testProgress.hidden=YES;
        if (failure)
            [self.verb failTest];
        else
            [self.verb passTestWithTime:self.responseTime];
    } else if (failure) [self.verb failTest];
}

- (void)cancelTest {
    if (_testTimer) {
        [_testTimer invalidate];
        _testTimer = nil;
    }
}

- (float)responseTime {
    if (_endTestTime) {
        return _endTestTime-_beginTestTime;
    }
    return 0.f;
}

#pragma mark - View lifecicle

- (void)viewWillAppear:(BOOL)animated {
    [self refreshUIForTestEnd:NO];
    if (self.verb.testPending) [self beginTest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self cancelTest];
}

#pragma mark - UI

/* 
 What want we show?
 
 - ViewWillAppear
    If test is done all the data without animations
    If test is pendding only simple tense
 
 - EndTestWithFailure
    If is a new verb All verb data animated
    If is a correction to a previous pass verb, change the data without animation
    If is a failure show failure picture and remove all buttons
    If is a pass show time, pass picture and remove pushUp button
 */


- (void)refreshUIForTestEnd:(BOOL)testEnd {
    
    BOOL isACorrection = (self.imagePass.image!=nil);
    
    self.labelSimple.text = self.verb.simple;    
    self.labelTranslation.text = @"";
    self.labelPast.text = @"";
    self.labelParticiple.text = @"";
    self.labelTime.text = @"";

    if (!self.verb.testPending) {
        self.labelTranslation.text = self.verb.translation;
        self.labelPast.text = self.verb.past;
        self.labelParticiple.text = self.verb.participle;
        if (self.verb.failed) {
            self.imageFail.image = [[Referee sharedReferee] imageForFail];
            self.imagePass.image = nil;
            if (isACorrection) {
                self.imageFail.alpha = 1;
                self.buttonFail.alpha = 0;
                self.buttonPass.alpha = 0;
            }
        } else {
            self.labelTime.text = [NSString stringWithFormat:@"%.2fs",self.verb.responseTime];
            self.labelTime.textColor = [[Referee sharedReferee] colorForValue:self.verb.responseTime];
            self.imagePass.image = [[Referee sharedReferee] imageForValue:self.verb.responseTime];
            self.imageFail.image = nil;
        }
    }
    
    if ((testEnd)&&(!isACorrection)) {
        self.labelTranslation.alpha = 0;
        self.labelPast.alpha = 0;
        self.labelParticiple.alpha = 0;
        self.labelTime.alpha = 0;
        self.imageFail.alpha = 0;
        self.imagePass.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.labelTranslation.alpha = 1;
            self.labelPast.alpha = 1;
            self.labelParticiple.alpha = 1;
            self.labelTime.alpha = 1;
            if (self.verb.failed) {
                self.buttonFail.alpha = 0;
                self.buttonPass.alpha = 0;
                self.imageFail.alpha = 1;
            } else {
                self.buttonPass.alpha = 0;
                self.imagePass.alpha = 1;
            }
        }];
    }
}

#pragma mark - User Interaction

- (IBAction)chooseFail:(UIButton *)sender {
    [self endTestWithFailure:YES];
    [self refreshUIForTestEnd:YES];
}
- (IBAction)choosePass:(UIButton *)sender {
    [self endTestWithFailure:NO];
    [self refreshUIForTestEnd:YES];
}

@end
