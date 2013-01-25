//
//  VerbsStore.m
//  IrregularVerbs
//
//  Created by Rafa Barberá on 03/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "VerbsStore.h"
#import "TestCase.h"
#import "Verb.h"
#import "NSArray+Shuffling.h"

@interface VerbsStore ()

@property (nonatomic, strong) NSArray *allVerbs;
@property (nonatomic, strong) NSArray *currentList;
@property (nonatomic, strong) NSMutableDictionary *testTypesMap;
@property (nonatomic, strong) NSArray *hints;

@end
 
@implementation VerbsStore

@synthesize alphabetic=_alphabetic, frequency=_frequency, verbsNumberInTest=_verbsNumberInTest;


#pragma mark - Singleton

+(VerbsStore *) sharedStore
{
    static VerbsStore *sharedStore = nil;
    if(!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
        [self initializeTestTypes:sharedStore];
    }
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

- (NSArray *)hints {
    if (!_hints) {
        _hints  = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hints" ofType:@"plist"]];
    }
    return _hints;
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
-(NSArray *)defaultFrequencyGroups
{
    return @[@0.4, @0.5, @0.6, @0.7,@0.8,@0.9,@1.0];
}
-(int)currentFrequencyByGroup{
    float freq = [[NSUserDefaults standardUserDefaults] floatForKey:@"frequency"];
    NSLog(@"current freq %f ",freq);
    if(freq == 0.0) return 0;   
    NSArray *freqsArray = [self defaultFrequencyGroups];
    float lastValue = 0.0;
    for(int i=0;i<[freqsArray count];i++){
        if((lastValue< freq) && (freq<=[freqsArray[i] floatValue])){
            return i;
        }
        
        lastValue = [freqsArray[i] floatValue];
    }
    return 0;
}
- (int)lastTestFailedVerbsCount {
    NSPredicate *isFailed = [NSPredicate predicateWithFormat:@"isPendingOrFailed == %d",TRUE];
    return [[self.currentList filteredArrayUsingPredicate:isFailed] count];
    
}

- (NSArray *)alphabetic {
    return [self.currentList sortedArrayUsingSelector:@selector(compareVerbsAlphabetically:)];
}

- (NSArray *)results {
    return [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByTestResults:)];
}

- (NSArray *)history {
    return [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByHistoricalPerformance:)];
}

- (NSString *)hintForGroupIndex:(int)index {
    return self.hints[index];
}

- (NSArray *)verbsForGroupIndex:(int)index {
    NSArray *list = [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByHint:)];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"hint==%d",index];
    return [list filteredArrayUsingPredicate:query];
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

#pragma mark - Test Types

+ (void)initializeTestTypes:(VerbsStore *)sharedStore
{
    sharedStore.testTypesMap = [[NSMutableDictionary alloc] init];
    [sharedStore.testTypesMap setObject:NSStringFromSelector(@selector(testByFrequency)) forKey:NSLocalizedString(@"mostcommon", nil)];
    [sharedStore.testTypesMap setObject:NSStringFromSelector(@selector(testByFrequencyDes)) forKey:NSLocalizedString(@"leastcommon", nil)];
    [sharedStore.testTypesMap setObject:NSStringFromSelector(@selector(testByFailure)) forKey:NSLocalizedString(@"mostfailed", nil)];
    [sharedStore.testTypesMap setObject:NSStringFromSelector(@selector(testByRandom)) forKey:NSLocalizedString(@"randomchose", nil)];
    [sharedStore.testTypesMap setObject:NSStringFromSelector(@selector(testByTestNumber)) forKey:NSLocalizedString(@"leasttested", nil)];
    [sharedStore.testTypesMap setObject:NSStringFromSelector(@selector(testByHint)) forKey:NSLocalizedString(@"byhintgroup", nil)];
}

- (int)verbsNumberInTest {
    if (_verbsNumberInTest==0) {
        _verbsNumberInTest = [[NSUserDefaults standardUserDefaults] integerForKey:@"verbsCountInTest"];
        if (_verbsNumberInTest==0) self.verbsNumberInTest = self.currentList.count/2;
    }
    return _verbsNumberInTest;
}

- (void)setVerbsNumberInTest:(int)verbsNumberInTest {
    if (_verbsNumberInTest!=verbsNumberInTest) {
        _verbsNumberInTest=verbsNumberInTest;
        [[NSUserDefaults standardUserDefaults] setInteger:_verbsNumberInTest forKey:@"verbsCountInTest"];
    }
}

- (NSArray *)testTypes {
    return [[self.testTypesMap allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *)testByFrequency {
    NSArray *list = [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByFrequency:)];
    NSLog(@"%@",list);
    list = [list subarrayWithRange:NSMakeRange(0, self.verbsNumberInTest)];
    return [list shuffledCopy];
}

- (NSArray *)testByFrequencyDes {
    NSArray *list = [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByFrequency:)];
    NSLog(@"%@",list);
    list = [list subarrayWithRange:NSMakeRange(list.count-self.verbsNumberInTest, self.verbsNumberInTest)];
    return [list shuffledCopy];
}

- (NSArray *)testByFailure {
    NSArray *list = [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByHistoricalPerformance:)];
    NSLog(@"%@",list);
    list = [list subarrayWithRange:NSMakeRange(0, self.verbsNumberInTest)];
    return [list shuffledCopy];
}

- (NSArray *)testByRandom {
    NSArray *list = [self.currentList shuffledCopy];
    NSLog(@"%@",list);
    return [list subarrayWithRange:NSMakeRange(0, self.verbsNumberInTest)];
}

- (NSArray *)testByTestNumber {
    NSArray *list = [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByTestNumber:)];
    NSLog(@"%@",list);
    list = [list subarrayWithRange:NSMakeRange(0, self.verbsNumberInTest)];
    return [list shuffledCopy];
}

- (NSArray *)testByHint {
    NSArray *list = [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByHint:)];
    int hint=[self selectOneHintAtRandom:list];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"hint==%d",hint];
    list = [list filteredArrayUsingPredicate:query];
    NSLog(@"%@",list);
    if ([list count]>self.verbsNumberInTest) {
        list = [[list shuffledCopy] subarrayWithRange:NSMakeRange(0, self.verbsNumberInTest)];
    }
    return [list shuffledCopy];
}

- (int)selectOneHintAtRandom:(NSArray *)list {
    NSMutableSet *hints = [[NSMutableSet alloc] init];
    for (Verb *verb in list) {
        [hints addObject:@(verb.hint)];
    }
    return [[[hints allObjects] objectAtIndex:arc4random()%[hints count]] integerValue];
}


- (TestCase *)testCaseForTestType:(NSString *)testType {
    SEL selector = NSSelectorFromString([self.testTypesMap objectForKey:testType]);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSArray * verbs = [self performSelector:selector];
        return [[TestCase alloc] initWithArray:verbs description:testType];
    }
    return nil;
    
}

@end
