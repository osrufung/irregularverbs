//
//  TestCardsStackViewController.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 16/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentedViewControllerDelegate.h"

@class TestCase;
@class TestCardsStackViewController;


@interface TestCardsStackViewController : UIPageViewController<UIPageViewControllerDataSource>

@property (nonatomic, strong) TestCase *testCase;
@property (nonatomic, weak) id<PresentedViewControllerDelegate> presentedDelegate;

- (id)initWithTestCase:(TestCase *)testCase;

@end
