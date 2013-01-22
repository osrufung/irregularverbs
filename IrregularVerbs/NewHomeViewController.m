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

@interface NewHomeViewController ()

@end

@implementation NewHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        buttonHomeViewArrayLabels = [NSArray arrayWithObjects:@"Learn",@"Test",@"History",@"Setup", nil];
        buttonHomeViewArrayIcons = [NSArray arrayWithObjects:@"page_empty.png",@"crayon.png",@"graph_bar_trend.png",@"cog_02.png", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 [self.tableView footerViewForSection:0].backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeViewbg.png"]];
    
    }
-(void)viewWillAppear:(BOOL)animated{
    self.view.transform = CGAffineTransformMakeTranslation( 0.0, 400.0);
    
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform = CGAffineTransformIdentity;
    } completion:nil];
    

    
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
@end
