//
//  UIColor+IrregularVerbs.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 01/02/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "UIColor+IrregularVerbs.h"

@implementation UIColor (IrregularVerbs)

+ (UIColor *)appTintColor {
    return [UIColor colorWithRed:0.0/255.0 green:218.0/255.0 blue:194.0/255.0 alpha:1.0];
}

+ (UIColor *)passColor {
    return [UIColor appTintColor];
}

+ (UIColor *)failColor {
    return [UIColor colorWithRed:230.0/255 green:68.0/255 blue:97.0/255 alpha:1.0];
}

+ (UIColor *)midleColor {
    return [UIColor orangeColor];
}


@end
