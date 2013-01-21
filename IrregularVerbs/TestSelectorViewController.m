//
//  TestSelectorViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 16/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "VerbsStore.h"
#import "TestCardsStackViewController.h"
#import "TestSelectorViewController.h"

@interface TestSelectorViewController ()

@property (nonatomic,strong) UITableViewCell *counterCell;
@property (nonatomic,strong) UITableViewCell *onOffCell;

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
    
    NSArray *secTitles = @[NSLocalizedString(@"TestOptions", nil),NSLocalizedString(@"TestType", nil)];
    return secTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int lenSec[] = {2,[[[VerbsStore sharedStore] testTypes] count]};
    return lenSec[section];
}

- (UITableViewCell *)counterCell {
    if (!_counterCell) {
        int verbsCount = [[[VerbsStore sharedStore] alphabetic] count];
        _counterCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CounterCell"];
        UIStepper *step = [[UIStepper alloc] init];
        step.minimumValue = 1;
        step.maximumValue = verbsCount;
        step.value = [[VerbsStore sharedStore] verbsNumberInTest];
        [step addTarget:self action:@selector(verbsNumberChanged:) forControlEvents:UIControlEventValueChanged];
        _counterCell.accessoryView = step;
    }
    
    _counterCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"usexofy", "use x of y"),[[VerbsStore sharedStore] verbsNumberInTest], [[[VerbsStore sharedStore] alphabetic] count]] ;;
    return _counterCell;
}

- (UITableViewCell *)onOffCell {
    if (!_onOffCell) {
        _onOffCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OnOffCell"];
        UISwitch *onOff = [[UISwitch alloc] init];
        onOff.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hintsInTest"];
        [onOff addTarget:self action:@selector(useHintsChanged:) forControlEvents:UIControlEventValueChanged];
        _onOffCell.accessoryView = onOff;
        _onOffCell.textLabel.text = NSLocalizedString(@"usehints", nil);
    }
    return _onOffCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return [self counterCell];
        } else {
            return [self onOffCell];
        }
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

- (void)verbsNumberChanged:(UIStepper *)sender {
    [[VerbsStore sharedStore] setVerbsNumberInTest:sender.value];
    [self.tableView reloadData];
}

- (void)useHintsChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"hintsInTest"];
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
