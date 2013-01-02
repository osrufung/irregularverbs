//
//  IrregularVerb.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IrregularVerbDelegate<NSObject>

@optional
- (void)updateBegin;
- (void)updateFailedWithError:(NSError *)error;
- (void)updateEnd;

@end

@interface IrregularVerb : NSObject
@property (nonatomic) NSInteger currentPos;
@property (nonatomic) BOOL randomOrder;
@property (nonatomic) int level;
@property (nonatomic, readonly) NSString *simple;
@property (nonatomic, readonly) NSString *translation;
@property (nonatomic, readonly) NSString *past;
@property (nonatomic, readonly) NSString *participle;

@property (nonatomic, strong) id<IrregularVerbDelegate> delegate;

- (void)change;
- (int)size;
@end
