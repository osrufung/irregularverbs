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
@synthesize  randomOrder=_randomOrder;

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

- (NSString *)mutableVerbsListPath {
    NSArray *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *verbsFilePath = [[docDir objectAtIndex:0] stringByAppendingPathComponent:@"verbs.plist"];
    return verbsFilePath;
}

 

- (NSArray *)verbsListFromDocument {
    
    if(!allItems){
        NSString *verbsFilePath = [self mutableVerbsListPath];
        
        @try {
          allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:verbsFilePath];
        }
        @catch (NSException *e) {
            NSLog(@"Exception in %@: %@",NSStringFromSelector(_cmd), e);
        }
        if(!allItems){
            [self loadVerbsFromTemplate];
            [self saveChanges];
        }
    }
    return allItems;
}
-(void)loadVerbsFromTemplate{
    NSMutableArray *tmp  = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"verbs" ofType:@"plist"]];
    
    NSMutableArray *mutable = [[NSMutableArray alloc] initWithCapacity:tmp.count];
    for (int i=0; i<tmp.count; i++) {
        [mutable addObject:[[Verb alloc] initFromDictionary:tmp[i]]];
    }
    
    allItems = mutable;
}
-(BOOL) saveChanges {
    NSString *path = [self mutableVerbsListPath];
    NSLog(@"saving changes to Docs..");
    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
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
        allItems = [allItems shuffledCopy];
    } else {
        allItems= [allItems sortedArrayUsingComparator:^(id ob1, id ob2){
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
-(NSArray *)allVerbs{
    
    return [self verbsListFromDocument];
}
 
-(void)printListtoConsole{
    NSLog(@"%@",allItems);
}

@end
