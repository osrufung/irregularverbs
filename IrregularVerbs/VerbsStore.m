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
        
    // NSKeyedUnarchiver didn't reeturn nil on error, it will throw an exception
    @try {
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:verbsFilePath];
    }
    @catch (NSException *exception) {
            NSMutableArray *tmp  = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"verbs" ofType:@"plist"]];
            
            NSMutableArray *mutable = [[NSMutableArray alloc] initWithCapacity:tmp.count];
            for (int i=0; i<tmp.count; i++) {
                [mutable addObject:[[Verb alloc] initFromDictionary:tmp[i]]];
            }
 
            allItems = mutable;
            
            [self saveChanges];

        }
    }
    return allItems;
}
-(BOOL) saveChanges {
    NSString *path = [self mutableVerbsListPath];
    NSLog(@"saving changes to Docs..");
    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
}
- (NSArray *)localVerbsForLevel:(int)level includeLowerLevels:(BOOL)lowerLevels {
    NSArray *list = [self verbsListFromDocument];
  /*@TODO filtrar por nivel
    NSString *query = (lowerLevels)?@"level <= %d":@"level == %d";
    NSPredicate *predicateLevel = [NSPredicate predicateWithFormat:query, level];
    NSArray *filteredArray = [list filteredArrayUsingPredicate:predicateLevel];
   */
   //return [[IrregularVerb alloc] initWithData:filteredArray];
    return list;
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
- (NSArray *)verbsForLevel:(int)level includeLowerLevels:(BOOL)lowerLevels  {
 
        return [self localVerbsForLevel:level includeLowerLevels:lowerLevels];
   
}


-(NSArray *)allVerbs{
    return allItems;
}
-(void)printListtoConsole{
    for(Verb *v in allItems){
        NSLog(@"%@ - %f",[v simple],[v responseTime]);
    }
}

@end
