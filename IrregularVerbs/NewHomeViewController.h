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

@interface NewHomeViewController : UIViewController
{
    NSArray *buttonHomeViewArrayLabels;
    NSArray *buttonHomeViewArrayIcons;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@end
