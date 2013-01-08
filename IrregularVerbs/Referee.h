//
//  Referee.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 08/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Referee : NSObject

@property (nonatomic) float maxValue;

+ (Referee *)sharedReferee;

- (float)performanceForValue:(float)value;
- (UIColor *)colorForFail;
- (UIColor *)colorForValue:(float)value;
- (UIImage *)imageForFail;
- (UIImage *)imageForValue:(float)value;

@end
