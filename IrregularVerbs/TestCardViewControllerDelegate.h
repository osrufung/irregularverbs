//
//  TestCardViewDelegate.h
//  IrregularVerbs
//
//  Created by Rafa Barberá on 30/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TestCardViewController;

@protocol TestCardViewControllerDelegate <NSObject>

@optional
- (void)testCardWillApperar:(TestCardViewController *)cardView;
- (void)testCardDidApperar:(TestCardViewController *)cardView;
- (void)testCardWillDisappear:(TestCardViewController *)cardView;
- (void)testCardDidDisappear:(TestCardViewController *)cardView;

@end
