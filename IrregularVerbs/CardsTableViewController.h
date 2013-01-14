//
//  CardsTableViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 11/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardsTableViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *_indexedData;
    NSMutableArray *_indexEntries;
}
@end
