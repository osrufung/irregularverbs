//
//  TestSelectorViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 16/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "CounterCell.h"
#import "VerbsStore.h"
#import "TestCardsStackViewController.h"
#import "TestSelectorViewController.h"

@interface TestSelectorViewController ()

@end

@implementation TestSelectorViewController

- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

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
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
        counterCell.value=[[VerbsStore sharedStore] verbsNumberInTest];
        return counterCell;
    } else {
        static NSString *TestTypeIdentifier = @"TestTypeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TestTypeIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TestTypeIdentifier];
            cell.textLabel.text = [[VerbsStore sharedStore] testTypes][indexPath.row];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        return cell;
    }
    return nil;
}

- (void)verbsNumberChanged:(CounterCell *)sender {
    [[VerbsStore sharedStore] setVerbsNumberInTest:sender.value];
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return !(indexPath.section==0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self openSelectedType:indexPath.row];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
 
    [self openSelectedType:indexPath.row];
}

-(void)openSelectedType:(NSInteger) type{
    VerbsStore *store = [VerbsStore sharedStore];
    store.selectedTestType = store.testTypes[type];
    
    [self.navigationController pushViewController:[[TestCardsStackViewController alloc] init]
                                         animated:YES];
}

@end
