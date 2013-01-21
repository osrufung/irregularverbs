//
//  HomeViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio Fung on 15/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

- (IBAction)openLearn:(id)sender;
- (IBAction)openTest:(id)sender;
- (IBAction)openHistory:(id)sender;
- (IBAction)openSetup:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberVerbs;
@property (weak, nonatomic) IBOutlet UILabel *labelLearnButton;
@property (weak, nonatomic) IBOutlet UILabel *labelTestButton;
 
@property (weak, nonatomic) IBOutlet UILabel *labelHistoryButton;
@property (weak, nonatomic) IBOutlet UILabel *labelSetupButton;
 
@end
