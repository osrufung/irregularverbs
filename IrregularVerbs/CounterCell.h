//
//  CounterCell.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 16/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CounterCell : UITableViewCell

@property (nonatomic) int minimumValue;
@property (nonatomic) int maximumValue;
@property (nonatomic) int value;

@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UIStepper *stepperCount;

- (IBAction)stepperChanged:(UIStepper *)sender;
- (void)addTarget:(id)target action:(SEL)action;

@end
