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

@property (nonatomic, strong) id<VerbsStoreDelegate> delegate;

- (IrregularVerb *)verbsForLevel:(int)level includeLowerLevels:(BOOL)lowerLevels fromInternet:(BOOL)fromRemote;
- (IrregularVerb *)allVerbsFromInternet:(BOOL)fromRemote;

@end
