//
//  SectorDial.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 28/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "SectorDial.h"

@implementation SectorDial
@synthesize minValue, maxValue, midValue, sector;

- (NSString *) description {
    
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.sector, self.minValue, self.midValue, self.maxValue];
    
}
@end
