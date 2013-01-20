//
//  CardsTableViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 11/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "CardsTableViewController.h"
#import "HintsTableDelegate.h"
#import "VerbsStore.h"
#import "Verb.h"
#import "Referee.h"

@interface CardsTableViewController ()

@property (nonatomic, strong) NSMutableArray * indexedData;
@property (nonatomic, strong) NSMutableArray * indexEntries;

@property (nonatomic, strong) HintsTableDelegate *hintsDelegate;
@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UISegmentedControl *segmentedMode;


@end

@implementation CardsTableViewController


- (void)makeIndexFor:(NSArray *)array withSearchText:(NSString *)searchText {
    self.indexedData = [[NSMutableArray alloc] init];
    self.indexEntries = [[NSMutableArray alloc] init];
    NSString *currentEntry = @"";
    
    if (searchText) {
        [self.indexEntries addObject:[NSString stringWithFormat:@"Looking for \"%@\"",searchText]];
        [self.indexedData addObject:array];
    } else {
        NSMutableArray *currentSection = nil;
        for (Verb * verb in array) {
            NSString *initial = [verb.simple substringToIndex:1];
            if (![initial isEqualToString:currentEntry]) {
                currentEntry = initial;
                currentSection = [[NSMutableArray alloc] init];
                [self.indexEntries addObject:currentEntry];
                [self.indexedData addObject:currentSection];
            }
            [currentSection addObject:verb];
        }
    }
}

- (NSMutableArray *)indexedData {
    if (!_indexedData) {
        NSArray *array = [[VerbsStore sharedStore] alphabetic];
        [self makeIndexFor:array withSearchText:nil];
    }
    return _indexedData;
}

- (NSMutableArray *)indexEntries {
    if (!_indexEntries) {
        NSArray *array = [[VerbsStore sharedStore] alphabetic];
        [self makeIndexFor:array withSearchText:nil];
    }
    return _indexEntries;
}

- (HintsTableDelegate *)hintsDelegate {
    if (!_hintsDelegate) {
        _hintsDelegate = [[HintsTableDelegate alloc] init];
    }
    return _hintsDelegate;
}

- (void)viewDidLoad {
    self.searchBar.alpha=0;
    [self.tableView registerNib:[UINib nibWithNibName:@"HintsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HintsCell"];
    
    self.searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                      target:self
                                                                      action:@selector(toggleSearchBar)];

    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    self.segmentedMode = [[UISegmentedControl alloc] initWithItems:@[@"Alpha",@"Hints"]];
    self.segmentedMode.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segmentedMode addTarget:self action:@selector(dataSetChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedMode;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.segmentedMode.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"learningMode"];
    [self dataSetChanged:self.segmentedMode];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dataSetChanged:(UISegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex==0) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.navigationItem.rightBarButtonItem = self.searchButton;
    } else {
        self.tableView.delegate = self.hintsDelegate;
        self.tableView.dataSource = self.hintsDelegate;
        self.navigationItem.rightBarButtonItem = nil;
        if (self.searchBar.alpha!=0) [self toggleSearchBar];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:segmentedControl.selectedSegmentIndex forKey:@"learningMode"];
    [self.tableView reloadData];    
}

- (void)toggleSearchBar {
    if (self.searchBar.alpha==0) {
        self.searchBar.frame = CGRectOffset(self.searchBar.frame, 0, -self.searchBar.frame.size.height);
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.searchBar.alpha=1.0f;
                             self.searchBar.frame = CGRectOffset(self.searchBar.frame, 0, self.searchBar.frame.size.height);
                             CGRect currentFrame = self.tableView.frame;
                             self.tableView.frame=CGRectMake(0, currentFrame.origin.y+self.searchBar.frame.size.height, currentFrame.size.width, currentFrame.size.height-self.searchBar.frame.size.height);
                         }];
    } else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.searchBar.alpha=0.0f;
                             self.searchBar.frame = CGRectOffset(self.searchBar.frame, 0, -self.searchBar.frame.size.height);
                             CGRect currentFrame = self.tableView.frame;
                             self.tableView.frame=CGRectMake(0, currentFrame.origin.y-self.searchBar.frame.size.height, currentFrame.size.width, currentFrame.size.height+self.searchBar.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             self.searchBar.frame = CGRectOffset(self.searchBar.frame, 0, self.searchBar.frame.size.height);
                             
                         }];
    }
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexEntries.count;
}

- (BOOL)showIndex {
    return (self.indexEntries.count>10);
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([self showIndex]) {
        return self.indexEntries;
    } else return nil;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.indexedData[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Verb *v;
    
    v = self.indexedData[indexPath.section][indexPath.row];
 
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    [[cell textLabel] setText:[v simple]];
    [[cell detailTextLabel] setText: [NSString stringWithFormat:@"%@ - %@ - %@",[v past],[v participle],[v translation]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

 

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scopeIndex {
    
     NSLog(@"Scope %d", scopeIndex);
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
 
    
    if(searchText){
        NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
        NSArray *sorted = [[VerbsStore sharedStore] alphabetic];
        // Filter the array using NSPredicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.simple contains[c] %@) OR (SELF.past contains[c] %@) OR (SELF.participle contains[c] %@) OR (SELF.translation contains[c] %@)",searchText,searchText,searchText,searchText];
        filteredArray =  [NSMutableArray arrayWithArray:[sorted filteredArrayUsingPredicate:predicate]];
        [self makeIndexFor:filteredArray withSearchText:searchText];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSArray *allVerbs = [[VerbsStore sharedStore] alphabetic];
    [self makeIndexFor:allVerbs withSearchText:nil];
    self.searchBar.alpha=0;
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
 
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope: [self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
//@TODO to implement scope based search (All, Most Common, Unusual)
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    NSLog(@"Not Implemented yet");
    //[self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:searchOption];
    // Return YES to cause the search result table view to be reloaded.
    return NO;
}
 
@end
