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
 
 
@implementation VerbsStore


#pragma mark - Singleton

@synthesize allVerbs=_allVerbs;

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
        _allVerbs = [self loadVerbsFromTemplate];
    
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
            //[self saveChanges]; // I've serious doubts about saving the data here... OR: Yes, maybe is better to wait user plays ;)
            
        }
    }
    return _allVerbs;
}

- (void)setRandomOrder:(BOOL)randomOrder {
    if (randomOrder!=_randomOrder) {
        _randomOrder = randomOrder;
        [[NSUserDefaults standardUserDefaults] setBool:_randomOrder forKey:@"randomOrder"];
        [self sortVerbsList];
    }
}
- (void)sortVerbsList {
    if (self.randomOrder) {
        _allVerbs = [_allVerbs shuffledCopy];
    } else {
        _allVerbs= [_allVerbs sortedArrayUsingComparator:^(id ob1, id ob2){
            Verb *v1 = ob1;
            Verb *v2 = ob2;
            return [v1.simple compare:v2.simple];
        }];
    }
}
 

-(NSArray *)verbsForDifficulty:(float) difficulty{
    int idx = 0;
    
    if (difficulty==1.0f)
        return [self verbsSortedbyFrequency];
    else if (difficulty == 0.0f){
        return nil;
    }
    else{
        NSArray *sortedArray = [self verbsSortedbyFrequency];
        float freqAcum=0.0f;
        for (idx=0;idx<sortedArray.count;idx++) {
            Verb *v = sortedArray[idx];
            freqAcum += v.frequency;
            if (difficulty<=freqAcum) {
                break;
            }
        }
        NSRange range;
        range.location=0;
        range.length=idx;
        return [sortedArray subarrayWithRange:range];
      
    }
 
}

-(NSArray *) verbsSortedbyFrequency{
    return [ [self allVerbs] sortedArrayUsingComparator:^(id ob1,id ob2) {
        Verb *v1 = (Verb *) ob1;
        Verb *v2 = (Verb *) ob2;
        
        return v1.frequency<v2.frequency;
    }];
}


-(int) numberOfVerbsForDifficulty:(float) difficulty{
    return [[self verbsForDifficulty:difficulty] count];
 
}
@end
