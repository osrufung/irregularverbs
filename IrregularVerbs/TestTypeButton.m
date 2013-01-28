//
//  TestTypeButton.m
//  IrregularVerbs
//
//  Created by Rafa Barberá on 27/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "TestTypeButton.h"
#import <QuartzCore/QuartzCore.h>

@interface TestTypeButton()

@end

@implementation TestTypeButton

#define RIGHT_MARGIN    18.0
#define BADGET_PADDING   4.0

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                
        UIImage *buttonImage = [[UIImage imageNamed:@"homeButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                                resizingMode:UIImageResizingModeStretch];
        UIImage *buttonImageHighlight = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                                         resizingMode:UIImageResizingModeStretch];

        [self setTitleColor:[UIColor lightGrayColor]    forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor]        forState:UIControlStateHighlighted];
        [self setBackgroundImage:buttonImage            forState:UIControlStateNormal];
        [self setBackgroundImage:buttonImageHighlight   forState:UIControlStateHighlighted];

        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setImage:[UIImage imageNamed:@"iconEvaluar"]   forState:UIControlStateNormal];

        self.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.detailLabel.textColor = [UIColor whiteColor];
        self.detailLabel.textAlignment = NSTextAlignmentCenter;

        /*
         * To improve performance with cornerRadius:
         *  - background = clear && maskToBounds = NO
         *  - layer.background = color
         *  - shouldRasterize = NO && scale to mainScreen scale (for retina)
         *
         * http://stackoverflow.com/questions/4735623/uilabel-layer-cornerradius-negatively-impacting-performance
         */
        self.opaque = YES;
        self.detailLabel.opaque = YES;
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        self.detailLabel.layer.cornerRadius = 3;
        self.detailLabel.layer.masksToBounds = NO;
        self.detailLabel.layer.shouldRasterize = YES;
        self.detailLabel.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        [self.detailLabel addObserver:self
                           forKeyPath:@"text"
                              options:NSKeyValueObservingOptionNew
                              context:NULL];
        
        [self.detailLabel addObserver:self
                           forKeyPath:@"font"
                              options:NSKeyValueObservingOptionNew
                              context:NULL];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)dealloc {
    [self.detailLabel removeObserver:self forKeyPath:@"text"];
    [self.detailLabel removeObserver:self forKeyPath:@"font"];
}

- (void)computeBadgeFrame {
    CGSize detailSize = [self.detailLabel.text sizeWithFont:self.detailLabel.font];
    detailSize.width += BADGET_PADDING;
    if (detailSize.width==self.detailLabel.frame.size.width) return;
    
    self.detailLabel.frame = CGRectMake(self.bounds.size.width-detailSize.width-RIGHT_MARGIN,
                                       0.5*(self.bounds.size.height-detailSize.height),
                                       detailSize.width, detailSize.height);
    [self setNeedsDisplay];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ((object == self.detailLabel) &&
        (([keyPath isEqualToString:@"text"])||([keyPath isEqualToString:@"font"]))) {
        [self computeBadgeFrame];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.detailLabel.textColor = [UIColor lightGrayColor];
    self.detailLabel.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

@end
