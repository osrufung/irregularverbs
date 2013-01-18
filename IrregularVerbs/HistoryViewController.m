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
#import "TSCSummaryCell.h"
#import "PassFailGraphView.h"
#import "Referee.h"

@interface HistoryViewController ()

@property (nonatomic) int failCount;
@property (nonatomic) int passCount;
@property (nonatomic) float averageTime;

@end

static NSString *CellIdentifier = @"HistoryDataCell";
static NSString *SummaryIdentifier = @"TSCSummaryCell";


@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
  

    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[self  tableView] registerNib:[UINib nibWithNibName:@"HistoryDataCell" bundle:nil]
            forCellReuseIdentifier:CellIdentifier];

    [[self  tableView] registerNib:[UINib nibWithNibName:@"TSCSummaryCell" bundle:nil]
            forCellReuseIdentifier:SummaryIdentifier];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)viewWillAppear:(BOOL)animated {
  
    [self chooseDataSet:0];
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
    if (section==0) return 1;
    return _currentData.count;
}

//Without row height cached performance sucks
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section==0) {
        static CGFloat headerHeight = 0;
        if (headerHeight==0) {
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
        atStr = [[NSMutableAttributedString alloc] initWithString:@"No pass verb!"];
        NSDictionary *attr = @{NSForegroundColorAttributeName:[[Referee sharedReferee] colorForFail]};
        [atStr setAttributes:attr range:NSMakeRange(0,[atStr length])];
    } else {
        NSString *average = [NSString stringWithFormat:@"Average time %.2fs",self.averageTime];
        atStr = [[NSMutableAttributedString alloc] initWithString:average];
        NSDictionary *attr = @{NSForegroundColorAttributeName:[[Referee sharedReferee] colorForValue:self.averageTime]};
        [atStr setAttributes:attr range:NSMakeRange([average length]-5, 5)];
    }
    return atStr;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.section==0) {
        TSCSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:SummaryIdentifier forIndexPath:indexPath];
        
        [cell.passFailGraph setColorsSaturation:0.5f];
        [cell.passFailGraph setDataCount:self.passCount+self.failCount
                           withPassCount:self.passCount
                            andFailCount:self.failCount];
        
        cell.labelTitle.text = @"History";
        cell.labelAverageTime.attributedText = [self attributedAverageString];
        cell.labelFailureRatio.text = [NSString stringWithFormat:@"%.0f%% fail",100.0*self.failCount/(self.passCount+self.failCount)];
        cell.labelFailureRatio.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    if (indexPath.section==1) {
        HistoryDataCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Verb *v;
        v = _currentData[indexPath.row];
        
        [[cell labelSimple] setText:[v simple]];
        [[cell labelExtendedForms] setText:[NSString stringWithFormat:@"%@ - %@ - %@",[v past],[v participle],[v translation]]];
        if (v.averageResponseTime==0) {
            cell.labelTime.text=@"";
        } else {
            cell.labelTime.text = [NSString stringWithFormat:@"%.2fs",v.averageResponseTime];
            cell.labelTime.textColor = [[Referee sharedReferee] colorForValue:v.averageResponseTime];
        }
        
        int failCount, passCount;
        if (v.testCount!=0) {
            failCount = v.failureRatio*100;
            passCount = 100-failCount;
            cell.labelFailed.text = [NSString stringWithFormat:@"%d%% fail",failCount];
            cell.labelFailed.textColor = [UIColor darkGrayColor];
        } else {
            failCount = passCount = 0;
            cell.labelFailed.text = @"";
        }
        
        [cell.passFailGraph setColorsSaturation:0.3f];
        [cell.passFailGraph setDataCount:100
                           withPassCount:passCount
                            andFailCount:failCount];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    return nil;
    
}

- (void)computeStatistics {
    self.passCount=0;
    self.failCount=0;
    self.averageTime=0;
    int newCount;
    for (Verb * verb in _currentData) {        
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
            _currentData = [[VerbsStore sharedStore] alphabetic];
            break;
        case 1:
            _currentData = [[[VerbsStore sharedStore] alphabetic] sortedArrayUsingSelector:@selector(compareVerbsByAverageResponseTime:)];
            break;
        case 2:
            _currentData = [[VerbsStore sharedStore] history];
            break;
        default:
            _currentData = nil;
            break;
    }
}

- (IBAction)sortCriteriaChanged:(id)sender {
    
    int criteriaId =[[self criteriaControl] selectedSegmentIndex];
    [self chooseDataSet:criteriaId];
    [self.tableView reloadData];
}
@end
