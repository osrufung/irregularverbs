//
//  ViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorMapView.h"
#import "TestProgressView.h"

enum CardViewControllerPresentationMode {
    CardViewControllerPresentationModeLearn = 0,
    CardViewControllerPresentationModeTest,
    CardViewControllerPresentationModeReview
    };

@interface CardViewController : UIViewController

@property (nonatomic, strong) NSDictionary *verb;
@property (nonatomic) int                   verbIndex;
@property (nonatomic) int                   currentLevel;
@property (nonatomic) BOOL                  includeLowerLevels;
@property (nonatomic) BOOL                  randomOrder;
@property (nonatomic, readonly) float       responseTime;

@property (nonatomic) enum CardViewControllerPresentationMode presentationMode;

@property (nonatomic, weak) IBOutlet UILabel *labelPresent;
@property (nonatomic, weak) IBOutlet UILabel *labelPast;
@property (nonatomic, weak) IBOutlet UILabel *labelParticiple;
@property (nonatomic, weak) IBOutlet UILabel *labelTranslation;
@property (nonatomic, weak) IBOutlet UILabel *labelLevel;
@property (weak, nonatomic) IBOutlet UIImageView *shuffleIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet TestProgressView *testProgress;

- (void)beginTest;
- (void)endTest;

@end
