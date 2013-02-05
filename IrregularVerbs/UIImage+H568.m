//
//  UIImage+H568.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 05/02/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "UIImage+H568.h"

@implementation UIImage (H568)

+ (UIImage *)imageForDeviceHeightWithName:(NSString *)imageName {
    NSMutableString *imageNameWithHeight = [imageName mutableCopy];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {        
        //Delete png extension
        NSRange extension = [imageName rangeOfString:@".png" options:NSBackwardsSearch | NSAnchoredSearch];
        if (extension.location != NSNotFound) {
            [imageNameWithHeight deleteCharactersInRange:extension];
        }
        //Look for @2x to introduce -568h string
        NSRange retinaAtSymbol = [imageName rangeOfString:@"@2x"];
        if (retinaAtSymbol.location != NSNotFound) {
            [imageNameWithHeight insertString:@"-568h" atIndex:retinaAtSymbol.location];
        } else {
            [imageNameWithHeight appendString:@"-568h@2x"];
        }
    }
    
    return [UIImage imageNamed:imageNameWithHeight];
}

@end
