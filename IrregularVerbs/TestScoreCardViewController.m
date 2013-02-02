//
//  ScoreCardViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 17/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "TestScoreCardViewController.h"
#import "TSCVerbCell.h"
#import "TSCSummaryCell.h"
#import "Verb.h"
#import "Referee.h"
#import "PassFailGraphView.h"
#import "TestCase.h"

@interface TestScoreCardViewController ()

@property (nonatomic, strong) TestCase *testCase;

@end

@implementation TestScoreCardViewController

static NSString *VerbCell = @"VerbCell";
static NSString *SummaryCell = @"SummaryCell";

- (id)initWithTestCase:(TestCase *)testCase {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // We need a copy if not, we will modify the order of the curren test
        self.testCase = [[TestCase alloc] initWithTestCase:testCase];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    // We need to sort dataset each time that we show it
    [self.testCase sortByTestResults];
    [self.testCase computeSummaryData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TSCVerbCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:VerbCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSCSummaryCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:SummaryCell];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) return 1;
    return self.testCase.totalCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section==0) {
        static CGFloat headerHeight = 0;
        if (headerHeight==0) {
            cell = [tableView dequeueReusableCellWithIdentifier:SummaryCell];
            headerHeight = cell.bounds.size.height;
        }
        return headerHeight;
    }
    if (indexPath.section==1) {
        static CGFloat rowHeight = 0;
        if (rowHeight==0) {
            cell = [tableView dequeueReusableCellWithIdentifier:VerbCell];
            rowHeight = cell.bounds.size.height;
        }
        return rowHeight;
        
    }
    return 0;
}

- (NSAttributedString *)attributedAverageString
{
    NSMutableAttributedString *atStr;
    if (self.testCase.averageTime==0) {
        atStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"nopassverbs",nil)];
        NSDictionary *attr = @{NSForegroundColorAttributeName:[[Referee sharedReferee] colorForFail]};
        [atStr setAttributes:attr range:NSMakeRange(0,[atStr length])];
    } else {
        NSString *average = [NSString stringWithFormat:NSLocalizedString(@"avgtime_format", nil),self.testCase.averageTime];
        atStr = [[NSMutableAttributedString alloc] initWithString:average];
        NSDictionary *attr = @{NSForegroundColorAttributeName:[[Referee sharedReferee] colorForValue:self.testCase.averageTime]};
        [atStr setAttributes:attr range:NSMakeRange([average length]-5, 5)];
    }
    return atStr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        TSCSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:SummaryCell forIndexPath:indexPath];
                
        [cell.passFailGraph setDataCount:self.testCase.totalCount
                           withPassCount:self.testCase.passCount
                            andFailCount:self.testCase.failCount];
        
        cell.labelAverageTime.attributedText = [self attributedAverageString];
        
        cell.labelFailureRatio.text = [NSString stringWithFormat:NSLocalizedString(@"fail_format",nil),100.0*self.testCase.failRatio];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    if (indexPath.section==1) {
        TSCVerbCell *cell = [tableView dequeueReusableCellWithIdentifier:VerbCell forIndexPath:indexPath];
        
        Verb *verb = self.testCase.verbs[indexPath.row];
        cell.labelVerb.text = verb.simple;
        if (verb.failed) {
            cell.labelVerb.textColor = [[Referee sharedReferee] colorForFail];
            cell.labelElapsedTime.text = @"";
        } else {
            UIColor *verbColor;
            if (verb.responseTime==0) {
                verbColor = [UIColor lightGrayColor];
                cell.labelVerb.textColor = verbColor;
                cell.labelElapsedTime.text = @"";
                
            } else {
                verbColor = [[Referee sharedReferee] colorForValue:verb.responseTime];
                cell.labelVerb.textColor = verbColor;
                cell.labelElapsedTime.text = [NSString stringWithFormat:@"%.2fs",verb.responseTime];
                cell.labelElapsedTime.textColor = verbColor;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return nil;
}

@end
