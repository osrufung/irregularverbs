//
//  TestCase.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 25/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestCase : NSObject

@property (nonatomic,copy,readonly) NSArray *verbs;
@property (nonatomic,copy,readonly) NSString *description;
@property (nonatomic,readonly) int totalCount;
@property (nonatomic,readonly) int passCount;
@property (nonatomic,readonly) int failCount;
@property (nonatomic,readonly) float averageTime;
@property (nonatomic,readonly) float failRatio;

- (id)initWithArray:(NSArray *)array description:(NSString *)description;
- (void)sortByTestResults;
- (void)resetTest;
- (void)computeSummaryData;

@end
