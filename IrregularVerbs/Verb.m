//
//  Verb.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 08/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "Verb.h"
#import "VerbsStore.h"

@interface Verb()

@property (nonatomic) int numberOfTests;
@property (nonatomic) int numberOfFailures;

@end

@implementation Verb

// Only the readonly properties needs that we explicit synthesize them
@synthesize averageResponseTime=_averageResponseTime, failureRatio=_failureRatio, failed=_failed, responseTime=_responseTime, testPending=_testPending;

- (id)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.simple = dictionary[@"simple"];
        self.past = dictionary[@"past"];
        self.participle = dictionary[@"participle"];
        self.translation = dictionary[@"translation"];
        self.frequency = [dictionary[@"frequency"] floatValue];
        _testPending = YES;
    }
    return self;
}

- (void)computeAverageAddingSample:(float)time {
    int numberOk = self.numberOfTests-self.numberOfFailures;
    _responseTime = time;
    _averageResponseTime = (_averageResponseTime*numberOk+_responseTime)/(numberOk+1);
    self.numberOfTests++;
}

- (void)computeAverageRemovingSample:(float)time {
    int numberOk = self.numberOfTests-self.numberOfFailures;
    _responseTime = time;
    if (numberOk==1)
        _averageResponseTime = 0.0f;
    else
        _averageResponseTime = (_averageResponseTime*numberOk-_responseTime)/(numberOk-1);
    _responseTime = 0.0f;
    self.numberOfTests--;
}

- (void)passTestWithTime:(float)time {
    if (self.testPending) {
        _testPending=NO;
        _failed=NO;
        [self computeAverageAddingSample:time];
        NSLog(@"Adding %fs the average response time for %@ is %fs in %d tests",_responseTime,self.simple, _averageResponseTime,_numberOfTests);
    }
}

- (void)failTest {
    if (self.testPending) {
        _testPending = NO;
        _failed = YES;
        self.numberOfFailures++;
        self.numberOfTests++;
        
        NSLog(@"After this fail, the failure ratio for %@ is %f",self.simple,self.failureRatio);
    } else if (!_failed) {
        _failed = YES;
        [self computeAverageRemovingSample:_responseTime];
        NSLog(@"Removing current sample the average response time for %@ is %fs in %d tests",self.simple, _averageResponseTime,_numberOfTests);
        self.numberOfFailures++;
        self.numberOfTests++;
    }
}

- (BOOL)isPendingOrFailed{
    return self.testPending | self.failed;
}

- (float)averageResponseTime {
    return _averageResponseTime;
}

- (float)failureRatio {
    if (!self.numberOfTests) return 0.0;
    else return (float)self.numberOfFailures/self.numberOfTests;
}

- (void)resetCurrentTest {
    _testPending = YES;
    _failed = NO;
    _responseTime = 0.0;
}

- (void)resetHistory {
    [self resetCurrentTest];
    self.numberOfTests = 0;
    self.numberOfFailures = 0;
    _averageResponseTime = 0.0;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %f (%f)",self.simple,self.responseTime,self.frequency];
}

#pragma  mark - NSCoding Persistence

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.simple forKey:@"simple"];
    [aCoder encodeObject:self.past forKey:@"past"];
    [aCoder encodeObject:self.participle forKey:@"participle"];
    [aCoder encodeObject:self.translation forKey:@"translation"];
    [aCoder encodeFloat:self.frequency forKey:@"frequency"];

    [aCoder encodeInt:self.numberOfTests forKey:@"numberOfTests"];
    [aCoder encodeInt:self.numberOfFailures forKey:@"numberOfFailures"];
    [aCoder encodeFloat:self.averageResponseTime forKey:@"averageResponseTime"];

}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        [self setSimple:[aDecoder decodeObjectForKey:@"simple"]];
        [self setPast:[aDecoder decodeObjectForKey:@"past"]];
        [self setParticiple:[aDecoder decodeObjectForKey:@"participle"]];
        [self setTranslation:[aDecoder decodeObjectForKey:@"translation"]];
        [self setFrequency:[aDecoder decodeFloatForKey:@"frequency"]];
        
        self.numberOfTests = [aDecoder decodeIntForKey:@"numberOfTests"];
        self.numberOfFailures = [aDecoder decodeIntForKey:@"numberOfFailures"];
        _averageResponseTime = [aDecoder decodeFloatForKey:@"averageResponseTime"];
        
        _testPending = YES;
    }
    return self;
}


#pragma mark - Comparators

- (NSComparisonResult)compareVerbsAlphabetically:(Verb *)other {
    return [self.simple compare:other.simple];
}

- (NSComparisonResult)compareVerbsByTestResults:(Verb *)other {
    if (self.failed && other.failed) {
        return [self.simple compare:other.simple];
    } else if (self.failed && !other.failed) {
        return (NSComparisonResult)NSOrderedAscending;
    } else if (!self.failed && other.failed) {
        return (NSComparisonResult)NSOrderedDescending;
    } else {
        if (self.responseTime>other.responseTime) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if(self.responseTime<other.responseTime) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else return [self.simple compare:other.simple];
    }
}

- (NSComparisonResult)compareVerbsByHistoricalPerformance:(Verb *)other {
    if (self.failureRatio<other.failureRatio) {
        return (NSComparisonResult)NSOrderedDescending;
    } else if (self.failureRatio>other.failureRatio) {
        return (NSComparisonResult)NSOrderedAscending;
    } else {
        if (self.responseTime>other.responseTime) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if(self.responseTime<other.responseTime) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else return [self.simple compare:other.simple];
    }
}

- (NSComparisonResult)compareVerbsByFrequency:(Verb *)other {
    return self.frequency<other.frequency;
}

- (NSComparisonResult)compareVerbsByTestNumber:(Verb *)other {
    return self.numberOfTests<other.numberOfTests;
}


@end
