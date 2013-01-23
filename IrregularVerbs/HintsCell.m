//
//  HintsCell.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "HintsCell.h"

@implementation HintsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
