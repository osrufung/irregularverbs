//
//  UIColor+Saturation.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 18/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "UIColor+Saturation.h"

@implementation UIColor (Saturation)

- (UIColor *) colorWithSaturation:(CGFloat)saturation {
    CGFloat h,b,s,a;
    
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return [UIColor colorWithHue:h saturation:saturation brightness:b alpha:a];
}

@end
