//
//  VerbsVisualMapView.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 02/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerbsVisualMapView : UIView
 
@property (nonatomic) int numElements;
@property (nonatomic) NSMutableArray *elements;
//@todo state should be a DEFINED CONSTANT VALUE
-(void)markElement:(int)element seconds:(double) sec;
@end
