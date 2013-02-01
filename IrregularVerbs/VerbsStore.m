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
/*
 verbs hints extracted from http://www.whitesmoke.com/english-irregular-verbs
 */
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
    return @[@0.6, @0.8, @1.0];
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
- (int)failedOrNotTestedVerbsCount {
    NSPredicate *isPendingPred = [NSPredicate predicateWithFormat:@"(numberOfTests == 0) OR (numberOfFailures == numberOfTests) "];
    return [[self.currentList filteredArrayUsingPredicate:isPendingPred] count];
    
}

- (NSArray *)alphabetic {
    return [self.currentList sortedArrayUsingSelector:@selector(compareVerbsAlphabetically:)];
}

- (NSArray *)results {
    return [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByTestResults:)];
}

- (NSArray *)history {
    return [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByRecentFailure:)];
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
    for (NSString *key in self.testTypes) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:key];
    }
    for (Verb *verb in self.allVerbs) {
        [verb resetHistory];
    }
    [self saveChanges];
}

#pragma mark - Test Types

+ (void)setSelector:(SEL)selector forKey:(NSString *)key inDictionary:(NSMutableDictionary *)dict {
    NSMethodSignature *signature = [VerbsStore instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [dict setObject:invocation forKey:key];
}

+ (void)initializeTestTypes:(VerbsStore *)sharedStore
{
    
    sharedStore.testTypesMap = [[NSMutableDictionary alloc] init];
        
    [self setSelector:@selector(testByFrequency) forKey:NSLocalizedString(@"mostcommon", nil) inDictionary:sharedStore.testTypesMap];
    [self setSelector:@selector(testByFrequencyDes) forKey:NSLocalizedString(@"leastcommon", nil) inDictionary:sharedStore.testTypesMap];
    [self setSelector:@selector(testByFailure) forKey:NSLocalizedString(@"mostfailed", nil) inDictionary:sharedStore.testTypesMap];
    [self setSelector:@selector(testByRandom) forKey:NSLocalizedString(@"randomchose", nil) inDictionary:sharedStore.testTypesMap];
    [self setSelector:@selector(testByTestNumber) forKey:NSLocalizedString(@"leasttested", nil) inDictionary:sharedStore.testTypesMap];
    [self setSelector:@selector(testByHint) forKey:NSLocalizedString(@"byhintgroup", nil) inDictionary:sharedStore.testTypesMap];    
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
    NSArray *list = [self.currentList sortedArrayUsingSelector:@selector(compareVerbsByRecentFailure:)];
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

/*
 * The reason is that the invokation's return object is not retained, so it will go away, even if you immediately assign it to an object reference, 
 * unless you first retain it and then tell ARC to transfer ownership.
 * http://stackoverflow.com/questions/7078109/why-does-nsinvocation-getreturnvalue-loose-object
 */
- (TestCase *)testCaseForTestType:(NSString *)testType {
    NSInvocation *invocation = [self.testTypesMap objectForKey:testType];

    CFTypeRef result;
    [invocation invokeWithTarget:self];
    [invocation getReturnValue:&result];
    if (result) CFRetain(result);
    return [[TestCase alloc] initWithArray:(__bridge_transfer NSArray*)result description:testType];
}

@end
