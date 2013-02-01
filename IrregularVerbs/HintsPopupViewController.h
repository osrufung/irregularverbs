//
//  HintsPopupViewController.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 01/02/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HintsPopupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (void)showPopupForHint:(int)hint;

@end
