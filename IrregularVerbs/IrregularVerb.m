//
//  IrregularVerb.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import "IrregularVerb.h"

@interface IrregularVerb()
@property (nonatomic, strong) NSArray *verbs;

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

-(NSError *)copyDefaultVerbsListToPath:(NSString *)documentPath {
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:documentPath error:&error];
    [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"verbs" ofType:@"plist"]
                                            toPath:documentPath
                                             error:&error];
    
    return error;
}

- (NSArray *)verbsListFromDocument {
    NSString *verbsFilePath = [IrregularVerb mutableVerbsListPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:verbsFilePath])
        [self copyDefaultVerbsListToPath:verbsFilePath];
    
    NSArray *list = [NSMutableArray arrayWithContentsOfFile:verbsFilePath];
    
    // Check if the verbs list stored in Documents implments all the fields
    if ([list count]>0) {
        NSDictionary *item = list[0];
        if(![item objectForKey:@"level"]) {
            [self copyDefaultVerbsListToPath:verbsFilePath];
            list = [NSMutableArray arrayWithContentsOfFile:verbsFilePath];
        }
    }
    
    return list;
}

-(NSArray *) filteredVerbs:(NSInteger) level{
    //level filtering (1:easy, 2: medium, 3: hard, 4: ALL)
    int currentLevel= [[NSUserDefaults standardUserDefaults] integerForKey:@"difficultyLevel"];
    BOOL includeLowerLevels = [[NSUserDefaults standardUserDefaults] boolForKey:@"includeLowerLevels"];
 
    NSLog(@"Current Level %d",currentLevel);
    
    NSArray *list = [self verbsListFromDocument];
    if(currentLevel<4){
        NSString *query = (includeLowerLevels)?@"level <= %d":@"level == %d";
        NSPredicate *predicateLevel = [NSPredicate predicateWithFormat:query, currentLevel];
        NSArray *filteredArray = [list filteredArrayUsingPredicate:predicateLevel];
        
        NSLog(@"query(%@) returned %d verbs",[NSString stringWithFormat:query,currentLevel],[filteredArray count]);
        
        return filteredArray;
    }
    else{
        return list;
    }
}

- (NSArray *) verbs{
    if (!_verbs) _verbs = [self verbsListFromDocument];
    return _verbs;
}

- (void)setVerbs:(NSArray *)verbs {
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

- (NSArray *)downloadVerbsListForLevel:(int)level {
    NSArray *newVerbList = nil;
    NSString *query = [NSString stringWithFormat:@"http://irregular-verbs.appspot.com/irregularverbsapi?level=%d",level];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:query]];
    if (data) {
        NSError *error;
        newVerbList = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&error];
 
        // Checks if service return an empty list of verbs
        if ([newVerbList count] == 0) {
            NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey : @"http://irregular-verbs.appspot.com/ has returned and empty list of verbs"
            };
            
            error = [NSError errorWithDomain:@"IrregularVerbs"
                                        code:0 userInfo:userInfo];
        }
        
 
        if (error && [self.delegate respondsToSelector:@selector(updateFailedWithError:)]) {
            newVerbList=nil;
            [self.delegate updateFailedWithError:error];
        }
        
    } else {
        if ([self.delegate respondsToSelector:@selector(updateFailedWithError:)]) {
            [self.delegate updateFailedWithError:[NSError errorWithDomain:@"IrregularVerbs"
                                                                     code:1
                                                                 userInfo:@{NSLocalizedDescriptionKey:@"Error connecting to server"}]];
        }
 
    }
    
    return newVerbList;
}

- (void)setLevel:(int)level {
    if (level!=_level) {
 
        NSLog(@"Nivel %d",level);
        
        BOOL loadFromInternet= [[NSUserDefaults standardUserDefaults] boolForKey:@"loadFromInternet"];
        
        if(loadFromInternet){
            if ([self.delegate respondsToSelector:@selector(updateBegin)])
                [self.delegate updateBegin];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                NSArray *newVerbList = [self downloadVerbsListForLevel:level];
                if (newVerbList) {
                    _level = level;
                    self.verbs = newVerbList;
                }
                
                if ([self.delegate respondsToSelector:@selector(updateEnd)])
                    [self.delegate updateEnd];
            });
        }
        //filter from local plist
        else{
            self.verbs = [self filteredVerbs:level];
        }
 
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
-(int) size{
    return [self.verbs count];
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
