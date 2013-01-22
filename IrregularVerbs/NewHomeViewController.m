//
//  NewHomeViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 21/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "NewHomeViewController.h"
#import "VerbsStore.h"

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
    
    

    
    }
-(void)viewWillAppear:(BOOL)animated{
    self.view.transform = CGAffineTransformMakeTranslation( 0.0, 400.0);
    
    
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.transform = CGAffineTransformIdentity;
    } completion:nil];
    

    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
     [[self headLabel] setText:[NSString stringWithFormat:@"%d",[[[VerbsStore sharedStore] alphabetic] count]]];
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    [[cell textLabel]setText:[buttonHomeViewArrayLabels objectAtIndex:indexPath.row] ];
    [[cell imageView] setImage:[UIImage imageNamed:[buttonHomeViewArrayIcons objectAtIndex:indexPath.row]]];
    return cell;
}

 

@end
