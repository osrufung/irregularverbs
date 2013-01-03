//
//  NSArray+Shuffling.m
//  IrregularVerbs
//
//  Created by Rafa Barberá on 03/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "NSArray+Shuffling.h"

@implementation NSArray (Shuffling)

- (NSArray *)shuffledCopy {
    NSMutableArray *mutable = [self mutableCopy];
    int count = mutable.count;
    for (uint i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = arc4random_uniform(nElements) + i;
        [mutable exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return [mutable copy];
}

@end
