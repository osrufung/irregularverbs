//
//  IrregularVerb.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import "IrregularVerb.h"
#import "NSArray+Shuffling.h"

@interface IrregularVerb()
@property (nonatomic, strong) NSArray *verbs;

@end

@implementation IrregularVerb

@synthesize verbs=_verbs, randomOrder=_randomOrder;

// It's needed to get the last inner state (random/sorted and last position)
- (id)initWithData:(NSArray *)verbList {
    self = [self init];
    if (self) {
        self.verbs = verbList;
        self.randomOrder = [[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"];
        [self sortVerbsList];
    }
    return self;
}

- (void)setVerbs:(NSArray *)verbs {
    if (![_verbs isEqualToArray:verbs]) {
        _verbs = verbs;
    }
}

- (void)sortVerbsList {
    if (self.randomOrder) {
        self.verbs = [self.verbs shuffledCopy];
    } else {
        self.verbs = [self.verbs sortedArrayUsingComparator:^(id ob1, id ob2){
            NSString *s1 = [ob1 objectForKey:@"simple"];
            NSString *s2 = [ob2 objectForKey:@"simple"];
            return [s1 compare:s2];
        }];
    }
}

- (void)setRandomOrder:(BOOL)randomOrder {
    if (randomOrder!=_randomOrder) {
        _randomOrder = randomOrder;
        [[NSUserDefaults standardUserDefaults] setBool:_randomOrder forKey:@"randomOrder"];
        [self sortVerbsList];
    }
}

- (NSDictionary *)verbAtIndex:(int)index {
    return [self.verbs[index] copy];
}

-(int) count{
    return [self.verbs count];
}
@end
