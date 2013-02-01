//
//  TSCSummaryCell.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 17/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "TSCSummaryCell.h"

@implementation TSCSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //NO! a Custom cell never will be started with initWithStyle. You must use awakeFromNib  or modify from the view controller (osrufung) 
        // http://stackoverflow.com/questions/12710235/custom-uitableviewcell-init
        //[[self labelTitle] setText:NSLocalizedString(@"scoreboard", nil)];

    }
    return self;
}
 
-(void)awakeFromNib{
    [super awakeFromNib];
    [[self labelTitle] setText:NSLocalizedString(@"scoreboard", nil)];
}
 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
