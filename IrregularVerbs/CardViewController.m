//
//  ViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CardViewController.h"

#define MIN_TEST_TIME   1.f
#define MED_TEST_TIME   3.f
#define MAX_TEST_TIME   5.f
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
    self.testProgress.progress=elapsedTime/MAX_TEST_TIME;
    self.testProgress.backgroundColor = [self colorFromResponseTime:elapsedTime];
    if (elapsedTime>=MAX_TEST_TIME) {
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
        self.testProgress.progress=self.responseTime/MAX_TEST_TIME;
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
    self.labelElapsedTime.textColor = [self colorFromResponseTime:self.responseTime];
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
        self.imageTestResult.image = [self paintImage:[UIImage imageNamed:@"checkmark_64.png"] withColor:[self colorFromResponseTime:self.responseTime]];
    }
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        self.imageTestResult.image = [self paintImage:[UIImage imageNamed:@"delete_64.png"] withColor:[UIColor redColor]];
    }
}

-(UIImage *)paintImage:(UIImage *)image withColor:(UIColor *)color
{
    UIImage *img;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    [image drawAtPoint:CGPointZero blendMode:kCGBlendModeDestinationIn alpha:1.0];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    return img;
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

- (UIColor *)interpolateBetween:(UIColor *)c1 and:(UIColor *)c2 atMix:(float)mix {
    float r1,g1,b1,a1,r2,g2,b2,a2;
    
    [c1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [c2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    return [UIColor colorWithRed:r1+(r2-r1)*mix
                           green:g1+(g2-g1)*mix
                            blue:b1+(b2-b1)*mix
                           alpha:a1+(a2-a1)*mix];
}

- (UIColor *)colorFromResponseTime:(float)responseTime {
    
    if (responseTime<MIN_TEST_TIME) {
        return [UIColor greenColor];
    } else if (responseTime<MED_TEST_TIME) {
        return [self interpolateBetween:[UIColor greenColor]
                                    and:[UIColor orangeColor]
                                  atMix:(responseTime-MIN_TEST_TIME)/(MED_TEST_TIME-MIN_TEST_TIME)];
    } else if (responseTime<MAX_TEST_TIME) {
        return [self interpolateBetween:[UIColor orangeColor]
                                    and:[UIColor redColor]
                                  atMix:(responseTime-MED_TEST_TIME)/(MAX_TEST_TIME-MED_TEST_TIME)];
    }
    return [UIColor redColor];
}

@end
