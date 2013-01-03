//
//  VerbsStore.m
//  IrregularVerbs
//
//  Created by Rafa Barberá on 03/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "VerbsStore.h"
#import "IrregularVerb.h"

@implementation VerbsStore

- (NSString *)mutableVerbsListPath {
    NSArray *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *verbsFilePath = [[docDir objectAtIndex:0] stringByAppendingPathComponent:@"verbs.plist"];
    return verbsFilePath;
}

- (NSError *)copyDefaultVerbsListToPath:(NSString *)documentPath {
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:documentPath error:&error];
    [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"verbs" ofType:@"plist"]
                                            toPath:documentPath
                                             error:&error];
    
    return error;
}

- (NSArray *)verbsListFromDocument {
    NSString *verbsFilePath = [self mutableVerbsListPath];
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

- (IrregularVerb *)localVerbsForLevel:(int)level includeLowerLevels:(BOOL)lowerLevels {
    NSArray *list = [self verbsListFromDocument];
    NSString *query = (lowerLevels)?@"level <= %d":@"level == %d";
    NSPredicate *predicateLevel = [NSPredicate predicateWithFormat:query, level];
    NSArray *filteredArray = [list filteredArrayUsingPredicate:predicateLevel];
    return [[IrregularVerb alloc] initWithData:filteredArray];
}

- (NSArray *)downloadListForLevel:(int)level {
    NSArray *newVerbList = nil;
    NSString *query = [NSString stringWithFormat:@"http://irregular-verbs.appspot.com/irregularverbsapi?level=%d",level];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:query]];
    if (data) {
        NSError *error;
        newVerbList = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&error];
        
        // Checks if service return an empty list of verbs
        if (newVerbList.count == 0) {
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

- (IrregularVerb *)remoteVerbsForLevel:(int)level includeLowerLevels:(BOOL) lowerLevels {
    if ([self.delegate respondsToSelector:@selector(updateBegin)])
        [self.delegate updateBegin];
    
    NSArray __block *newVerbList = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        newVerbList = [self downloadListForLevel:level];
    });
    
    if ([self.delegate respondsToSelector:@selector(updateEnd)])
        [self.delegate updateEnd];

    return [[IrregularVerb alloc] initWithData:newVerbList];

}


- (IrregularVerb *)verbsForLevel:(int)level includeLowerLevels:(BOOL)lowerLevels fromInternet:(BOOL)fromRemote {
    if (fromRemote) {
        return [self remoteVerbsForLevel:level includeLowerLevels:lowerLevels];
    } else {
        return [self localVerbsForLevel:level includeLowerLevels:lowerLevels];
    }
}

- (IrregularVerb *)allVerbsFromInternet:(BOOL)fromRemote {
    if (!fromRemote) {
        return [[IrregularVerb alloc] initWithData:[self verbsListFromDocument]];
    } else {
        return nil;
    }
}

@end
