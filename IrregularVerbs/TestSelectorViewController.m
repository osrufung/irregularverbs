//
//  TestSelectorViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 16/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "VerbsStore.h"
#import "TestCase.h"
#import "TestCardsStackViewController.h"
#import "TestSelectorViewController.h"
#import "Referee.h"
#import <QuartzCore/QuartzCore.h>

@interface TestSelectorViewController ()

@property (nonatomic,strong) UIImage *buttonImage;
@property (nonatomic,strong) NSMutableDictionary *testResults;

@end

@implementation TestSelectorViewController

- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"selecttesttype", nil);
        self.buttonImage = [[UIImage imageNamed:@"greyButtonSpacer"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        self.testResults = [[NSMutableDictionary alloc] init];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeViewbg"]];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static int heights[] = {44,40};
    return heights[indexPath.section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int lenSec[] = {[[[VerbsStore sharedStore] testTypes] count],3};
    return lenSec[section];
}

- (UITableViewCell *)counterCellWithTarget:(id)target action:(SEL)action {
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CounterCell"];
    UIStepper *step = [[UIStepper alloc] init];
    [step addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = step;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Signika" size:18];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.backgroundColor = [UIColor whiteColor];
    //        cell.backgroundView = [[UIImageView alloc] initWithImage:self.buttonImage];
    return cell;
}

- (UITableViewCell *)onOffCellWithTarget:(id)target action:(SEL)action {
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OnOffCell"];
    UISwitch *onOff = [[UISwitch alloc] init];
    [onOff addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = onOff;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Signika" size:18];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.backgroundColor = [UIColor whiteColor];
    //        _onOffCell.backgroundView = [[UIImageView alloc] initWithImage:self.buttonImage];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        UITableViewCell *cell;
        UIStepper *step;
        
        switch (indexPath.row) {
            case 0:
            {
                int verbsCount = [[[VerbsStore sharedStore] alphabetic] count];
                cell = [self counterCellWithTarget:self action:@selector(verbsNumberChanged:)];
                step = (UIStepper *)cell.accessoryView;
                step.minimumValue = 1;
                step.maximumValue = verbsCount;
                step.value = [[VerbsStore sharedStore] verbsNumberInTest];
                cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"usexofy", "use x of y"),(int)step.value, verbsCount];
            }
                break;
                
            case 1:
            {
                cell = [self counterCellWithTarget:self action:@selector(maxTimeChanged:)];
                UIStepper *step = (UIStepper *)cell.accessoryView;
                step.minimumValue = 1;
                step.maximumValue = 10;
                step.value = [[Referee sharedReferee] maxValue];
                cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"testtime_format",nil),(int)[[Referee sharedReferee] maxValue]];
            }
                break;
            case 2:
            {
                cell = [self onOffCellWithTarget:self action:@selector(useHintsChanged:)];
                cell.textLabel.text = NSLocalizedString(@"usehints", nil);
                UISwitch *onOff = (UISwitch *)cell.accessoryView;
                onOff.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hintsInTest"];
                break;
            }
            default:
                break;
        }
        return cell;
    } else {
        static NSString *TestTypeIdentifier = @"TestTypeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TestTypeIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TestTypeIdentifier];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.backgroundView = [[UIImageView alloc] initWithImage:self.buttonImage ];
            cell.imageView.image = [UIImage imageNamed:@"crayon"];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.font = [UIFont fontWithName:@"Signika" size:18];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.backgroundView.frame = CGRectInset(cell.frame, -20, -20);
        }
        UILabel *answer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 82, 20)];
        cell.textLabel.text = [[VerbsStore sharedStore] testTypes][indexPath.row];
        NSString *badge = [self.testResults objectForKey:cell.textLabel.text];
        if (badge) {
            answer.text = badge;
            answer.textColor = [UIColor whiteColor];
            answer.font = [UIFont fontWithName:@"Signika" size:12];
            answer.textAlignment = NSTextAlignmentCenter;
            answer.backgroundColor = [UIColor darkGrayColor];
            answer.layer.cornerRadius = 3;
            [answer sizeToFit];
            answer.frame = CGRectInset(answer.frame, -3, -2);
            cell.accessoryView = answer;
        }

        return cell;
    }
    return nil;
}

- (void)verbsNumberChanged:(UIStepper *)sender {
    [[VerbsStore sharedStore] setVerbsNumberInTest:sender.value];
    [self.tableView reloadData];
}

- (void)maxTimeChanged:(UIStepper *)sender {
    [[Referee sharedReferee] setMaxValue:sender.value];
    [self.tableView reloadData];
}

- (void)useHintsChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"hintsInTest"];
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return !(indexPath.section==1);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self openSelectedType:indexPath.row];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
 
    [self openSelectedType:indexPath.row];
}

- (NSString *)badgeForTestType:(TestCase *)test {
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

- (void)openSelectedType:(NSInteger) type{
    NSString *typeDescription = [[VerbsStore sharedStore] testTypes][type];
    TestCase *testCase = [[VerbsStore sharedStore] testCaseForTestType:typeDescription];
    TestCardsStackViewController *stack = [[TestCardsStackViewController alloc] initWithTestCase:testCase];
    stack.presentedDelegate = self;
    [self.navigationController pushViewController:stack animated:YES];
}

- (void)presentedViewControllerWillDisapear:(UIViewController *)controller {
    if ([controller isKindOfClass:[TestCardsStackViewController class]]) {
        TestCardsStackViewController *stack = (TestCardsStackViewController *)controller;
        NSString *badge = [self badgeForTestType:stack.testCase];
        [self.testResults setObject:badge forKey:stack.testCase.description];
    }
}

@end
