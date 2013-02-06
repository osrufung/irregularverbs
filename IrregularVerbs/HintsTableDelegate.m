//
//  HintsTableDelegate.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 20/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "HintsTableDelegate.h"
#import "Verb.h"
#import "VerbsStore.h"
#import "UIColor+Saturation.h"
#import "HintsCell.h"

@interface HintsTableDelegate()

@property (nonatomic, strong) NSMutableArray *flatDataSet;

@end

@implementation HintsTableDelegate

- (void)populateWithVerbsInArray:(NSArray *)verbs {
    _flatDataSet = [[NSMutableArray alloc] initWithCapacity:verbs.count];
    int currentHint = -1;
    for (Verb *verb in verbs) {
        if (verb.hint!=currentHint) {
            currentHint = verb.hint;
            [_flatDataSet addObject:[[VerbsStore alloc] hintForGroupIndex:currentHint]];
        }
        [_flatDataSet addObject:verb];
    }
}

- (NSArray *)flatDataSet {
    if (!_flatDataSet) {
        NSArray *verbs = [[[VerbsStore sharedStore] alphabetic] sortedArrayUsingSelector:@selector(compareVerbsByHint:)];
        [self populateWithVerbsInArray:verbs];
    }
    return _flatDataSet;
}


- (UIView *)headerViewWithText:(NSString *)text {
    int currHeight = 14;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(18, currHeight, 284, 44)];
    lab.text = text;
    lab.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0f];
    lab.numberOfLines=0;
    lab.backgroundColor = [UIColor clearColor];
    CGSize newSize = [lab sizeThatFits:CGSizeMake(lab.bounds.size.width, CGFLOAT_MAX)];
    lab.frame = CGRectMake(lab.frame.origin.x, lab.frame.origin.y, lab.frame.size.width, newSize.height);
    currHeight += lab.frame.size.height+2;

    UILabel *simple = [[UILabel alloc] initWithFrame:CGRectMake(10, currHeight, 98, 21)];
    simple.text = @"Present";
    simple.textAlignment = NSTextAlignmentCenter;
    simple.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    simple.backgroundColor = [UIColor clearColor];

    UILabel *pass = [[UILabel alloc] initWithFrame:CGRectMake(110, currHeight, 98, 21)];
    pass.text = @"Pass";
    pass.textAlignment = NSTextAlignmentCenter;
    pass.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    pass.backgroundColor = [UIColor clearColor];

    UILabel *participle = [[UILabel alloc] initWithFrame:CGRectMake(210, currHeight, 98, 21)];
    participle.text = @"Participle";
    participle.textAlignment = NSTextAlignmentCenter;
    participle.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    participle.backgroundColor = [UIColor clearColor];
    currHeight += simple.frame.size.height+2;

    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(10,currHeight,300, 1)];
    foot.backgroundColor = [UIColor lightGrayColor];
    currHeight += foot.frame.size.height+2;

    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, currHeight)];
    back.backgroundColor = [UIColor clearColor];
    [back addSubview:lab];
    [back addSubview:pass];
    [back addSubview:simple];
    [back addSubview:participle];
    [back addSubview:foot];
    return back;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static CGFloat verbCellHeight = 0;
    id item = self.flatDataSet[indexPath.row];

    if ([item isKindOfClass:[NSString class]]) {
        UIView *cellView = [self headerViewWithText:item];
        return cellView.frame.size.height;
    }
    if ([item isKindOfClass:[Verb class]]) {
        if (verbCellHeight==0) {
            HintsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HintsCell"];
            verbCellHeight = cell.frame.size.height;
        }
        return verbCellHeight;
    }
    return 44.0f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.flatDataSet.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.flatDataSet[indexPath.row];
    
    if ([item isKindOfClass:[Verb class] ]) {
        Verb *v = item;
        HintsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HintsCell" forIndexPath:indexPath];
        cell.labelSimple.text = v.simple;
        cell.labelPass.text = v.past;
        cell.labelParticiple.text = v.participle;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([item isKindOfClass:[NSString class]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeaderCell"];
        }
        cell.accessoryView = [self headerViewWithText:item];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

@end
