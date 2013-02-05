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
 
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
 
        backgroundImageView = [[UIImageView alloc] initWithImage:imgHomeviewbg568h];
        [backgroundImageView setFrame:CGRectMake(0, 0, 320, 504)];
    }
    else{
        
        backgroundImageView = [[UIImageView alloc] initWithImage:imgHomeviewbg];
        [backgroundImageView setFrame:CGRectMake(0, 0, 320, 416)];
    }
return backgroundImageView;
}

@end
