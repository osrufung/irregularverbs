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

@interface TestScoreCardViewController ()

@property (nonatomic,strong) NSArray *testResults;
@property (nonatomic) int passCount;
@property (nonatomic) int failCount;
@property (nonatomic) float averageTime;
@end

@implementation TestScoreCardViewController

static NSString *VerbCell = @"VerbCell";
static NSString *SummaryCell = @"SummaryCell";

- (id)initWithTestData:(NSArray *)testResults {
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
    }
    return self;
}

- (void)computeScoreCard {
    self.passCount=0;
    self.failCount=0;
    self.averageTime=0;
    for (Verb * verb in self.testResults) {
        if (verb.failed) self.failCount++;
        if (verb.responseTime!=0) {
            self.averageTime = (self.averageTime*self.passCount+verb.responseTime)/(self.passCount+1);
            self.passCount++;
        }
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *test = [self.dataSource verbsForTestScoreCardView:self];
    self.testResults = [test sortedArrayUsingSelector:@selector(compareVerbsByTestResults:)];
    [self computeScoreCard];
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
    return self.testResults.count;
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
    if (self.averageTime==0) {
        atStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"nopassverbs",nil)];
        NSDictionary *attr = @{NSForegroundColorAttributeName:[[Referee sharedReferee] colorForFail]};
        [atStr setAttributes:attr range:NSMakeRange(0,[atStr length])];
    } else {
        NSString *average = [NSString stringWithFormat:NSLocalizedString(@"avgtime_format", nil),self.averageTime];
        atStr = [[NSMutableAttributedString alloc] initWithString:average];
        NSDictionary *attr = @{NSForegroundColorAttributeName:[[Referee sharedReferee] colorForValue:self.averageTime]};
        [atStr setAttributes:attr range:NSMakeRange([average length]-5, 5)];
    }
    return atStr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        TSCSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:SummaryCell forIndexPath:indexPath];
                
        [cell.passFailGraph setDataCount:self.testResults.count
                           withPassCount:self.passCount
                            andFailCount:self.failCount];
        
        cell.labelAverageTime.attributedText = [self attributedAverageString];
        
        cell.labelFailureRatio.text = [NSString stringWithFormat:NSLocalizedString(@"fail_format",nil),100.0*self.failCount/self.testResults.count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    if (indexPath.section==1) {
        TSCVerbCell *cell = [tableView dequeueReusableCellWithIdentifier:VerbCell forIndexPath:indexPath];
        
        Verb *verb = self.testResults[indexPath.row];
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
