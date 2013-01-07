//
//  ViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CardViewController.h"

@interface CardViewController ()

@end

@implementation CardViewController

@synthesize currentLevel = _currentLevel, includeLowerLevels = _includeLowerLevels;
@synthesize verb=_verb, presentationMode, verbIndex=_verbIndex, randomOrder=_randomOrder;
@synthesize beginTestTime = _beginTestTime, endTestTime = _endTestTime;

#pragma mark - Setup

- (void)setupGestureRecognizers {
    UISwipeGestureRecognizer *swUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(showVerbalForms:)];
    UISwipeGestureRecognizer *swDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(showVerbalForms:)];
    UILongPressGestureRecognizer *tapHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(showResults:)];
    swUp.direction = UISwipeGestureRecognizerDirectionUp;
    swUp.delegate = self;
    swDown.direction = UISwipeGestureRecognizerDirectionDown;
    swDown.delegate = self;
    tapHold.delegate = self;
    
    [self.view addGestureRecognizer:swUp];
    [self.view addGestureRecognizer:swDown];
    [self.view addGestureRecognizer:tapHold];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureRecognizers];
   
    //init the VisualMap view
    self.visualMap.dataSource = self;
    self.visualMap.delegate = self;
}

#pragma mark - User Interface

- (void)setEndTestTime:(double)endTestTime {
    _endTestTime = endTestTime;
    NSLog(@"%f sec",self.endTestTime-self.beginTestTime);
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
    if (self.presentationMode == CardViewControllerPresentationModeTest) self.beginTestTime = CACurrentMediaTime();
}

/*
- (void)timeStampCurrentVerb {
    double CurrentTime = CACurrentMediaTime();
    NSLog(@"Current time Diff %f seconds", CurrentTime  - [self lastTimingValue]  );
    double diff_time = CurrentTime - [self lastTimingValue]  ;
        
    [self setLastTimingValue:CurrentTime];
    //mark new verb
    [self.timeStamps replaceObjectAtIndex:self.verbs.currentPos withObject:[NSNumber numberWithInt:(int)diff_time+1]];
    [self.visualMap setNeedsDisplay];
}
 */

- (void)setVerb:(NSDictionary *)verb {
    if (verb!=_verb) _verb=verb;
}

- (void)showVerb {
    self.labelPresent.text = self.verb[@"simple"];
    self.labelTranslation.text = @"";
    self.labelPast.text = @"" ;
    self.labelParticiple.text = @"" ;
    
    if(self.presentationMode == CardViewControllerPresentationModeLearn) {
        self.labelTranslation.text = self.verb[@"translation"];
        self.labelPast.text = self.verb[@"past"];;
        self.labelParticiple.text = self.verb[@"participle"];;
    }
    
}

- (void)showVerbalForms:(UIGestureRecognizer *)gr {
    if (self.labelPast.text.length==0) {
        self.endTestTime = CACurrentMediaTime();
        self.labelTranslation.text = self.verb[@"translation"];
        self.labelPast.text = self.verb[@"past"];;
        self.labelParticiple.text = self.verb[@"participle"];;
        if (gr) {
            [self fadeView:self.labelPast from:0.0 to:1.0 ];
            [self fadeView:self.labelParticiple from:0.0 to:1.0];
            [self fadeView:self.labelTranslation from:0.0 to:1.0];
        }
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint p = [touch locationInView:gestureRecognizer.view];
    return !CGRectContainsPoint(self.visualMap.frame, p);
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

- (void)moveYView:(UIView *)view from:(CGFloat)begin to:(CGFloat)end duration:(CGFloat)seconds {
    //1.1 Animate new verb introduction
    CABasicAnimation *swipeInAnimation = [CABasicAnimation
                                          animationWithKeyPath:@"transform.translation.y"];
    swipeInAnimation.duration = seconds;
    swipeInAnimation.fromValue = [NSNumber numberWithFloat:begin];
    swipeInAnimation.toValue = [NSNumber numberWithFloat:end];
    swipeInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [view.layer addAnimation:swipeInAnimation forKey:@"moveAnimation"];
    
}
#pragma mark - Flipside View

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self.parentViewController];
    }
}

#pragma mark - ColorMapViewDataSource

- (int)numberOfItemsInColorMapView:(ColorMapView *)colorMapView {
   // return self.verbs.count;
    return 0;
}

- (UIColor *)colorMapView:(ColorMapView *) colorMapView colorForItemAtIndex:(int)index {
    /*
    UIColor *ret=nil;
    
    int val = [self.timeStamps[index] intValue];
    if(val == 0){
        ret=[UIColor lightGrayColor];
        
    }else if (val < 3)
    {
        ret=[UIColor greenColor];
    }
    else if (val < 5)
    {
        ret=[UIColor orangeColor];
    }
    else
    {
        ret=[UIColor redColor];
    }
    return ret;
     */
    
    return [UIColor greenColor];
}

#pragma mark - ColorMapViewDelegate

- (void)colorMapView:(ColorMapView *)colorMapView selectedItemAtIndex:(int)index {
    
    /*
    int savePos = self.verbs.currentPos;
    self.verbs.currentPos = index;
    NSString * message = [NSString stringWithFormat:@"%@\n%@\n\n%@\n%@\n(%@ sec)",
                          self.verbs.simple, self.verbs.translation, self.verbs.past, self.verbs.participle,self.timeStamps[index]];
    self.verbs.currentPos = savePos;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Revisión"
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
     */
}

@end
