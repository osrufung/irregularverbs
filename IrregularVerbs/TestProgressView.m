//
//  TestProgressView.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 07/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "TestProgressView.h"

@implementation TestProgressView

@synthesize backgroundColor=_backgroundColor, progress=_progress;

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor=backgroundColor;
    [self setNeedsDisplay];
}

- (void)setProgress:(float)progres {
    _progress=progres;
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];    
}


- (void)drawRect:(CGRect)rect
{
    CGRect proRect = CGRectInset(self.bounds, 2, 2);
    proRect.size.width *= self.progress;

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.backgroundColor setFill];
    CGContextFillRect(ctx,proRect);
}

@end
