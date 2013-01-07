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
@property (nonatomic, strong) VerbsStore *store;
@property (nonatomic) int currentLevel;
@property (nonatomic) BOOL includeLowerLevels;
@property (nonatomic, strong) NSMutableArray *timeStamps;
@property (nonatomic) BOOL inStudyMode;

@end

@implementation ViewController

@synthesize verbs=_verbs, lastTimingValue=_lastTimingValue;
@synthesize store = _store, currentLevel = _currentLevel, includeLowerLevels = _includeLowerLevels;
@synthesize timeStamps = _timeStamps;

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

- (void)resetTimeStamps {
    _timeStamps = [NSMutableArray arrayWithCapacity:self.verbs.count];
    [_timeStamps removeAllObjects];
    for (int i=0;i< self.verbs.count;i++){
        [_timeStamps addObject:[NSNumber numberWithInt:0]];
    }
}

- (NSMutableArray *)timeStamps {
    if (!_timeStamps) {
        [self resetTimeStamps];
    }
    return _timeStamps;
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

- (BOOL)inStudyMode {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"sameTime"];
}

- (void)setInStudyMode:(BOOL)inStudyMode {
    [[NSUserDefaults standardUserDefaults] setBool:inStudyMode forKey:@"sameTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (inStudyMode) {
        self.visualMap.hidden=YES;
    } else {
        self.visualMap.hidden=NO;
    }
}

#pragma mark - Setup

- (void)setupGestureRecognizers {
    UISwipeGestureRecognizer *swUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeVerb:)];
    UISwipeGestureRecognizer *swDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeVerb:)];
    UISwipeGestureRecognizer *swLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showVerbalForms:)];
    UISwipeGestureRecognizer *swRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showVerbalForms:)];
    UITapGestureRecognizer *tapOrder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMode:)];
    UILongPressGestureRecognizer *tapHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showResults:)];
    swUp.direction = UISwipeGestureRecognizerDirectionUp;
    swUp.delegate = self;
    swDown.direction = UISwipeGestureRecognizerDirectionDown;
    swDown.delegate = self;
    swLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swLeft.delegate = self;
    swRight.direction = UISwipeGestureRecognizerDirectionRight;
    swRight.delegate = self;
    tapOrder.numberOfTapsRequired = 2;
    tapHold.delegate = self;
    tapOrder.delegate = self;
    
    [self.view addGestureRecognizer:swUp];
    [self.view addGestureRecognizer:swDown];
    [self.view addGestureRecognizer:swLeft];
    [self.view addGestureRecognizer:swRight];
    [self.view addGestureRecognizer:tapOrder];
    [self.view addGestureRecognizer:tapHold];
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
    [self showVerbAnimatedForm:UISwipeGestureRecognizerDirectionUp];
    
    //init the VisualMap view
    self.visualMap.dataSource = self;
    self.visualMap.delegate = self;
    
    if (self.inStudyMode) {
        self.visualMap.hidden=YES;
    } else {
        self.visualMap.hidden=NO;
    }

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
    double CurrentTime = CACurrentMediaTime();
    NSLog(@"Current time Diff %f seconds", CurrentTime  - [self lastTimingValue]  );
    double diff_time = CurrentTime - [self lastTimingValue]  ;
        
    [self setLastTimingValue:CurrentTime];
    //mark new verb
    [self.timeStamps replaceObjectAtIndex:self.verbs.currentPos withObject:[NSNumber numberWithInt:(int)diff_time+1]];
    [self.visualMap setNeedsDisplay];
}

- (void)changeVerb:(UIGestureRecognizer *)gr {
    UISwipeGestureRecognizer *swipeGR = (UISwipeGestureRecognizer *)gr;

    //We should timestamp the curren verb, before changing it
    [self timeStampCurrentVerb];
    if (swipeGR.direction==UISwipeGestureRecognizerDirectionUp) {
        self.verbs.currentPos++;
    } else if (swipeGR.direction==UISwipeGestureRecognizerDirectionDown) {
        self.verbs.currentPos--;
    }
    [self showVerbAnimatedForm:swipeGR.direction];
}

- (void)showVerbAnimatedForm:(UISwipeGestureRecognizerDirection)dir {
    self.labelPresent.text = self.verbs.simple;
    self.labelTranslation.text = @"";
    self.labelPast.text = @"" ;
    self.labelParticiple.text = @"" ;
    
    CGFloat delta=self.view.bounds.size.height;
    if (dir== UISwipeGestureRecognizerDirectionDown) delta=-self.labelParticiple.layer.position.y;
    [self moveYView:self.labelPresent from:delta to:0 duration:0.4];
    
    if(self.inStudyMode) {
        self.labelTranslation.text = self.verbs.translation;
        self.labelPast.text = self.verbs.past;
        self.labelParticiple.text = self.verbs.participle;
        [self moveYView:self.labelPast from:delta to:0 duration:0.4];
        [self moveYView:self.labelParticiple from:delta to:0 duration:0.4];
        [self moveYView:self.labelTranslation from:delta to:0 duration:0.4];
    }
    
}

- (void)showVerbalForms:(UIGestureRecognizer *)gr {
    if (self.labelPast.text.length==0) {
        self.labelTranslation.text = self.verbs.translation;
        self.labelPast.text = self.verbs.past;
        self.labelParticiple.text = self.verbs.participle;
        if (gr) {
            [self fadeView:self.labelPast from:0.0 to:1.0 ];
            [self fadeView:self.labelParticiple from:0.0 to:1.0];
            [self fadeView:self.labelTranslation from:0.0 to:1.0];
            // When the user use the swipe gesture to reveal any data, the time is over
            [self timeStampCurrentVerb];
        }
    }
}

- (void)changeSorting {
    self.verbs.randomOrder = !self.verbs.randomOrder;
     [self animateShuffleIndicator];
}

- (void)toggleMode:(UIGestureRecognizer *)gr {
    self.inStudyMode = !self.inStudyMode;
    if (!self.inStudyMode) {
        [self resetTimeStamps];
        [self.visualMap setNeedsDisplay];
        self.verbs.currentPos=0;
    }
    [self showVerbAnimatedForm:UISwipeGestureRecognizerDirectionUp];
}

- (void)showResults:(UIGestureRecognizer *)gr {
    if (!self.inStudyMode &&(gr.state==UIGestureRecognizerStateBegan)) {
        [self.visualMap toggleSize:nil];
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
    [self showVerbAnimatedForm:UISwipeGestureRecognizerDirectionUp];
    //init the VisualMap view
    [self resetTimeStamps];
    [self.visualMap setNeedsDisplay];
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
        [self showVerbAnimatedForm:UISwipeGestureRecognizerDirectionUp];
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

#pragma mark - ColorMapViewDataSource

- (int)numberOfItemsInColorMapView:(ColorMapView *)colorMapView {
    return self.verbs.count;
}

- (UIColor *)colorMapView:(ColorMapView *) colorMapView colorForItemAtIndex:(int)index {
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
}

#pragma mark - ColorMapViewDelegate

- (void)colorMapView:(ColorMapView *)colorMapView selectedItemAtIndex:(int)index {
    
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
}

#pragma mark accesibility 
- (BOOL)accessibilityScroll:(UIAccessibilityScrollDirection)direction
{
 
    NSString *description = @"";
    BOOL scrolled = NO;
    switch (direction) {
		case UIAccessibilityScrollDirectionRight:
		{
            [self showVerbalForms:nil];
            scrolled = YES;
            description = @"Scrolled Right";
			break;
		}
		case UIAccessibilityScrollDirectionLeft:
		{
            [self showVerbalForms:nil];
            scrolled = YES;
            description = @"Scrolled Left";
			break;
		}
		case UIAccessibilityScrollDirectionUp:
		{
			[self showOtherVerb];
			scrolled = YES;
			 description = @"Scrolled Up";
			break;
		}
		case UIAccessibilityScrollDirectionDown:
		{
			[self showTranslation:nil];
			scrolled = YES;
			 description = @"Scrolled Down";
			break;
		}
		default:
			break;
	}
    if (scrolled)
		UIAccessibilityPostNotification(UIAccessibilityPageScrolledNotification, description);
    return TRUE;
}

- (NSInteger)accessibilityLineNumberForPoint:(CGPoint)point{
    return NSNotFound;
}
@end
