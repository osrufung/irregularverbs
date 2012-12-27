//
//  IrregularVerb.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import "IrregularVerb.h"

@interface IrregularVerb()
@property (nonatomic, strong) NSMutableArray *verbs;
@property (nonatomic) NSInteger currentPos;
@end

@implementation IrregularVerb

@synthesize verbs=_verbs, randomOrder=_randomOrder, currentPos=_currentPos;

+ (NSString *)mutableVerbsListPath {
    NSArray *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *verbsFilePath = [[docDir objectAtIndex:0] stringByAppendingPathComponent:@"verbs.plist"];
    return verbsFilePath;
}


// It's needed to get the last inner state (random/sorted and last position)
- (id)init {
    self = [super init];
    if (self) {
        self.randomOrder = [[NSUserDefaults standardUserDefaults] boolForKey:@"randomOrder"];
        if (!self.randomOrder) {
            self.currentPos=[[NSUserDefaults standardUserDefaults] integerForKey:@"currentPos"];
        } else self.currentPos = (arc4random() % [self.verbs count]);
    }
    return self;
}

- (NSMutableArray *)verbsListFromDocument {
    NSString *verbsFilePath = [IrregularVerb mutableVerbsListPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:verbsFilePath]) {
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"verbs" ofType:@"plist"]
                                                toPath:verbsFilePath
                                                 error:&error];
    }
    NSMutableArray *list = [NSMutableArray arrayWithContentsOfFile:verbsFilePath];
    return list;
}



- (NSMutableArray *) verbs{
    if (!_verbs) _verbs = [self verbsListFromDocument];
    return _verbs;
}

- (void)setRandomOrder:(BOOL)randomOrder {
    if (randomOrder!=_randomOrder) {
        _randomOrder = randomOrder;
        [[NSUserDefaults standardUserDefaults] setBool:_randomOrder forKey:@"randomOrder"];
    }
}

- (void)setCurrentPos:(NSInteger)currentPos {
    if (currentPos!=_currentPos) {
        _currentPos=currentPos;
        [[NSUserDefaults standardUserDefaults] setInteger:_currentPos forKey:@"currentPos"];
    }
}

- (NSMutableArray *)downloadVerbsListForLevel:(int)level {
    NSURL *apiURL = [NSURL URLWithString:@"http://irregular-verbs.appspot.com/irregularverbsapi"];
    NSData *data = [NSData dataWithContentsOfURL:apiURL];
    NSError *error;
    NSMutableArray *newVerbList = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingMutableContainers
                                                                                      error:&error];
    return newVerbList;
}

- (void)setLevel:(int)level {
    if (level!=_level) {
        NSMutableArray *newVerbList = [self downloadVerbsListForLevel:level];
        if (newVerbList) {
            _level = level;
            self.verbs = newVerbList;
        }
    }
}

- (void)change {
    if (self.randomOrder) {
        self.currentPos = (arc4random() % [self.verbs count]);
    } else {
        self.currentPos++;
        if (self.currentPos>=[self.verbs count]) self.currentPos=0;
    }
}

- (NSString *)simple {
    return self.verbs[self.currentPos][@"simple"];
}

- (NSString *)translation {
    return self.verbs[self.currentPos][@"translation"];
}
- (NSString *)past {
    return self.verbs[self.currentPos][@"past"];
}
- (NSString *)participle {
    return self.verbs[self.currentPos][@"participle"];
}

@end
