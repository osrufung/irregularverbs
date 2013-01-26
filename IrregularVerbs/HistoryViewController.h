//
//  HistoryViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 17/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSArray *_currentData;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *criteriaControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UITableView *tableHelp;

- (IBAction)sortCriteriaChanged:(id)sender;
- (IBAction)closeHelpView:(UIButton *)sender;

@end
