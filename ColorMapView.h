//
//  VerbsVisualMapView.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 02/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorMapView;

@protocol ColorMapViewDataSource <NSObject>

- (int)numberOfItemsInColorMapView:(ColorMapView *)colorMapView;
- (UIColor *)colorMapView:(ColorMapView *) colorMapView colorForItemAtIndex:(int)index;

@end

@interface ColorMapView : UIView

@property (nonatomic, weak) id<ColorMapViewDataSource> dataSource;
 
@end
