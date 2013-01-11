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
@interface CardsTableViewController ()

@end

@implementation CardsTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

 
 

#pragma mark UITableViewDataSource Delegate Methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredArray count];
        
    } else {
        return [[[[VerbsStore sharedStore] allVerbs] sortedArrayUsingComparator:compareVerbsAlphabeticaly] count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Verb *v;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        v = [filteredArray objectAtIndex:indexPath.row];
        
    } else {
        v = [[[[VerbsStore sharedStore] allVerbs] sortedArrayUsingComparator:compareVerbsAlphabeticaly] objectAtIndex:[indexPath row]];
    }
    
 
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
        [filteredArray removeAllObjects];
        NSArray *sorted = [[[VerbsStore sharedStore] allVerbs] sortedArrayUsingComparator:compareVerbsAlphabeticaly];
        // Filter the array using NSPredicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.simple contains[c] %@) OR (SELF.past contains[c] %@) OR (SELF.participle contains[c] %@) OR (SELF.translation contains[c] %@)",searchText,searchText,searchText,searchText];
        filteredArray =  [NSMutableArray arrayWithArray:[sorted filteredArrayUsingPredicate:predicate]];
    }
 
    
 
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
