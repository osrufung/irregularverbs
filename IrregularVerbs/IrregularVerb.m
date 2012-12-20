//
//  IrregularVerb.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import "IrregularVerb.h"

@interface IrregularVerb()
{
    int current_pos;
}
@property (nonatomic, strong) NSMutableArray *verbs;
@end

@implementation IrregularVerb

@synthesize verbs=_verbs, randomOrder;

- (NSMutableArray *) verbs{
    if (!_verbs) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"verbs" ofType:@"plist"];
        _verbs = [NSMutableArray arrayWithContentsOfFile:plistPath];
        current_pos=0;
    }
    return _verbs;
}

- (void)change {
    int array_tot = [self.verbs count];
    if (self.randomOrder) {
        current_pos = (arc4random() % array_tot);
    } else {
        current_pos++;
        if (current_pos>=array_tot) current_pos=0;
    }
}

- (NSString *)simple {
    return self.verbs[current_pos][@"simple"];
}

- (NSString *)translation {
    return self.verbs[current_pos][@"translation"];
}
- (NSString *)past {
    return self.verbs[current_pos][@"past"];
}
- (NSString *)participle {
    return self.verbs[current_pos][@"participle"];
}

@end
