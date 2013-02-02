//
//  CompositionGraphView.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 17/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "PassFailGraphView.h"
#import "UIColor+Saturation.h"
#import "UIColor+IrregularVerbs.h"

@interface PassFailGraphView()
@property (nonatomic) int total;
@property (nonatomic) int pass;
@property (nonatomic) int fail;
@end

@implementation PassFailGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.colors = @[[UIColor passColor],[UIColor failColor]];
    }
    return self;
}

- (void)awakeFromNib {
    self.colors =@[[UIColor passColor],[UIColor failColor]];
}

- (void)setDataCount:(int)total withPassCount:(int)pass andFailCount:(int)fail {
    self.total=total;
    self.pass=pass;
    self.fail=fail;
    [self setNeedsDisplay];
}

- (void)setColorsSaturation:(CGFloat)saturation {
    NSMutableArray *satCol = [[NSMutableArray alloc] initWithCapacity:self.colors.count];
    for (UIColor *col in self.colors) {
        [satCol addObject:[col colorWithSaturation:saturation]];
    }
    self.colors = satCol;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.backgroundColor setFill];
    CGContextFillRect(ctx, self.bounds);
    if (self.total>0) {
        CGFloat scale = self.bounds.size.width/self.total;
        float lengFail = (float)self.fail*scale;
        float lengPass = (float)self.pass*scale;
        
        [self.colors[0] setFill];
        CGContextFillRect(ctx, CGRectMake(0, 0, lengPass, self.bounds.size.height));
        [self.colors[1] setFill];
        CGContextFillRect(ctx, CGRectMake(lengPass, 0, lengFail, self.bounds.size.height));
    }
}

@end
