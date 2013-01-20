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
#import "UILabel+FrameExpand.h"
#import "HintsCell.h"

@interface HintsTableDelegate()

@property (nonatomic, strong) NSMutableArray * indexedData;
@property (nonatomic, strong) NSMutableArray * indexEntries;

@end

@implementation HintsTableDelegate

- (void)makeHintsIndex {
    _indexedData = [[NSMutableArray alloc] init];
    _indexEntries = [[NSMutableArray alloc] init];
    int currentHint = -1;

    NSArray *array = [[[VerbsStore sharedStore] alphabetic] sortedArrayUsingSelector:@selector(compareVerbsByHint:)];
    NSMutableArray *currentSection = nil;
    for (Verb * verb in array) {
        if (verb.hint!=currentHint) {
            currentHint = verb.hint;
            currentSection = [[NSMutableArray alloc] init];
            [_indexEntries addObject:[[VerbsStore alloc] hintForGroupIndex:currentHint]];
            [_indexedData addObject:currentSection];
        }
        [currentSection addObject:verb];
    }

}

- (NSMutableArray *)indexedData {
    if (!_indexedData) {
        [self makeHintsIndex];
    }
    return _indexedData;
}

- (NSMutableArray *)indexEntries {
    if (!_indexEntries) {
        [self makeHintsIndex];
    }
    return _indexEntries;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexedData.count;
}

- (UIView *)headerViewWithText:(NSString *)text {
    int currHeight = 10;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, currHeight, 300, 44)];
    lab.text = text;
    lab.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0f];
    lab.numberOfLines=0;
    lab.backgroundColor = [UIColor clearColor];
    [lab sizeToFitText];
    currHeight += lab.frame.size.height+4;

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
    currHeight += 25;

    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(10,currHeight,300, 1)];
    foot.backgroundColor = [UIColor lightGrayColor];
    currHeight +=4;

    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, currHeight)];
    back.backgroundColor = [UIColor whiteColor];
    [back addSubview:lab];
    [back addSubview:pass];
    [back addSubview:simple];
    [back addSubview:participle];
    [back addSubview:foot];
    return back;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self headerViewWithText:self.indexEntries[section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UIView *v = [self tableView:tableView viewForHeaderInSection:section];
    return v.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static CGFloat hintHeigth = 0;
    if (!hintHeigth) {
        HintsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HintsCell"];
        hintHeigth = cell.frame.size.height;
    }
    return hintHeigth;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.indexedData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Verb *v;
    
    v = self.indexedData[indexPath.section][indexPath.row];
    
    HintsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HintsCell" forIndexPath:indexPath];
    cell.labelSimple.text = v.simple;
    cell.labelPass.text = v.past;
    cell.labelParticiple.text = v.participle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

@end
