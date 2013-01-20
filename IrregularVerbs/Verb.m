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
        self.hint = [dictionary[@"hint"] integerValue];
        _testPending = YES;
    }
    return self;
}

- (void)computeAverageAddingSample:(float)time {
    int numberOk = self.numberOfTests-self.numberOfFailures;
    _responseTime = time;
    if (numberOk==0) _averageResponseTime = _responseTime;
    else _averageResponseTime = _averageResponseTime + 0.1*(_responseTime-_averageResponseTime);
    self.numberOfTests++;
}

- (void)computeAverageRemovingSample:(float)time {
    int numberOk = self.numberOfTests-self.numberOfFailures;
    _responseTime = time;
    if (numberOk==1)
        _averageResponseTime = 0.0f;
    else
        _averageResponseTime = (_averageResponseTime - 0.1*_responseTime)/0.9f;
    _responseTime = 0.0f;
    self.numberOfTests--;
}

- (void)passTestWithTime:(float)time {
    if (self.testPending) {
        _testPending=NO;
        _failed=NO;
        [self computeAverageAddingSample:time];
    }
}

- (void)failTest {
    if (self.testPending) {
        _testPending = NO;
        _failed = YES;
        self.numberOfFailures++;
        self.numberOfTests++;
        
    } else if (!_failed) {
        _failed = YES;
        [self computeAverageRemovingSample:_responseTime];
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

- (int)testCount {
    return self.numberOfTests;
}

- (int)failCount {
    return self.numberOfFailures;
}

- (int)passCount {
    return self.numberOfTests-self.numberOfFailures;
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
    return [NSString stringWithFormat:@"%-15s freq:%.4f time:%.2fs hint:%2d test#:%2d fail#:%2d",[self.simple UTF8String],
            self.frequency, self.averageResponseTime, self.hint,self.numberOfTests,self.numberOfFailures];
}

#pragma  mark - NSCoding Persistence

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.simple forKey:@"simple"];
    [aCoder encodeObject:self.past forKey:@"past"];
    [aCoder encodeObject:self.participle forKey:@"participle"];
    [aCoder encodeObject:self.translation forKey:@"translation"];
    [aCoder encodeFloat:self.frequency forKey:@"frequency"];
    [aCoder encodeInt:self.hint forKey:@"hint"];

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
        [self setHint:[aDecoder decodeIntForKey:@"hint"]];
        
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
    if ((self.failed) && (other.failed)) {
        return [self.simple compare:other.simple];
    } else if ((self.failed) && (!other.failed)) {
        return (NSComparisonResult)NSOrderedAscending;
    } else if ((!self.failed) && (other.failed)) {
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
        if (self.averageResponseTime>other.averageResponseTime) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if(self.averageResponseTime<other.averageResponseTime) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else return [self.simple compare:other.simple];
    }
}

- (NSComparisonResult)compareVerbsByFrequency:(Verb *)other {
    return self.frequency<other.frequency;
}

- (NSComparisonResult)compareVerbsByTestNumber:(Verb *)other {
    return self.numberOfTests>other.numberOfTests;
}

- (NSComparisonResult)compareVerbsByHint:(Verb *)other {
    if (self.hint==other.hint) {
        return [self.simple compare:other.simple];
    } else
        return self.hint>other.hint;
}

- (NSComparisonResult)compareVerbsByAverageResponseTime:(Verb *)other {
    if (self.averageResponseTime==other.averageResponseTime) {
        return self.testCount<other.testCount;
    } else {
        return self.averageResponseTime<other.averageResponseTime;
    }
}


@end
