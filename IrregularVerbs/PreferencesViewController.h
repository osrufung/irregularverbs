//
//  PreferencesViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PreferencesViewController;

@protocol PreferencesViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(PreferencesViewController *)controller;
@end

@interface PreferencesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedDifficultyLevel;
@property (weak, nonatomic) IBOutlet UISwitch *switchShowSameTime;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchLowerLevels;
@property (weak, nonatomic) id <PreferencesViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedSortControl;
- (IBAction)selectionChanged:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)diffycultyLevelChanged:(UISegmentedControl *)sender;
-(IBAction)sameTimeChanged:(id)sender;
- (IBAction)lowerLevelsChanged;
-(IBAction)showAboutLink:(id)sender;
@end
