//
//  ScoreCardViewController.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 17/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestScoreCardViewController;

@protocol TestScoreCardViewDataSource <NSObject>

- (NSArray *)verbsForTestScoreCardView:(TestScoreCardViewController *)testScoreCardView;

@end

@interface TestScoreCardViewController : UITableViewController

@property (nonatomic, weak) id<TestScoreCardViewDataSource> dataSource;

@end
