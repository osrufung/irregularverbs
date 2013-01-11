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
{
    BOOL _testPending;
}

@property (nonatomic) int numberOfTests;
@property (nonatomic) int numberOfFailures;

@end

@implementation Verb

// Only the readonly properties needs that we explicit synthesize them
@synthesize averageResponseTime=_averageResponseTime, failureRatio=_failureRatio, failed=_failed, responseTime=_responseTime;

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

- (void)passTestWithTime:(float)time {
    if (_testPending) {
        _testPending=NO;
        _failed=NO;
        int numberOk = self.numberOfTests-self.numberOfFailures;
        _responseTime = time;
        _averageResponseTime = (_averageResponseTime*numberOk+_responseTime)/(numberOk+1);
        self.numberOfTests++;
        
        NSLog(@"Adding %fs the average response time for %@ is %fs",_responseTime,self.simple, _averageResponseTime);
    }
}
-(BOOL)isPendingOrFailed{
    return _testPending | _failed;
}
- (void)failTest {
    if (_testPending) {
        _testPending = NO;
        _failed = YES;
        self.numberOfFailures++;
        self.numberOfTests++;
        
        NSLog(@"After this fail, the failure ratio for %@ is %f",self.simple,self.failureRatio);
    }
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

#pragma mark - Verb comparators

NSComparisonResult(^compareVerbsAlphabeticaly)(id,id) = ^(id ob1, id ob2) {
    Verb *v1=ob1;
    Verb *v2=ob2;
    return [v1.simple compare:v2.simple];
};

NSComparisonResult(^compareVerbsByTestResults)(id,id) = ^(id ob1, id ob2) {
    Verb *v1=ob1;
    Verb *v2=ob2;
    if (v1.failed && v2.failed) {
        return [v1.simple compare:v2.simple];
    } else if (v1.failed && !v2.failed) {
        return (NSComparisonResult)NSOrderedAscending;
    } else if (!v1.failed && v2.failed) {
        return (NSComparisonResult)NSOrderedDescending;
    } else {
        if (v1.responseTime>v2.responseTime) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if(v1.responseTime<v2.responseTime) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else return [v1.simple compare:v2.simple];
    }
};

NSComparisonResult(^compareVerbsByHistoricalPerformance)(id,id) = ^(id ob1, id ob2){
    Verb *v1=ob1;
    Verb *v2=ob2;
    if (v1.failureRatio<v2.failureRatio) {
        return (NSComparisonResult)NSOrderedDescending;
    } else if (v1.failureRatio>v2.failureRatio) {
        return (NSComparisonResult)NSOrderedAscending;
    } else {
        if (v1.responseTime>v2.responseTime) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if(v1.responseTime<v2.responseTime) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else return [v1.simple compare:v2.simple];
    }
};

NSComparisonResult(^compareVerbsByFrequency)(id,id) = ^(id ob1, id ob2){
    Verb *v1 = (Verb *) ob1;
    Verb *v2 = (Verb *) ob2;
    
    return v1.frequency<v2.frequency;
};

@end
