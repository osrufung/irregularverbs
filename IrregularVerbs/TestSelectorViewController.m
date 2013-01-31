//
//  TestSelectorViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 16/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "VerbsStore.h"
#import "TestCase.h"
#import "TestSelectorViewController.h"
#import "Referee.h"
#import "TestTypeButton.h"
#import "ImgIndependentHelper.h"
#import "RootTestViewController.h"

@interface TestSelectorViewController ()

@property (nonatomic,strong) NSMutableDictionary *testButtons;
@property (weak, nonatomic) IBOutlet UIStepper *countStepper;
@property (weak, nonatomic) IBOutlet UIStepper *timeStepper;
@property (weak, nonatomic) IBOutlet UISwitch *useHintsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *useHintsLabel;

@end

@implementation TestSelectorViewController

- (void)viewDidLoad {
    self.title = NSLocalizedString(@"TestLabel", nil);
    [[self view] insertSubview: [ImgIndependentHelper getBackgroundImageView] atIndex:0];
    [self setUpTestButtons];
    [self setUpOptions];
    [self setUpLabels];
    [self refreshLabels];
}

#pragma mark - Build Test Buttons

- (void)setUpTestButtons {
    NSArray *testTypes = [[VerbsStore sharedStore] testTypes];
    UIFont *fontLabel = [UIFont fontWithName:@"Signika" size:18];
    UIFont *fontBadge = [UIFont fontWithName:@"Signika" size:12];
    
    CGRect rect = CGRectMake(20, 20, 280, 40);
    self.testButtons = [[NSMutableDictionary alloc] initWithCapacity:[testTypes count]];
    for (NSString *type in testTypes) {
        TestTypeButton *button = [[TestTypeButton alloc] initWithFrame:rect];
        [button setTitle:type forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goToTest:) forControlEvents:UIControlEventTouchUpInside];
        button.detailLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:type];
        button.titleLabel.font = fontLabel;
        button.detailLabel.font = fontBadge;
        [self.view addSubview:button];
        [self.testButtons setObject:button forKey:type];
        rect.origin.y += 44;
    }
}

- (void)setUpOptions {
    self.countStepper.minimumValue = 1;
    self.countStepper.maximumValue = [[[VerbsStore sharedStore] alphabetic] count];
    self.countStepper.value = [[VerbsStore sharedStore] verbsNumberInTest];

    self.timeStepper.minimumValue = 1;
    self.timeStepper.maximumValue = 10;
    self.timeStepper.value = [[Referee sharedReferee] maxValue];
    
    self.useHintsSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hintsInTest"];
}

- (void)setUpLabels {
    UIFont *font = [UIFont fontWithName:@"Signika" size:18];
    
    self.countLabel.textColor = [UIColor lightGrayColor];
    self.countLabel.font = font;
    
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = font;
    
    self.useHintsLabel.textColor = [UIColor lightGrayColor];
    self.useHintsLabel.font = font;
}

#pragma mark - Refresh UI

- (void)refreshLabels {
    int totalCount = [[[VerbsStore sharedStore] alphabetic] count];
    int testCount = [[VerbsStore sharedStore] verbsNumberInTest];
    
    self.countLabel.text = [NSString stringWithFormat:NSLocalizedString(@"usexofy", "use x of y"),testCount, totalCount];
    self.timeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"testtime_format",nil),(int)[[Referee sharedReferee] maxValue]];
    self.useHintsLabel.text = NSLocalizedString(@"usehints", nil);
}

#pragma mark - Configuration events

- (IBAction)countChanged:(UIStepper *)sender {
    [[VerbsStore sharedStore] setVerbsNumberInTest:sender.value];
    [self refreshLabels];
}
- (IBAction)timeChanged:(UIStepper *)sender {
    [[Referee sharedReferee] setMaxValue:sender.value];
    [self refreshLabels];
}
- (IBAction)useHintsChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"hintsInTest"];
    [self refreshLabels];
}

#pragma mark - Manage test

- (NSString *)badgeForTestCase:(TestCase *)test {
    NSString *badge = nil;
    if (test) {
        [test computeSummaryData];
        NSLog(@"total %d pass %d fail %d time %.2f failRatio %.2f",test.totalCount,test.passCount,test.failCount,test.averageTime, test.failRatio);
        if (test.failCount==0) {
            badge = [NSString stringWithFormat:@"%.2fs",test.averageTime];
        } else if (test.averageTime==0) {
            badge = [NSString stringWithFormat:@"%d%%",(int)floorf(100*test.failRatio)];
        } else badge = [NSString stringWithFormat:@"%d%%/%.2fs",(int)floorf(100*test.failRatio),test.averageTime];
        if ((test.failCount+test.passCount)!=test.totalCount) {
            badge = [NSString stringWithFormat:@"[%@]",badge];
        }
    }
    return badge;
}

- (void)goToTest:(UIButton *)button {
    [self openSelectedType:button.titleLabel.text];
}

- (void)openSelectedType:(NSString *) typeDescription{
    TestCase *testCase = [[VerbsStore sharedStore] testCaseForTestType:typeDescription];
    RootTestViewController *stack = [[RootTestViewController alloc] initWithTestCase:testCase andPresenterDelegate:self];
    stack.useHints = self.useHintsSwitch.on;
    [self.navigationController pushViewController:stack animated:YES];
}

- (void)presentedViewControllerWillDisapear:(UIViewController *)controller {
    if ([controller isKindOfClass:[RootTestViewController class]]) {
        RootTestViewController *stack = (RootTestViewController *)controller;
        NSString *badge = [self badgeForTestCase:stack.testCase];
        TestTypeButton *button = self.testButtons[stack.testCase.description];
        button.detailLabel.text = badge;
        [[NSUserDefaults standardUserDefaults] setObject:badge forKey:stack.testCase.description];
    }
}

@end
