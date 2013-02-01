//
//  HintsPopupViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 01/02/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "UIColor+IrregularVerbs.h"
#import "HintsPopupViewController.h"
#import "HintsTableDelegate.h"
#import "VerbsStore.h"
#import "ASDepthModalViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HintsPopupViewController ()

@property (strong,nonatomic) HintsTableDelegate *delegate;

@end

@implementation HintsPopupViewController

+ (void)showPopupForHint:(int)hint {
    HintsPopupViewController *hintsPopup = [[HintsPopupViewController alloc] initWithNibName:nil bundle:nil];
    [hintsPopup showPopupForHint:hint];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
    self = [super initWithNibName:nibName bundle:bundle];
    if (self) {
        self.delegate = [[HintsTableDelegate alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [self.tableView registerNib:[UINib nibWithNibName:@"HintsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HintsCell"];
    self.tableView.delegate = self.delegate;
    self.tableView.dataSource = self.delegate;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.closeButton setTitleColor:[UIColor lightGrayColor]    forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor whiteColor]        forState:UIControlStateHighlighted];
    self.closeButton.titleLabel.font = [UIFont fontWithName:@"Signika" size:18];

    self.view.backgroundColor = [UIColor appTintColor];
    self.view.layer.cornerRadius = 8;
}

- (void)showPopupForHint:(int)hint {
    [self.delegate populateWithVerbsInArray:[[VerbsStore sharedStore] verbsForGroupIndex:hint]];
    [ASDepthModalViewController presentViewController:self withBackgroundColor:nil popupAnimationStyle:ASDepthModalAnimationGrow];
}

- (IBAction)dissmissPopup:(UIButton *)sender {
    [ASDepthModalViewController dismiss];
}

@end
