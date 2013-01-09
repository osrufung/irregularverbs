//
//  Verb.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 08/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "Verb.h"
#import "VerbsStore.h"
@implementation Verb

@synthesize simple=_simple, past = _past, participle=_participle, translation=_translation ;
@synthesize responseTime;
- (id)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.simple = dictionary[@"simple"];
        self.past = dictionary[@"past"];
        self.participle = dictionary[@"participle"];
        self.translation = dictionary[@"translation"];
        self.responseTime = 0.0;
        self.failed = NO;
        //self.level = [dictionary[@"level"] intValue];
    }
    return self;
}
#pragma  mark - NSCoding Persistence
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.simple forKey:@"simple"];
    [aCoder encodeObject:self.past forKey:@"past"];
    [aCoder encodeObject:self.participle forKey:@"participle"];
    [aCoder encodeObject:self.translation forKey:@"translation"];
    [aCoder encodeBool:self.failed forKey:@"failed"];
    [aCoder encodeFloat:self.responseTime forKey:@"responseTime"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        [self setSimple:[aDecoder decodeObjectForKey:@"simple"]];
        [self setPast:[aDecoder decodeObjectForKey:@"past"]];
        [self setParticiple:[aDecoder decodeObjectForKey:@"participle"]];
        [self setTranslation:[aDecoder decodeObjectForKey:@"translation"]];
        [self setFailed:[aDecoder decodeBoolForKey:@"failed"]];
        [self setResponseTime:[aDecoder decodeFloatForKey:@"responseTime"]];
 
    }
    return self;
}
-(void)setResponseTime:(float)rt{
    responseTime = rt;
    
}

-(void)addNewResponseTime:(float)rt{
 
    if(responseTime >0 )
        responseTime = (responseTime + rt) /2.0;
    else
        responseTime = rt;
    NSLog(@"new computed time is : %f",responseTime);
    //persist in Store
    [[VerbsStore sharedStore] saveChanges];
}
@end
