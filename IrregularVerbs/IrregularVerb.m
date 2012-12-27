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

@synthesize verbs=_verbs, randomOrder=_randomOrder, currentPos=_currentPos, level=_level;

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

- (void)setVerbs:(NSMutableArray *)verbs {
    if (_verbs!=verbs) {
        _verbs = verbs;
        if (self.currentPos>=[_verbs count]) self.currentPos=0;
    }
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
    NSMutableArray *newVerbList = nil;
    NSString *query = [NSString stringWithFormat:@"http://irregular-verbs.appspot.com/irregularverbsapi?level=%d",level];
    NSURL *apiURL = [NSURL URLWithString:query];
    NSData *data = [NSData dataWithContentsOfURL:apiURL];
    if (data) {
        NSError *error;
        newVerbList = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate updateFailedWithError:error];
            });
        }

    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate updateFailedWithError:[NSError errorWithDomain:@"IrregularVerbs"
                                                                     code:1
                                                                 userInfo:@{NSLocalizedDescriptionKey:@"Error connecting to server"}]];
        });
        
    }
    return newVerbList;
}

- (void)setLevel:(int)level {
    if (level!=_level) {
        [self.delegate updateBegin];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            NSMutableArray *newVerbList = [self downloadVerbsListForLevel:level];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (newVerbList) {
                    _level = level;
                    self.verbs = newVerbList;
                }
                [self.delegate updateEnd];
            });
        });
    }
}

- (void)change {
    if (self.randomOrder) {
        if ([self.verbs count]) {
            self.currentPos = (arc4random() % [self.verbs count]);
        } else self.currentPos = 0;
        
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
