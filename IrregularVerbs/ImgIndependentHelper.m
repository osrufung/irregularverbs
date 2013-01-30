//
//  ImgIndependentHelper.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio Fung on 29/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "ImgIndependentHelper.h"

@implementation ImgIndependentHelper

+(UIImageView *)getBackgroundImageView{
       UIImageView *backgroundImageView;
    UIImage *backgroundImage;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        backgroundImage = [UIImage imageNamed:@"HomeViewbg-568h@2x"];
        backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [backgroundImageView setFrame:CGRectMake(0, 0, 320, 504)];
    }
    else{
        backgroundImage = [UIImage imageNamed:@"HomeViewbg"];
        backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [backgroundImageView setFrame:CGRectMake(0, 0, 320, 416)];
    }
return backgroundImageView;
}
@end
