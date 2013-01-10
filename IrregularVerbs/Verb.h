//
//  Verb.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 08/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Verb : NSObject<NSCoding>

@property (nonatomic,strong) NSString *simple;
@property (nonatomic,strong) NSString *past;
@property (nonatomic,strong) NSString *participle;
@property (nonatomic,strong) NSString *translation;
@property (nonatomic,readonly) float averageResponseTime;
@property (nonatomic,readonly) float failureRatio;
@property (nonatomic,readonly) BOOL failed;
@property (nonatomic,readonly) float responseTime;
@property (nonatomic) float frequency;

- (id)initFromDictionary:(NSDictionary *)dictonary;
- (void)failTest;
- (void)passTestWithTime:(float)time;
- (void)resetCurrentTest;
- (void)resetHistory;

- (NSComparisonResult)compareBySimpleTense:(Verb *)other;
- (NSComparisonResult)compareByTestResults:(Verb *)other;
- (NSComparisonResult)compareByHistoricalPerformance:(Verb *)other;
@end
