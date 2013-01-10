//
//  VerbsStore.h
//  IrregularVerbs
//
//  Created by Rafa Barberá on 03/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VerbsStore : NSObject

@property (nonatomic) BOOL randomOrder;
@property (nonatomic, readonly) NSArray *allVerbs;

+ (VerbsStore *)sharedStore;

-(int) numberOfVerbsForDifficulty:(float) difficulty;
-(NSArray *)verbsForDifficulty:(float) difficulty;
-(BOOL) saveChanges;
-(BOOL) resetVerbsStore;

@end
