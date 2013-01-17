//
//  HistoryViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 17/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController<UISearchBarDelegate, UISearchDisplayDelegate>{
    NSArray *_currentData;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *criteriaControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sortCriteriaChanged:(id)sender;

@end
