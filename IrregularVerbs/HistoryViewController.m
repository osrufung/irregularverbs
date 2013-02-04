//
//  HistoryViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 17/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryDataCell.h"
#import "VerbsStore.h"
#import "Verb.h"
#import "StatisticsCell.h"
#import "PassFailGraphView.h"
#import "Referee.h"
#import "UIColor+Saturation.h"
#import "HintsPopupViewController.h"


@interface HistoryViewController ()

@property (nonatomic) int failCount;
@property (nonatomic) int passCount;
@property (nonatomic) int testCount;
@property (nonatomic) float averageTime;
@property (nonatomic) int noTested;

@end


static NSString *CellIdentifier = @"HistoryDataCell";
static NSString *SummaryIdentifier = @"StatisticsCell";


@implementation HistoryViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
        
    [[self  tableView] registerNib:[UINib nibWithNibName:@"HistoryDataCell" bundle:nil]
            forCellReuseIdentifier:CellIdentifier];

    [[self  tableView] registerNib:[UINib nibWithNibName:@"StatisticsCell" bundle:nil]
            forCellReuseIdentifier:SummaryIdentifier];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = NSLocalizedString(@"HistoryLabel", nil);
    
    [[self criteriaControl] setTitle:NSLocalizedString(@"hfailures", nil) forSegmentAtIndex:0];
    [[self criteriaControl] setTitle:NSLocalizedString(@"haveragetime_abrev", nil) forSegmentAtIndex:1];
    [[self criteriaControl] setTitle:NSLocalizedString(@"halpha", nil) forSegmentAtIndex:2];
    [[self criteriaControl] setTitle:NSLocalizedString(@"herrors", nil) forSegmentAtIndex:3];
    [[self criteriaControl] setTitle:NSLocalizedString(@"htest", nil) forSegmentAtIndex:4];

    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                 target:self
                                                                                 action:@selector(clearStatistics)];
 
    self.navigationItem.rightBarButtonItem = resetButton;
}

- (void)clearStatistics{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"clearhistorydata", nil)
                                                 message:NSLocalizedString(@"clearconsequence", nil)
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                       otherButtonTitles:NSLocalizedString(@"clearall", nil), nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
         
        [[VerbsStore sharedStore] resetHistory];
         
        [self.navigationController popToRootViewControllerAnimated:YES];
         [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firsTimeAssistantShown"];
        
    }
}
- (void)viewWillAppear:(BOOL)animated {
    int historyView = [[NSUserDefaults standardUserDefaults] integerForKey:@"historyView"];
    self.criteriaControl.selectedSegmentIndex = historyView;
    [self chooseDataSet:historyView];
    
    [self computeStatistics];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return _currentData.count;
}

//Without row height cached performance sucks
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        static CGFloat headerHeight = 0;
        if (headerHeight == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:SummaryIdentifier];
            headerHeight = cell.bounds.size.height;
        }
        return headerHeight;
    }
    if (indexPath.section==1) {
        static CGFloat rowHeight = 0;
        if (rowHeight==0) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            rowHeight = cell.bounds.size.height;
        }
        return rowHeight;
    }
    return 0;
}

- (NSAttributedString *)attributedAverageString
{
    NSMutableAttributedString *atStr;
    if (self.averageTime==0) {
        atStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"nopassverbs", nil)];
        NSDictionary *attr = @{NSForegroundColorAttributeName:[[Referee sharedReferee] colorForFail]};
        [atStr setAttributes:attr range:NSMakeRange(0,[atStr length])];
    } else {
        NSString *average = [NSString stringWithFormat:NSLocalizedString(@"avgtime_format",nil),self.averageTime];
        atStr = [[NSMutableAttributedString alloc] initWithString:average];
        NSDictionary *attr = @{NSForegroundColorAttributeName:[[Referee sharedReferee] colorForValue:self.averageTime]};
        [atStr setAttributes:attr range:NSMakeRange([average length]-5, 5)];
    }
    return atStr;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        StatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:SummaryIdentifier forIndexPath:indexPath];
                
        [cell.passFailGraph setColorsSaturation:0.5f];
        [cell.passFailGraph setDataCount:self.passCount+self.failCount
                           withPassCount:self.passCount
                            andFailCount:self.failCount];
        
        cell.titleLabel.text = NSLocalizedString(@"HistoryLabel", nil);
        cell.averageTimeLabel.attributedText = [self attributedAverageString];
        if ((self.passCount+self.failCount) > 0) {
            cell.failRatioLabel.text = [NSString stringWithFormat:@"%.0f%%",100.0*self.failCount/(self.passCount+self.failCount)];
        }
        else
            cell.failRatioLabel.text =@"";

        cell.failRatioLabel.textColor = [UIColor blackColor];
        cell.pendingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d verbs without test", @"{count} verbs without test"),self.noTested];
        cell.testCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d fallos en %d tests", @"{#fail} failed verbs in {#test} tests"),self.failCount, self.testCount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    if (indexPath.section == 1) {
        HistoryDataCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Verb *v;
        v = _currentData[indexPath.row];
        
        cell.labelSimple.text = [NSString stringWithFormat:@"%@ - %@ - %@",v.simple, v.past, v.participle];
        cell.labelExtendedForms.text = v.translation;
        if (v.averageResponseTime==0) {
            cell.labelTime.text=@"";
        } else {
            cell.labelTime.text = [NSString stringWithFormat:@"%.2fs",v.averageResponseTime];
            cell.labelTime.textColor = [[Referee sharedReferee] colorForValue:v.averageResponseTime];
        }
        
        cell.failCountLabel.text = [NSString stringWithFormat:@"%d/%d",v.failCount,v.testCount];        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        Verb *selectedVerb = _currentData[indexPath.row];        
        [HintsPopupViewController showPopupForHint:selectedVerb.hint];
    }
}

- (void)computeStatistics {
    self.passCount=0;
    self.failCount=0;
    self.averageTime=0;
    self.noTested=0;
    self.testCount=0;
    int newCount;
    for (Verb * verb in _currentData) {
        if (verb.testCount==0) self.noTested++;
        self.testCount += verb.testCount;
        self.failCount += verb.failCount;
        newCount = self.passCount+verb.passCount;
        if (newCount>0) {
            self.averageTime = (self.averageTime*self.passCount+verb.averageResponseTime*verb.passCount)/newCount;
        }
        self.passCount += verb.passCount;
    }
}


- (void)chooseDataSet:(int)criteriaId {
    switch (criteriaId) {
        case 0:
            _currentData = [[VerbsStore sharedStore] history];
            break;
        case 1:
            _currentData = [[[VerbsStore sharedStore] alphabetic] sortedArrayUsingSelector:@selector(compareVerbsByAverageResponseTime:)];
            break;
        case 2:
            _currentData = [[VerbsStore sharedStore] alphabetic];
            break;
        case 3:
            _currentData = [[[VerbsStore sharedStore] alphabetic] sortedArrayUsingSelector:@selector(compareVerbsByHistoricalPerformance:)];
            break;
        case 4:
            _currentData = [[[VerbsStore sharedStore] alphabetic] sortedArrayUsingSelector:@selector(compareVerbsByTestNumber:)];
            break;
        default:
            _currentData = nil;
            break;
    }
    NSLog(@"%@",_currentData);
    [[NSUserDefaults standardUserDefaults] setInteger:criteriaId forKey:@"historyView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)sortCriteriaChanged:(id)sender {
    
    int criteriaId =[[self criteriaControl] selectedSegmentIndex];
    [self chooseDataSet:criteriaId];
    [self.tableView reloadData];
}
@end
