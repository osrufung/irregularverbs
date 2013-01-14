//
//  VerbsStore.m
//  IrregularVerbs
//
//  Created by Rafa Barberá on 03/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "VerbsStore.h"
#import "Verb.h"
#import "NSArray+Shuffling.h"

@interface VerbsStore ()

@property (nonatomic, strong) NSArray *allVerbs;
@property (nonatomic, strong) NSArray *currentList;

@end
 
@implementation VerbsStore

@synthesize alphabetic=_alphabetic, frequency=_frequency;


#pragma mark - Singleton

+(VerbsStore *) sharedStore
{
    static VerbsStore *sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    return sharedStore;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

#pragma mark - File management

- (NSString *)mutableVerbsListPath {
    NSArray *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *verbsFilePath = [[docDir objectAtIndex:0] stringByAppendingPathComponent:@"verbs.plist"];
    return verbsFilePath;
}

- (NSArray *)loadVerbsFromTemplate{
    NSMutableArray *tmp  = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"verbs" ofType:@"plist"]];
    
    NSMutableArray *mutable = [[NSMutableArray alloc] initWithCapacity:tmp.count];
    for (int i=0; i<tmp.count; i++) {
        [mutable addObject:[[Verb alloc] initFromDictionary:tmp[i]]];
    }
    return mutable;
}

-(BOOL) saveChanges {
    NSString *path = [self mutableVerbsListPath];
    NSLog(@"saving changes to Docs..");
    
    return [NSKeyedArchiver archiveRootObject:self.allVerbs toFile:path];
}

-(BOOL) resetVerbsStore{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[self mutableVerbsListPath] error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    else{
        _currentList=nil;
    }
    return success;
}
#pragma mark - access to verbs

- (NSArray *)allVerbs {
    
    if(!_allVerbs){
        NSString *verbsFilePath = [self mutableVerbsListPath];
        
        @try {
            _allVerbs = [NSKeyedUnarchiver unarchiveObjectWithFile:verbsFilePath];
        }
        @catch (NSException *e) {
            NSLog(@"Exception in %@: %@",NSStringFromSelector(_cmd), e);
            _allVerbs=nil;
        }
        if(!_allVerbs){
            _allVerbs = [self loadVerbsFromTemplate];
        }
    }
    return _allVerbs;
}

-(NSArray *)verbsByFrequency:(float) frequency{
    int idx = 0;
    
    if (frequency==1.0f)
        return [self allVerbs];
    else if (frequency == 0.0f){
        return nil;
    }
    else{
        NSArray *sortedArray = [[self allVerbs] sortedArrayUsingSelector:@selector(compareVerbsByFrequency:)];
        float freqAcum=0.0f;
        for (idx=0;idx<sortedArray.count;idx++) {
            Verb *v = sortedArray[idx];
            freqAcum += v.frequency;
            if (frequency<=freqAcum) {
                break;
            }
        }
        NSRange range;
        range.location=0;
        range.length=idx;
        return [sortedArray subarrayWithRange:range];
        
    }
}

- (float)frequency {
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"frequency"];
}

- (void)setFrequency:(float)frequency {
    if (_frequency!=frequency) {
        _frequency=frequency;
        _currentList=nil;
        [[NSUserDefaults standardUserDefaults] setFloat:_frequency forKey:@"frequency"];
    
    }
}

- (NSArray *)currentList {
    if (!_currentList) {
        _currentList = [self verbsByFrequency:self.frequency];
    }
    return _currentList;
}

- (int)lastTestFailedVerbsCount {
    NSPredicate *isFailed = [NSPredicate predicateWithFormat:@"isPendingOrFailed == %d",TRUE];
    return [[self.currentList filteredArrayUsingPredicate:isFailed] count];
    
}

- (NSArray *)alphabetic {
    return [self.currentList sortedArrayUsingSelector:@selector(compareVerbsAlphabetically:)];
}

- (NSArray *)random {
    return [self.currentList shuffledCopy];
}

- (NSArray *)results {
    return [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByTestResults:)];
}

- (NSArray *)history {
    return [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByHistoricalPerformance:)];
}


- (void)resetHistory {
    for (Verb *verb in self.allVerbs) {
        [verb resetHistory];
    }
    [self saveChanges];
}

- (void)resetTest {
    for (Verb *verb in self.currentList) {
        [verb resetCurrentTest];
    }
}


@end
