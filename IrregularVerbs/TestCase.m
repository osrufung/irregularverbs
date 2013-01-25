//
//  TestCase.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 25/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "TestCase.h"
#import "Verb.h"

@implementation TestCase

- (id)initWithArray:(NSArray *)array description:(NSString *)description {
    self = [super init];
    if (self) {
        _verbs = [array copy];
        _description = [description copy];
        [self resetTest];
    }
    return self;
}

- (void)computeSummaryData {
    _passCount = _failCount = 0;
    _averageTime = 0.0;
    _totalCount = self.verbs.count;
    for (Verb *verb in self.verbs) {
        if (verb.failed) _failCount++;
        if (verb.responseTime!=0) {
            _averageTime = (_averageTime * _passCount + verb.responseTime)/(_passCount+1);
            _passCount++;
        }
    }
}

- (void)resetTest {
    for (Verb *verb in self.verbs) {
        [verb resetCurrentTest];
    }
    _passCount = _failCount = 0;
    _averageTime = 0.0;
    _totalCount = self.verbs.count;
}

- (void)sortByTestResults {
    _verbs = [_verbs sortedArrayUsingSelector:@selector(compareVerbsByTestResults:)];
}

- (float)failRatio {
    if (_totalCount==0) return 0.0f;
    return (float)_failCount/_totalCount;
}

@end
