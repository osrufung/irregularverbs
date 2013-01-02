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
   
    int setup_level =  [[NSUserDefaults standardUserDefaults] integerForKey:@"difficultyLevel"];
    [self.verbs setLevel:setup_level];
    
    [self setLabelLevelText:setup_level];
    
    [self showOtherVerb];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (void)initialize{

    //load default settings values
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]]];
}

#pragma mark - User Interface

-(void)setLabelLevelText:(int)level{
    
    if(level < 4){
        BOOL includeLowerLevels = [[NSUserDefaults standardUserDefaults] boolForKey:@"includeLowerLevels"];
        NSString *format = (includeLowerLevels)?@"To level %d":@"Level %d";
        self.labelLevel.text = [NSString stringWithFormat:format, level];
    }
    else{
        self.labelLevel.text = @"All levels";
    }
}
- (void)showOtherVerb {
    
    [self.verbs change];
    
    self.labelPresent.text = self.verbs.simple;
    self.labelTranslation.text = @"";
    self.labelPast.text = @"" ;
    self.labelParticiple.text = @"" ;
    
    [self moveYView:self.labelPresent from:self.view.bounds.size.height to:0 duration:0.4];
    
    
    //check sametime setting and show other forms
    BOOL showSameTimePref = [[NSUserDefaults standardUserDefaults] boolForKey:@"sameTime"];
    
    if(showSameTimePref){
        [self showTranslation:nil];
        [self showVerbalForms:nil];
    }
    
    
}

- (void)showTranslation:(UISwipeGestureRecognizer *)sender {
    if (self.labelTranslation.text.length==0) {
        self.labelTranslation.text = self.verbs.translation;
        
        if (sender) {
            [self moveYView:self.labelTranslation from:-self.labelTranslation.layer.position.y to:0 duration:0.2];
        } else {
            [self moveYView:self.labelTranslation from:self.view.bounds.size.height to:0 duration:0.4];
        }
    }
}

- (void)showVerbalForms:(id)sender {
    if (self.labelPast.text.length==0) {
        self.labelPast.text = self.verbs.past;
        self.labelParticiple.text = self.verbs.participle;
        if (sender) {
            [self fadeView:self.labelPast from:0.0 to:1.0 ];
            [self fadeView:self.labelParticiple from:0.0 to:1.0];
        } else {
            [self moveYView:self.labelPast from:self.view.bounds.size.height to:0 duration:0.4];
            [self moveYView:self.labelParticiple from:self.view.bounds.size.height to:0 duration:0.4];
        }
    }
}

- (void)changeSorting {
    self.verbs.randomOrder = !self.verbs.randomOrder;
     [self animateShuffleIndicator];
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

- (void)flipsideViewControllerDidFinish:(PreferencesViewController *)controller
{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //we need no reload the sort preferences.
    [self.verbs setRandomOrder:[[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"]];
    //change level?
    int setup_level = [[NSUserDefaults standardUserDefaults] integerForKey:@"difficultyLevel"];
    self.verbs.level = setup_level;
    [self setLabelLevelText:setup_level];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator startAnimating];
    });
}

- (void)updateEnd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self showOtherVerb];
    });
}

- (void)updateFailedWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"Dimiss"
                                              otherButtonTitles:nil];
        [alert show];
    });
}
@end
