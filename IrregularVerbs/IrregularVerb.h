//
//  IrregularVerb.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Verb.h"

@interface IrregularVerb : NSObject

@property (nonatomic) BOOL randomOrder;
@property (nonatomic, strong) NSArray *verbs;

- (id)initWithData:(NSArray *)verbList;
- (int)count;
//- (Verb *)verbAtIndex:(int)index;
@end
