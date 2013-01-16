//
//  CounterCell.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 16/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "CounterCell.h"

@implementation CounterCell
{
    NSObject * _target;
    SEL _action;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setMaximumValue:(int)maximumValue {
    self.stepperCount.maximumValue=maximumValue;
}

- (void)setMinimumValue:(int)minimumValue {
    self.stepperCount.minimumValue=minimumValue;
}

- (int)minimumValue {
    return self.stepperCount.minimumValue;
}

- (int)maximumValue {
    return self.stepperCount.maximumValue;
}

- (void)setValue:(int)value {
    self.stepperCount.value=value;
    self.labelCount.text = [NSString stringWithFormat:@"Use %d of %d",value,(int)self.stepperCount.maximumValue];
}

- (int)value {
    return self.stepperCount.value;
}

- (IBAction)stepperChanged:(UIStepper *)sender {
    self.value = self.stepperCount.value;
    if ([_target respondsToSelector:_action]  ) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
    }
}

- (void)addTarget:(NSObject *)target action:(SEL)action {
    _target=target;
    _action=action;
}

@end
