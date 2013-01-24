//
//  VerbsStore.h
//  IrregularVerbs
//
//  Created by Rafa Barberá on 03/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerbsStore : NSObject

@property (nonatomic) float frequency;

@property (nonatomic, readonly) NSArray *alphabetic;
@property (nonatomic, readonly) NSArray *testSubSet;
@property (nonatomic, readonly) NSArray *results;
@property (nonatomic, readonly) NSArray *history;
@property (nonatomic, readonly) NSArray *testTypes;
@property (nonatomic, strong) NSString *selectedTestType;
@property (nonatomic) int verbsNumberInTest;

+ (VerbsStore *)sharedStore;

- (int)lastTestFailedVerbsCount;
- (NSString *)hintForGroupIndex:(int)index;
- (NSArray *)verbsForGroupIndex:(int)index;

- (BOOL) saveChanges;
- (BOOL) resetVerbsStore;

- (void) resetHistory;
- (void) resetTest;
-(NSArray *) defaultFrequencyGroups;
-(int)currentFrequencyByGroup;

@end
