//
//  TestCardViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 15/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "VerbsStore.h"
#import "Verb.h"
#import "TestCardViewController.h"
#import "TestProgressView.h"
#import "Referee.h"
#import "HintsPopupViewController.h"
#import  <QuartzCore/QuartzCore.h>

#define TEST_TIMER_INTERVAL 1/60.0f

@interface TestCardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelSimple;
@property (weak, nonatomic) IBOutlet UILabel *labelTranslation;
@property (weak, nonatomic) IBOutlet UILabel *labelPast;
@property (weak, nonatomic) IBOutlet UILabel *labelParticiple;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelHint;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (weak, nonatomic) IBOutlet UIButton *hintsButton;

@property (nonatomic) BOOL useHintsInTest;

@end

@implementation TestCardViewController


#pragma mark - View lifecicle

- (void)viewDidLoad {

    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView.image = [imgHomebuttonwochevron resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)
                                                              resizingMode:UIImageResizingModeStretch];
    self.backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundView.layer.shadowOffset = CGSizeMake(0, 2);
    self.backgroundView.layer.shadowRadius = 2;
    self.backgroundView.layer.shadowOpacity = 0.6;
    
    CGPathRef path = CGPathCreateWithRect(self.backgroundView.bounds, nil);
    self.backgroundView.layer.shadowPath = path;
    CFRelease(path);
}

- (void)viewWillAppear:(BOOL)animated {
    self.useHintsInTest = [[NSUserDefaults standardUserDefaults] boolForKey:@"hintsInTest"];
    if ([self.delegate respondsToSelector:@selector(testCardWillApperar:)]) [self.delegate testCardWillApperar:self];
    [self showCard];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(testCardDidApperar:)]) [self.delegate testCardDidApperar:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(testCardWillDisappear:)]) [self.delegate testCardWillDisappear:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(testCardDidDisappear:)]) [self.delegate testCardDidDisappear:self];
}

#pragma mark - UI

- (void)showCard {
    self.labelSimple.text = self.verb.simple;
    self.labelHint.text = @"";
    if (self.verb.testPending) {
        self.labelTranslation.text = @"";
        self.labelPast.text = @"";
        self.labelParticiple.text = @"";
        self.labelTime.text = @"";
        self.historyLabel.text = @"";
        [self.hintsButton setTitle:@"" forState:UIControlStateNormal];
        self.labelSimple.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0.5*self.backgroundView.bounds.size.height-self.labelSimple.bounds.size.height);
    } else {
        self.labelTranslation.text = self.verb.translation;
        self.labelPast.text = self.verb.past;
        self.labelParticiple.text = self.verb.participle;
        self.historyLabel.text = [NSString stringWithFormat:@"%d/%d",self.verb.passCount,self.verb.testCount];
        [self.hintsButton setTitle:[NSString stringWithFormat:@"%d",self.verb.hint] forState:UIControlStateNormal];
        if (self.verb.failed) {
            self.labelTime.text = @"";
        } else {
            self.labelTime.text = [NSString stringWithFormat:@"%.2fs",self.verb.responseTime];
        }
    }
}

- (void)revealResults {
    self.labelTranslation.alpha = 0;
    self.labelPast.alpha = 0;
    self.labelParticiple.alpha = 0;
    self.labelTime.alpha = 0;
    self.historyLabel.alpha=0;
    self.hintsButton.alpha=0;
    [self showCard];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelSimple.layer.affineTransform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            self.labelTranslation.alpha = 1;
            self.labelPast.alpha = 1;
            self.labelParticiple.alpha = 1;
            self.labelTime.alpha = 1;
            self.historyLabel.alpha = 1;
            self.hintsButton.alpha=1;
            self.labelHint.alpha = 0;
        }];
    }];    
}

- (void)revealHint {
    if (!self.verb.testPending) return;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelSimple.layer.affineTransform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        self.labelHint.text = [[VerbsStore sharedStore] hintForGroupIndex:self.verb.hint];
        [UIView animateWithDuration:0.2 animations:^{
            self.labelHint.alpha = 1;
        }];
    }];
}

- (void)hideTime {
    [UIView animateWithDuration:0.3 animations:^{
        self.labelTime.alpha = 0;
    }];
}
- (IBAction)showHintsPopup:(UIButton *)sender {
    [HintsPopupViewController showPopupForHint:[sender.titleLabel.text integerValue]];
}

@end
