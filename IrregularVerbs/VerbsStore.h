//
//  VerbsStore.h
//  IrregularVerbs
//
//  Created by Rafa Barberá on 03/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VerbsStoreDelegate<NSObject>

@optional
- (void)updateBegin;
- (void)updateFailedWithError:(NSError *)error;
- (void)updateEnd;

@end


@class IrregularVerb;

@interface VerbsStore : NSObject

{
    NSArray *allItems;
}

+ (VerbsStore *)sharedStore;
@property (nonatomic) BOOL randomOrder;
@property (nonatomic, strong) id<VerbsStoreDelegate> delegate;

//- (NSArray *)verbsForLevel:(int)level includeLowerLevels:(BOOL)lowerLevels ;

-(BOOL) saveChanges;
-(NSArray *)allVerbs;
-(void)printListtoConsole;
-(int) numberOfVerbsForDifficulty:(float) difficulty;
-(NSArray *)verbsForDifficulty:(float) difficulty;
@end
