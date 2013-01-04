//
//  VerbsVisualMapView.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 02/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "ColorMapView.h"



@implementation ColorMapView
{
    int _nw;
    int _nh;
    int _side;
}

- (void)awakeFromNib {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(toggleSize:)];
    doubleTap.numberOfTapsRequired=2;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(itemSelected:)];
    singleTap.numberOfTapsRequired=1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [self addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:singleTap];
}

- (void)itemSelected:(UIGestureRecognizer *)tap {
    CGPoint tapPoint = [tap locationInView:self];
    NSLog(@"[%f,%f]",tapPoint.x,tapPoint.y);
    int index = tapPoint.x/_side + (int)(tapPoint.y/_side)*_nw;
    [self.delegate colorMapView:self selectedItemAtIndex:index];
}

#define COMPRESED_SIZE 12
#define INSET_SIZE 20
#define GUTTER_WIDTH 4

- (void)toggleSize:(UIGestureRecognizer *)tap {
    CGRect newFrame;
    CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];
    if (self.frame.size.height==COMPRESED_SIZE) {
        newFrame = CGRectInset(mainScreenFrame, INSET_SIZE, INSET_SIZE);
        int nItems = [self.dataSource numberOfItemsInColorMapView:self];
        if (nItems>0) {
            _nw = (int)ceil(sqrt(newFrame.size.width*nItems/newFrame.size.height));
            _nh = (int)ceil(nItems/(float)_nw);
            _side = MIN(newFrame.size.width/_nw,newFrame.size.height/_nh);
            CGSize fittedSize = CGSizeMake(_nw*_side+GUTTER_WIDTH, _nh*_side+GUTTER_WIDTH);
            newFrame = CGRectMake(newFrame.origin.x+(newFrame.size.width-fittedSize.width)/2.0,
                                  newFrame.origin.y+(newFrame.size.height-fittedSize.height)/2.0,
                                  fittedSize.width, fittedSize.height);
        }
        
    } else {
        newFrame = CGRectMake(0, mainScreenFrame.size.height-COMPRESED_SIZE, mainScreenFrame.size.width, COMPRESED_SIZE);
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.frame = newFrame;
    [UIView commitAnimations];
    [self setNeedsDisplay];
}

- (void)drawStrip {
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

- (void)drawMatrix {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bound = [self bounds];
    
    int nItems = [self.dataSource numberOfItemsInColorMapView:self];
    if(nItems>0)
    {
        CGPoint org = CGPointMake((bound.size.width-_nw*_side)/2.0, (bound.size.height-_nh*_side)/2.0);
        int currentElement=0;
        for(int y=0;y<_nh;y++)
            for (int x=0;x<_nw;x++) {
                if (currentElement<nItems) {
                    [[self.dataSource colorMapView:self colorForItemAtIndex:currentElement] setFill];
                    [[UIColor lightTextColor] setStroke];
                    CGRect r1 = CGRectMake(org.x+x*_side+GUTTER_WIDTH/2.0,
                                           org.y+y*_side+GUTTER_WIDTH/2.0,
                                           _side-GUTTER_WIDTH, _side-GUTTER_WIDTH);
                    CGContextStrokeRect(ctx, r1);
                    CGContextFillRect(ctx, r1);
                    currentElement++;
                }
            }
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.bounds.size.height == COMPRESED_SIZE) {
        [self drawStrip];
    } else {
        [self drawMatrix];
    }
}
 

@end
