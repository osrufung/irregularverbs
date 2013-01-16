//
//  CardsTableViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 11/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "CardsTableViewController.h"
#import "VerbsStore.h"
#import "Verb.h"
#import "Referee.h"

@interface CardsTableViewController ()
{
}

@end

@implementation CardsTableViewController


- (void)makeIndexFor:(NSArray *)array withSearchText:(NSString *)searchText {
    _indexedData = [[NSMutableArray alloc] init];
    _indexEntries = [[NSMutableArray alloc] init];
    NSString *currentEntry = @"";
    
    if (searchText) {
        [_indexEntries addObject:[NSString stringWithFormat:@"Looking for \"%@\"",searchText]];
        [_indexedData addObject:array];
    } else {
        NSMutableArray *currentSection = nil;
        for (Verb * verb in array) {
            NSString *initial = [verb.simple substringToIndex:1];
            if (![initial isEqualToString:currentEntry]) {
                currentEntry = initial;
                currentSection = [[NSMutableArray alloc] init];
                [_indexEntries addObject:currentEntry];
                [_indexedData addObject:currentSection];
            }
            [currentSection addObject:verb];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *allVerbs = [[VerbsStore sharedStore] alphabetic];
    [self makeIndexFor:allVerbs withSearchText:nil];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_indexEntries count];
}

- (BOOL)showIndex {
    return _indexEntries.count>10;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([self showIndex]) {
        return _indexEntries;
    } else return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self showIndex]) {
        return _indexEntries[section];
    } else return @"";
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_indexedData[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Verb *v;
    
    v = _indexedData[indexPath.section][indexPath.row];
 
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    [[cell textLabel] setText:[v simple]];
    [[cell detailTextLabel] setText: [NSString stringWithFormat:@"%@ - %@ - %@",[v past],[v participle],[v translation]]];
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
