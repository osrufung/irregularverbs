//
//  ScoreCardViewController.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 17/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestCase;

@interface TestScoreCardViewController : UITableViewController
- (id)initWithTestCase:(TestCase *)testCase;
@end
