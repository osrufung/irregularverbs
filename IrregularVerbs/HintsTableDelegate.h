//
//  HintsTableDelegate.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HintsTableDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

- (void)populateWithVerbsInArray:(NSArray *)verbs;

@end
