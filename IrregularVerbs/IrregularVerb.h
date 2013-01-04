//
//  IrregularVerb.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IrregularVerb : NSObject

@property (nonatomic, readonly) NSString *simple;
@property (nonatomic, readonly) NSString *translation;
@property (nonatomic, readonly) NSString *past;
@property (nonatomic, readonly) NSString *participle;

@property (nonatomic) NSInteger currentPos;
@property (nonatomic) BOOL randomOrder;

- (id)initWithData:(NSArray *)verbList;
- (int)count;
@end
