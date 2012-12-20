//
//  IrregularVerb.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import "IrregularVerb.h"

@interface IrregularVerb()
@property (nonatomic, strong) NSMutableArray *verbs;
@property (nonatomic) NSInteger currentPos;
@end

@implementation IrregularVerb

@synthesize verbs=_verbs, randomOrder=_randomOrder, currentPos=_currentPos;

// It's needed to get the last inner state (random/sorted and last position)
- (id)init {
    self = [super init];
    if (self) {
        self.randomOrder = [[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"];
        if (!self.randomOrder) {
            self.currentPos=[[NSUserDefaults standardUserDefaults] integerForKey:@"currentPos"];
        } else self.currentPos = (arc4random() % [self.verbs count]);
    }
    return self;
}

- (NSMutableArray *) verbs{
    if (!_verbs) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"verbs" ofType:@"plist"];
        _verbs = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    return _verbs;
}

- (void)setRandomOrder:(BOOL)randomOrder {
    if (randomOrder!=_randomOrder) {
        _randomOrder = randomOrder;
        [[NSUserDefaults standardUserDefaults] setBool:_randomOrder forKey:@"randomOrder"];
    }
}

- (void)setCurrentPos:(NSInteger)currentPos {
    if (currentPos!=_currentPos) {
        _currentPos=currentPos;
        [[NSUserDefaults standardUserDefaults] setInteger:_currentPos forKey:@"currentPos"];
    }
}

- (void)change {
    if (self.randomOrder) {
        self.currentPos = (arc4random() % [self.verbs count]);
    } else {
        self.currentPos++;
        if (self.currentPos>=[self.verbs count]) self.currentPos=0;
    }
}

- (NSString *)simple {
    return self.verbs[self.currentPos][@"simple"];
}

- (NSString *)translation {
    return self.verbs[self.currentPos][@"translation"];
}
- (NSString *)past {
    return self.verbs[self.currentPos][@"past"];
}
- (NSString *)participle {
    return self.verbs[self.currentPos][@"participle"];
}

@end
