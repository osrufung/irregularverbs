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
{
    
}

@property (nonatomic,strong) UITableViewCell *counterCell;
@property (nonatomic,strong) UITableViewCell *onOffCell;
@property (nonatomic,strong) UIImage *buttonImage;
@property (nonatomic,strong) UIImage *buttonImageHighlight;

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
        self.buttonImage = [[UIImage imageNamed:@"greyButtonSpacer"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        self.buttonImageHighlight = [[UIImage imageNamed:@"greyButtonHighlightSpacer"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {

    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *secTitles = @[@"",NSLocalizedString(@"TestOptions", nil)];
    return secTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int lenSec[] = {[[[VerbsStore sharedStore] testTypes] count],2};
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
        _counterCell.textLabel.backgroundColor = [UIColor clearColor];
        _counterCell.textLabel.font = [UIFont fontWithName:@"Helvetica-Neue-Light" size:18];
        _counterCell.textLabel.textColor = [UIColor darkGrayColor];
        _counterCell.backgroundView = [[UIImageView alloc] initWithImage:self.buttonImage highlightedImage:self.buttonImageHighlight];

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
        _onOffCell.textLabel.backgroundColor = [UIColor clearColor];
        _onOffCell.textLabel.font = [UIFont fontWithName:@"Helvetica-Neue-Light" size:18];
        _onOffCell.textLabel.textColor = [UIColor darkGrayColor];
        _onOffCell.backgroundView = [[UIImageView alloc] initWithImage:self.buttonImage highlightedImage:self.buttonImageHighlight];
    }
    return _onOffCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            return [self counterCell];
        } else {
            return [self onOffCell];
        }
    } else {
        static NSString *TestTypeIdentifier = @"TestTypeCell";
        UITableViewCell *cell;

        cell = [tableView dequeueReusableCellWithIdentifier:TestTypeIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TestTypeIdentifier];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.backgroundView = [[UIImageView alloc] initWithImage:self.buttonImage highlightedImage:self.buttonImageHighlight];
            cell.accessoryView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crayon"]];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Neue-Light" size:18];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.backgroundView.frame = CGRectInset(cell.frame, -20, -20);
        }
        cell.textLabel.text = [[VerbsStore sharedStore] testTypes][indexPath.row];

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
    return !(indexPath.section==1);
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
