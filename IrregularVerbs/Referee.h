//
//  Referee.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 08/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Referee : NSObject

+ (Referee *)sharedReferee;

- (float)performanceForValue:(float)value;
- (UIColor *)colorForValue:(float)value;
- (UIImage *)failedImage;
- (UIImage *)checkedImageForValue:(float)value;

@end
