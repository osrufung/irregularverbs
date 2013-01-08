//
//  Verb.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 08/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "Verb.h"

@implementation Verb

@synthesize simple=_simple, past = _past, participle=_participle, translation=_translation;

- (id)initFromDictionary:(NSDictionary *)dictonary {
    self = [super init];
    if (self) {
        self.simple = dictonary[@"simple"];
        self.past = dictonary[@"past"];
        self.participle = dictonary[@"participle"];
        self.translation = dictonary[@"translation"];
    }
    return self;
}

@end
