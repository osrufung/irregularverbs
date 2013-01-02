//
//  VerbsVisualMapView.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 02/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "VerbsVisualMapView.h"



@implementation VerbsVisualMapView

@synthesize numElements, elements;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        numElements = 0;
    }
    return self;
}

-(void) setNumElements:(int)ne{
    
    numElements = ne;
    elements =  [NSMutableArray arrayWithCapacity:numElements];
    [self clearElements];
    [self setNeedsDisplay];
}
-(void)clearElements{
    
    [elements removeAllObjects];
    for (int i=0;i< numElements;i++){
         [elements addObject:[NSNumber numberWithInt:0]];
    }
}

-(void)markElement:(int)el  seconds:(double) sec{
    if(el< [elements count])
    {
        
        NSLog(@"MArk element %d in Seconds %f", el,sec);
        
        elements[el] = [NSNumber numberWithInt:(int)sec+1];
         
        
       
    }
    [self setNeedsDisplay];
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bound = [self bounds];
    CGRect r1;
    
    r1.size.height = 12;
    r1.origin.x = 0;
    r1.origin.y = 0;
    
 
    
    if(numElements>0)
    {
        float size_per_element = bound.size.width / numElements;
        r1.size.width = size_per_element;
        for(int i=0;i<numElements;i++){
            
            NSNumber *state = elements[i]
            ;
            if([state intValue] == 0){
                [[UIColor lightGrayColor] setFill];
               
            }else if ([state intValue] < 3)
            {
                [[UIColor greenColor] setFill];
            }
            else if ([state intValue] < 5)
            {
                [[UIColor orangeColor] setFill];
            }
            else  
            {
                [[UIColor redColor] setFill];
            }
            CGContextAddRect(ctx, r1);
            CGContextFillPath(ctx);
            r1.origin.x += size_per_element;
        }
    
    }
}
 

@end
