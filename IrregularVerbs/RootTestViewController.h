//
//  RootTestViewController.h
//  IrregularVerbs
//
//  Created by Rafa Barberá on 30/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentedViewControllerDelegate.h"
#import "TestCardViewControllerDelegate.h"

@class TestCardsStackViewController;

@class TestCase;
@class TestProgressView;

@interface RootTestViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,TestCardViewControllerDelegate>

@property (strong,nonatomic) TestCase *testCase;
@property (nonatomic) BOOL useHints;

@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UIButton *failButton;
@property (weak, nonatomic) IBOutlet UIImageView *passImage;
@property (weak, nonatomic) IBOutlet UIImageView *failImage;
@property (weak, nonatomic) IBOutlet TestProgressView *progressView;
@property (weak, nonatomic) id<PresentedViewControllerDelegate> presentedDelegate;

- (id)initWithTestCase:(TestCase *)testCase andPresenterDelegate:(id<PresentedViewControllerDelegate>) presentedDelegate;
- (IBAction)testPassed:(UIButton *)sender;
- (IBAction)testFailed:(UIButton *)sender;

@end
