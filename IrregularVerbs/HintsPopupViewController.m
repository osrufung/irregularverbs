//
//  HintsPopupViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 01/02/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "ColorsDefinition.h"
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
    self.view.backgroundColor = TURQUESATINT;
    self.view.layer.cornerRadius = 8;
    [self.titleLabel setText:NSLocalizedString(@"whatyouneedtoknow", nil)];
    [self.closeButton setTitle:NSLocalizedString(@"close",nil) forState:UIControlStateNormal];
}

- (void)showPopupForHint:(int)hint {
    [self.delegate populateWithVerbsInArray:[[VerbsStore sharedStore] verbsForGroupIndex:hint]];
    [ASDepthModalViewController presentViewController:self withBackgroundColor:nil popupAnimationStyle:ASDepthModalAnimationGrow];
}

- (IBAction)dissmissPopup:(UIButton *)sender {
    [ASDepthModalViewController dismiss];
}

@end
