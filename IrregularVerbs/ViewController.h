//
//  ViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IrregularVerb.h"
#import "PreferencesViewController.h"
#import "VerbsVisualMapView.h"
@interface ViewController : UIViewController <PreferencesViewControllerDelegate, IrregularVerbDelegate>

//Object Data Model
@property (nonatomic, strong) IrregularVerb *verbs;
//current verb (to be deprecated)
@property int current_Pos;
//used for timimg purposes
@property double lastTimingValue;
//label outlets
@property (nonatomic, weak) IBOutlet UILabel *labelPresent;
@property (nonatomic, weak) IBOutlet UILabel *labelPast;
@property (nonatomic, weak) IBOutlet UILabel *labelParticiple;
@property (nonatomic, weak) IBOutlet UILabel *labelTranslation;
@property (nonatomic, weak) IBOutlet UILabel *labelLevel;
@property (weak, nonatomic) IBOutlet UIImageView *shuffleIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet VerbsVisualMapView *visualMap;

@end
