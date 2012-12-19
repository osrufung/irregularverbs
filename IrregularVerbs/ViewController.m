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

- (void)viewDidLoad
{
    [super viewDidLoad];
	//1 load verbs from dictionary
    //1.0 load resource path
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"verbs" ofType:@"plist"];
    self.verbs = [NSMutableArray arrayWithContentsOfFile:plistPath];
    //init labels
    self.labelPresent.text = @"";
    self.labelPast.text = @"";
    self.labelParticiple.text = @"";
    self.labelTranslation.text = @"";
    
    UISwipeGestureRecognizer *swUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showRandomVerb:)];
    UISwipeGestureRecognizer *swDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showTranslation:)];
    UISwipeGestureRecognizer *swLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showVerbalForms:)];
    UISwipeGestureRecognizer *swRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showVerbalForms:)];
    
    swUp.direction = UISwipeGestureRecognizerDirectionUp;
    swDown.direction = UISwipeGestureRecognizerDirectionDown;
    swLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swUp];
    [self.view addGestureRecognizer:swDown];
    [self.view addGestureRecognizer:swLeft];
    [self.view addGestureRecognizer:swRight];
    
    [self showRandomVerb:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showRandomVerb:(UISwipeGestureRecognizer *)sender {
    int array_tot = [self.verbs count];
    if (array_tot>0) {
        self.current_Pos = (arc4random() % array_tot);
        
        NSString *simple = self.verbs[self.current_Pos][@"simple"] ;

        self.labelPresent.text = simple;
        self.labelTranslation.text = @"";
        self.labelPast.text = @"" ;
        self.labelParticiple.text = @"" ;
        
        //1.1 Animate new verb introduction
        CABasicAnimation *swipeInAnimation = [CABasicAnimation
                                              animationWithKeyPath:@"transform.translation.y"];
        swipeInAnimation.duration = 0.4;
        swipeInAnimation.fromValue = [NSNumber numberWithFloat:self.view.bounds.size.height];
        swipeInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        swipeInAnimation.toValue = [NSNumber numberWithFloat:0];
        swipeInAnimation.removedOnCompletion = YES;
        [self.labelPresent.layer addAnimation:swipeInAnimation forKey:@"moveAnimation"];
    } else {
        NSLog(@"No elements in Verbs");
    }
}

- (void)showTranslation:(UISwipeGestureRecognizer *)sender {
    if (self.labelTranslation.text.length==0) {
        NSString *translation = self.verbs[self.current_Pos][@"translation"];
        self.labelTranslation.text = translation;
        
        //1.1 Animate new verb introduction
        CABasicAnimation *swipeInAnimation = [CABasicAnimation
                                              animationWithKeyPath:@"transform.translation.y"];
        swipeInAnimation.duration = 0.2;
        swipeInAnimation.fromValue = [NSNumber numberWithFloat:-self.labelTranslation.layer.position.y];
        swipeInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        swipeInAnimation.toValue = [NSNumber numberWithFloat:0];
        swipeInAnimation.removedOnCompletion = YES;
        [self.labelTranslation.layer addAnimation:swipeInAnimation forKey:@"moveAnimation"];

    }
}

- (void)showVerbalForms:(id)sender {
    if (self.labelPast.text.length==0) {
        self.labelPast.text = self.verbs[self.current_Pos][@"past"];
        self.labelParticiple.text = self.verbs[self.current_Pos][@"participle"];
        
        CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fader.duration=0.2;
        fader.fromValue= @0.0;
        fader.toValue=@1.0;
        
        [self.labelPast.layer addAnimation:fader forKey:@"fadeAnimation"];
        [self.labelParticiple.layer addAnimation:fader forKey:@"fadeAnimation"];
    }
}

@end
