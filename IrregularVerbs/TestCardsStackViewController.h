//
//  TestCardsStackViewController.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 16/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestScoreCardViewController.h"


@interface TestCardsStackViewController : UIPageViewController<UIPageViewControllerDataSource,TestScoreCardViewDataSource>

- (id)initWithScoreCardDelegate:(id<TestScoreCardViewDelegate>)delegate;

@end
