//
//  TestSelectorViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 16/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "CardsStackViewController.h"
#import "TestSelectorViewController.h"
#import "CounterCell.h"
#import "VerbsStore.h"

@interface TestSelectorViewController ()

@end

@implementation TestSelectorViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Test";
        [self.tableView registerNib:[UINib nibWithNibName:@"CounterCell" bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:@"CounterCell"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *secTitles = @[@"Number of verbs",@"Test Type"];
    return secTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int lenSec[] = {1,[[[VerbsStore sharedStore] testTypes] count]};
    return lenSec[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *CounterIdentifier = @"CounterCell";
        CounterCell *counterCell = [tableView dequeueReusableCellWithIdentifier:CounterIdentifier forIndexPath:indexPath];
        [counterCell addTarget:self action:@selector(verbsNumberChanged:)];
        counterCell.minimumValue=1;
        counterCell.maximumValue=[[[VerbsStore sharedStore] alphabetic] count];
        counterCell.value=[[NSUserDefaults standardUserDefaults] integerForKey:@"verbsCountInTest"];
        if ((counterCell.value==0)||(counterCell.value>=counterCell.maximumValue)) counterCell.value = MIN(10,counterCell.maximumValue);
        return counterCell;
    } else {
        static NSString *TestTypeIdentifier = @"TestTypeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TestTypeIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TestTypeIdentifier];
            cell.textLabel.text = [[VerbsStore sharedStore] testTypes][indexPath.row];
        }
        return cell;
    }
    return nil;
}

- (void)verbsNumberChanged:(CounterCell *)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:sender.value forKey:@"verbsCountInTest"];
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return !(indexPath.section==0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VerbsStore *store = [VerbsStore sharedStore];
    store.selectedTestType = store.testTypes[indexPath.row];
    
    CardsStackViewController *csvc = [[CardsStackViewController alloc] init];
    csvc.presentationMode = CardViewControllerPresentationModeTest;
    csvc.title =store.selectedTestType;
    [self.navigationController pushViewController:csvc animated:YES];
}

@end
