//
//  VerbsStore.h
//  IrregularVerbs
//
//  Created by Rafa Barberá on 03/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TestCase;

@interface VerbsStore : NSObject

@property (nonatomic) float frequency;

@property (nonatomic, readonly) NSArray *alphabetic;
@property (nonatomic, readonly) NSArray *results;
@property (nonatomic, readonly) NSArray *history;
@property (nonatomic, readonly) NSArray *testTypes;
@property (nonatomic) int verbsNumberInTest;

+ (VerbsStore *)sharedStore;

- (NSString *)hintForGroupIndex:(int)index;
- (NSArray *)verbsForGroupIndex:(int)index;

- (TestCase *)testCaseForTestType:(NSString *)testType;

- (BOOL) saveChanges;
- (BOOL) resetVerbsStore;

- (void) resetHistory;

- (NSArray *) defaultFrequencyGroups;
- (int)currentFrequencyByGroup;
- (int)failedOrNotTestedVerbsCount;

@end
