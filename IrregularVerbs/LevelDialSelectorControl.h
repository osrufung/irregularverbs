//
//  LevelDialSelectorControl.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 28/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectorDial.h"


@protocol LevelDialSelectorProtocol <NSObject>

- (void) dialDidChangeValue:(int)newValue;

@end

@interface LevelDialSelectorControl : UIControl

@property (weak) id <LevelDialSelectorProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sectors;
@property int currentSector;
- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber initialSection:(int) initSection;
@end

