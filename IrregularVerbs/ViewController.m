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
//Each verb should be timestamped once
@property BOOL currentVerbIsTimeStamped;
@property (nonatomic, strong) VerbsStore *store;
@property int currentLevel;
@property BOOL includeLowerLevels;

@end

@implementation ViewController

@synthesize verbs=_verbs, lastTimingValue=_lastTimingValue, currentVerbIsTimeStamped = _currentVerbIsTimeStamped;
@synthesize store = _store, currentLevel = _currentLevel, includeLowerLevels = _includeLowerLevels;

#pragma mark - Model Managment

- (VerbsStore *)store {
    if (!_store) {
        _store = [[VerbsStore alloc] init];
        _store.delegate = self;
    }
    return _store;
}

- (IrregularVerb *)verbs {
    if (!_verbs) {
        self.currentLevel =  [[NSUserDefaults standardUserDefaults] integerForKey:@"difficultyLevel"];
        self.includeLowerLevels = [[NSUserDefaults standardUserDefaults] boolForKey:@"includeLowerLevels"];
        BOOL remote = [[NSUserDefaults standardUserDefaults] boolForKey:@"loadFromInternet"];
        if (self.currentLevel<4) {
            _verbs = [self.store verbsForLevel:self.currentLevel includeLowerLevels:self.includeLowerLevels fromInternet:remote];
        } else {
            _verbs = [self.store allVerbsFromInternet:remote];
        }
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
   
    int setupLevel =  [[NSUserDefaults standardUserDefaults] integerForKey:@"difficultyLevel"];
    [self setLabelLevelText:setupLevel];
    
    [self setLastTimingValue: CACurrentMediaTime()];

    //The first time we show a verb it shouldn't fire the timestamp
    self.currentVerbIsTimeStamped = YES;
    [self showOtherVerb];
    
    //init the VisualMap view
    [self.visualMap setNumElements:[self.verbs count] ];
    
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

-(void)setLabelLevelText:(int)level {
    
    if(level < 4){
        BOOL includeLowerLevels = [[NSUserDefaults standardUserDefaults] boolForKey:@"includeLowerLevels"];
        NSString *format = (includeLowerLevels)?@"To level %d (%d verbs)":@"Level %d (%d verbs)";
        self.labelLevel.text = [NSString stringWithFormat:format, level, self.verbs.count];
    }
    else{
        self.labelLevel.text = [NSString stringWithFormat:@"All levels (%d verbs)", self.verbs.count];
    }
}

- (void)timeStampCurrentVerb {
    if (!self.currentVerbIsTimeStamped) {
        double CurrentTime = CACurrentMediaTime();
        NSLog(@"Current time Diff %f seconds", CurrentTime  - [self lastTimingValue]  );
        double diff_time = CurrentTime - [self lastTimingValue]  ;
        
        [self setLastTimingValue:CurrentTime];
        //mark new verb
        [self.visualMap markElement: [self.verbs currentPos] seconds:diff_time];
        self.currentVerbIsTimeStamped = YES;
    }
}

- (void)showOtherVerb {
    
    //We should timestamp the curren verb, before changing it
    [self timeStampCurrentVerb];
    [self.verbs change];
    self.currentVerbIsTimeStamped = NO;
    

    
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
            // When the user use the swipe gesture to reveal any data, the time is over
            [self timeStampCurrentVerb];
            
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
            // When the user use the swipe gesture to reveal any data, the time is over
            [self timeStampCurrentVerb];
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

    int setupLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"difficultyLevel"];
    BOOL lowerLevels = [[NSUserDefaults standardUserDefaults] boolForKey:@"includeLowerLevels"];
    BOOL remote = [[NSUserDefaults standardUserDefaults] boolForKey:@"loadFromInternet"];
    
    if ((self.currentLevel!=setupLevel)||(self.includeLowerLevels!=lowerLevels)) {
        if (setupLevel<4) {
            _verbs = [self.store verbsForLevel:setupLevel includeLowerLevels:lowerLevels fromInternet:remote];
        } else {
            _verbs = [self.store allVerbsFromInternet:remote];
        }
        self.currentLevel = setupLevel;
        self.includeLowerLevels = lowerLevels;
    }
    
    [self setLabelLevelText:setupLevel];
    //and repaint the shuffle indicator
    [self showOtherVerb];
    //init the VisualMap view
    [self.visualMap setNumElements:[self.verbs count] ];
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
