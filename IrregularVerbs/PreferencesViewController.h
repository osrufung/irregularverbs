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

@property (weak, nonatomic) id <PreferencesViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedSortControl;
- (IBAction)selectionChanged:(id)sender;
- (IBAction)done:(id)sender;
@end
