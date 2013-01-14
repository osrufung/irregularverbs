//
//  VerbsStore.h
//  IrregularVerbs
//
//  Created by Rafa Barberá on 03/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerbsStore : NSObject

@property (nonatomic) float frequency;

@property (nonatomic, readonly) NSArray *alphabetic;
@property (nonatomic, readonly) NSArray *random;
@property (nonatomic, readonly) NSArray *results;
@property (nonatomic, readonly) NSArray *history;

+ (VerbsStore *)sharedStore;

-(BOOL) saveChanges;
-(BOOL) resetVerbsStore;

-(void) resetHistory;
-(void) resetTest;

@end
