//
//  TSCSummaryCell.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 17/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PassFailGraphView;

@interface TSCSummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PassFailGraphView *passFailGraph;
@property (weak, nonatomic) IBOutlet UILabel *labelFailureRatio;
@property (weak, nonatomic) IBOutlet UILabel *labelAverageTime;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
