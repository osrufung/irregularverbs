//
//  HistoryDataCell.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 17/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PassFailGraphView;

@interface HistoryDataCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelSimple;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelExtendedForms;
@property (weak, nonatomic) IBOutlet UILabel *labelFailed;
@property (weak, nonatomic) IBOutlet PassFailGraphView *passFailGraph;

@end
