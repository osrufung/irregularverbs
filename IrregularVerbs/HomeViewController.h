//
//  NewHomeViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 21/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelDialSelectorControl.h"

@interface HomeViewController : UIViewController <LevelDialSelectorProtocol,UIAccessibilityReadingContent>

- (IBAction)showInfo:(id)sender;
- (IBAction)openLearn:(id)sender;
- (IBAction)openTest:(id)sender;
- (IBAction)openHistory:(id)sender;
 
- (IBAction)closePopUp:(id)sender;
- (IBAction)showProjectInfo:(id)sender;

@end
