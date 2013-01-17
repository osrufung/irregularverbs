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
@interface HistoryViewController ()

@end

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
            forCellReuseIdentifier:@"HistoryDataCell"];
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_currentData count];
}
- (void)viewWillAppear:(BOOL)animated {
  
    _currentData = [[VerbsStore sharedStore] alphabetic];
    
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    static NSString *CellIdentifier = @"HistoryDataCell";
    
    HistoryDataCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    Verb *v;
    v = _currentData[indexPath.row];
    
    [[cell labelSimple] setText:[v simple]];
    [[cell labelExtendedForms] setText:[NSString stringWithFormat:@"%@ - %@ - %@",[v past],[v participle],[v translation]]];
    [[cell labelTime] setText: [NSString stringWithFormat:@"%.1fs. avg.",[v averageResponseTime]]];
    [[cell labelFailed] setText:[NSString stringWithFormat:@"%d%% failed",(int)[v failureRatio]*100]];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0;
}

- (IBAction)sortCriteriaChanged:(id)sender {
    
    int criteriaId =[[self criteriaControl] selectedSegmentIndex];
    if(criteriaId == 0){
        _currentData = [[VerbsStore sharedStore] alphabetic];
        
    }else if (criteriaId == 1){
        _currentData = [[VerbsStore sharedStore] results];
    }else if (criteriaId == 2){
        _currentData = [[VerbsStore sharedStore] history];
    }
    
    [self.tableView reloadData];
}
@end
