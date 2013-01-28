//
//  NewHomeViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 21/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelDialSelectorControl.h"

#define DARKGREYTINT  [UIColor colorWithRed:87.0/255.0 green:95.0/255.0 blue:104.0/255.0 alpha:1.0]
#define TURQUESATINT  [UIColor colorWithRed:0.0/255.0 green:218.0/255.0 blue:194.0/255.0 alpha:1.0]
#define ROJOTINT [UIColor colorWithRed:230.0/255 green:68.0/255 blue:97.0/255 alpha:1.0]


@interface HomeViewController : UIViewController<LevelDialSelectorProtocol>
{
 
   
}
- (IBAction)showInfo:(id)sender;
- (IBAction)openLearn:(id)sender;
- (IBAction)openTest:(id)sender;
- (IBAction)openHistory:(id)sender;
- (IBAction)openSetup:(id)sender; 
- (IBAction)closePopUp:(id)sender;
@end
