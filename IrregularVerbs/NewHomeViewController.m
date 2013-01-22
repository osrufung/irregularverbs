//
//  NewHomeViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 21/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "NewHomeViewController.h"
#import "VerbsStore.h"
#import <QuartzCore/QuartzCore.h>
#import "CardsTableViewController.h"
#import "TestSelectorViewController.h"
#import "PreferencesViewController.h"
#import "HistoryViewController.h"
#import "VSRotatingView.h"
#import "ASDepthModalViewController.h"

@interface NewHomeViewController ()

@end

@implementation NewHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
 
        
        buttonHomeViewArrayLabels = [NSArray arrayWithObjects:NSLocalizedString(@"LearnLabel", @"Learn label button"),NSLocalizedString(@"TestLabel", @"Test label button"),NSLocalizedString(@"HistoryLabel", @"History label button"),NSLocalizedString(@"SetupLabel", @"Setup label button"), nil];
        buttonHomeViewArrayIcons = [NSArray arrayWithObjects:@"page_empty.png",@"crayon.png",@"graph_bar_trend.png",@"cog_02.png", nil];
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    VSRotatingView *rv = [VSRotatingView new];
     
    [[self bottomView] addSubview:rv];
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeViewbg.png"]];
    
    }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Unselect the selected row if any
    NSIndexPath*    selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
 
    [self.navigationController setNavigationBarHidden:YES animated:YES];
     [[self headLabel] setText:[NSString stringWithFormat:@"%d",[[[VerbsStore sharedStore] alphabetic] count]]];
}

#pragma mark UITableViewDataSource Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [buttonHomeViewArrayLabels count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        
    }
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [[cell textLabel]setText:[buttonHomeViewArrayLabels objectAtIndex:indexPath.row] ];
    [[cell imageView] setImage:[UIImage imageNamed:[buttonHomeViewArrayIcons objectAtIndex:indexPath.row]]];
    
    cell.layer.shadowOffset = CGSizeMake(0, 10);
    cell.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    cell.layer.shadowRadius = 20;
    cell.layer.shadowOpacity = 0.8;
    CGRect shadowFrame = cell.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
    cell.layer.shadowPath = shadowPath;
    
    
    return cell;
}
 


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        
    switch([indexPath row]){
        case 0:
            [[self navigationController] pushViewController:[[CardsTableViewController alloc] init]
                                                   animated:YES];
            break;
        case 1:
            [[self navigationController] pushViewController:[[TestSelectorViewController alloc] init]
                                                   animated:YES];
            break;
        case 2:
               [[self navigationController] pushViewController:[[HistoryViewController alloc] init]  animated:YES];
            break;
        case 3:
            [[self navigationController] pushViewController:[[PreferencesViewController alloc] init]
                                                   animated:YES];
            break;
    }
}
- (IBAction)showInfo:(id)sender {
        [ASDepthModalViewController presentView:self.popupView withBackgroundColor:nil popupAnimationStyle:ASDepthModalAnimationDisplace];
}
- (IBAction)closePopUp:(id)sender {
      [ASDepthModalViewController dismiss];
}
@end
