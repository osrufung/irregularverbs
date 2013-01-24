//
//  NewHomeViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 21/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>


#define DARKGREYTINT  [UIColor colorWithRed:87.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:1.0]
#define TURQUESATINT  [UIColor colorWithRed:5.0/255.0 green:192.0/255.0 blue:133.0/255.0 alpha:1.0]
#define ROJOTINT [UIColor colorWithRed:230.0/255 green:68.0/255 blue:97.0/255 alpha:1.0]


@interface NewHomeViewController : UIViewController
{
    NSArray *buttonHomeViewArrayLabels;
    NSArray *buttonHomeViewArrayIcons;
   
}
- (IBAction)showInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *labelPopUp;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
 
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIButton *buttonLearn;
@property (weak, nonatomic) IBOutlet UIButton *buttonTest;
@property (weak, nonatomic) IBOutlet UIButton *buttonHistory;
@property (weak, nonatomic) IBOutlet UIButton *buttonSetup;
- (IBAction)openLearn:(id)sender;
- (IBAction)openTest:(id)sender;
- (IBAction)openHistory:(id)sender;
- (IBAction)openSetup:(id)sender;
 
- (IBAction)closePopUp:(id)sender;
@end
