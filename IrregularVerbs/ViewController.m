//
//  ViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize verbs=_verbs;

#pragma mark - Model Managment

- (IrregularVerb *)verbs {
    if (!_verbs) {
        _verbs = [[IrregularVerb alloc] init];
        _verbs.delegate = self;
    }
    return _verbs;
}
 
- (void)animateShuffleIndicator {
  
    if (self.verbs.randomOrder) {
        self.shuffleIndicator.layer.opacity=0.2;
        [self fadeView:self.shuffleIndicator from:0.0 to:0.2];
    } else {
        self.shuffleIndicator.layer.opacity=0.0;
        [self fadeView:self.shuffleIndicator from:0.2 to:0.0];
    } 
}
 
#pragma mark - Setup

- (void)setupGestureRecognizers {
    UISwipeGestureRecognizer *swUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showOtherVerb)];
    UISwipeGestureRecognizer *swDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showTranslation:)];
    UISwipeGestureRecognizer *swLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showVerbalForms:)];
    UISwipeGestureRecognizer *swRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showVerbalForms:)];
    UITapGestureRecognizer *tapOrder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSorting)];
    swUp.direction = UISwipeGestureRecognizerDirectionUp;
    swDown.direction = UISwipeGestureRecognizerDirectionDown;
    swLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swRight.direction = UISwipeGestureRecognizerDirectionRight;
    tapOrder.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:swUp];
    [self.view addGestureRecognizer:swDown];
    [self.view addGestureRecognizer:swLeft];
    [self.view addGestureRecognizer:swRight];
    [self.view addGestureRecognizer:tapOrder];
}

- (void)awakeFromNib {
    [self setupGestureRecognizers];
     [self animateShuffleIndicator];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showOtherVerb];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Interface

- (void)showOtherVerb {
    
    [self.verbs change];
    
    self.labelPresent.text = self.verbs.simple;
    self.labelTranslation.text = @"";
    self.labelPast.text = @"" ;
    self.labelParticiple.text = @"" ;
    
    [self moveYView:self.labelPresent from:self.view.bounds.size.height to:0 duration:0.4];
    
}

- (void)showTranslation:(UISwipeGestureRecognizer *)sender {
    if (self.labelTranslation.text.length==0) {
        self.labelTranslation.text = self.verbs.translation;
        
        [self moveYView:self.labelTranslation from:-self.labelTranslation.layer.position.y to:0 duration:0.2];
    }
}

- (void)showVerbalForms:(id)sender {
    if (self.labelPast.text.length==0) {
        self.labelPast.text = self.verbs.past;
        self.labelParticiple.text = self.verbs.participle;
        
        [self fadeView:self.labelPast from:0.0 to:1.0];
        [self fadeView:self.labelParticiple from:0.0 to:1.0];
    }
}

- (void)changeSorting {
    self.verbs.randomOrder = !self.verbs.randomOrder;
     [self animateShuffleIndicator];
}


#pragma mark - Helpers CAAnimation

- (void)fadeView:(UIView *)view from:(CGFloat)initialAlpha to:(CGFloat)finalAlpha {
    CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fader.duration=0.2;
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

- (void)flipsideViewControllerDidFinish:(PreferencesViewController *)controller
{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //we need no reload the sort preferences.
    [self.verbs setRandomOrder:[[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"]];
    //download the verbs list for the new level selected.
    self.verbs.level = [[NSUserDefaults standardUserDefaults] boolForKey:@"difficultyLevel"];
    //and repaint the shuffle indicator
    [self showOtherVerb];
    [self animateShuffleIndicator];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

#pragma mark - IrregularVerbDelegate

- (void)updateBegin {
    [self.activityIndicator startAnimating];
}

- (void)updateEnd {
    [self.activityIndicator stopAnimating];
}

- (void)updateFailedWithError:(NSError *)error {
    [self.activityIndicator stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain
                                                    message:error.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"Dimiss"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
