//
//  TestCardViewController.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 15/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestCardViewControllerDelegate.h"

@class Verb;

@interface TestCardViewController : UIViewController

@property (nonatomic,weak) Verb *verb;
@property (nonatomic,weak) id<TestCardViewControllerDelegate> delegate;

- (void)revealResults;
- (void)revealHint;
- (void)hideTime;


@end
