//
//  UILabel+FrameExpand.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "UILabel+FrameExpand.h"

@implementation UILabel (FrameExpand)

- (void)sizeToFitText {
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT) lineBreakMode:self.lineBreakMode];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
}

@end
