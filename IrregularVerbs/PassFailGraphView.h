//
//  CompositionGraphView.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 17/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassFailGraphView : UIView

@property (nonatomic, copy) NSArray *colors;

- (void)setDataCount:(int)total withPassCount:(int)pass andFailCount:(int)fail;

@end
