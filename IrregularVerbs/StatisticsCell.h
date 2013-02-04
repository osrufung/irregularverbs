//
//  StatisticsCell.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 04/02/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PassFailGraphView;

@interface StatisticsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pendingLabel;
@property (weak, nonatomic) IBOutlet UILabel *testCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *failCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *failRatioLabel;
@property (weak, nonatomic) IBOutlet PassFailGraphView *passFailGraph;
@property (weak, nonatomic) IBOutlet UILabel *averageTimeLabel;

@end
