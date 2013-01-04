//
//  VerbsVisualMapView.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 02/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "ColorMapView.h"



@implementation ColorMapView

- (void)awakeFromNib {
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect r1;
    r1.size.height = self.bounds.size.height;
    r1.origin.x = 0;
    r1.origin.y = 0;
    
    int nItems = [self.dataSource numberOfItemsInColorMapView:self];
    if (nItems>0) {
        float itemWidth = self.bounds.size.width/nItems;
        r1.size.width = itemWidth;
        for (int i=0; i<nItems; i++) {
            [[self.dataSource colorMapView:self colorForItemAtIndex:i] setFill];
            CGContextAddRect(ctx, r1);
            CGContextFillPath(ctx);
            r1.origin.x += itemWidth;
        }
    }
}
 

@end
