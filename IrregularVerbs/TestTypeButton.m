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

@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation TestTypeButton

#define RIGHT_MARGIN 18.0
#define BADGET_INSET -4.0   

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *buttonImage = [[UIImage imageNamed:@"whiteButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        UIImage *buttonImageHighlight = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];

        [self setTitleColor:[UIColor lightGrayColor]    forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor]        forState:UIControlStateHighlighted];
        [self setBackgroundImage:buttonImage            forState:UIControlStateNormal];
        [self setBackgroundImage:buttonImageHighlight   forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"crayon"]   forState:UIControlStateNormal];

        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
        self.titleLabel.font = [UIFont fontWithName:@"Signika" size:18];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.badgeLabel.font = [UIFont fontWithName:@"Signika" size:12];
        self.badgeLabel.textColor = [UIColor lightGrayColor];
        self.badgeLabel.textAlignment = NSTextAlignmentCenter;
        self.badgeLabel.layer.cornerRadius = 3;
        self.badgeLabel.backgroundColor = [UIColor darkGrayColor];
        
        [self addSubview:self.badgeLabel];
    }
    return self;
}

- (void)setBadge:(NSString *)badge {
    self.badgeLabel.text = badge;
    [self.badgeLabel sizeToFit];
    self.badgeLabel.frame = CGRectInset(self.badgeLabel.frame,BADGET_INSET, 0);
    self.badgeLabel.frame = CGRectMake(self.bounds.size.width-self.badgeLabel.frame.size.width-RIGHT_MARGIN,
                                       0.5*(self.bounds.size.height-self.badgeLabel.frame.size.height),
                                       self.badgeLabel.frame.size.width, self.badgeLabel.frame.size.height);
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.badgeLabel.textColor = [UIColor whiteColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.badgeLabel.textColor = [UIColor lightGrayColor];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

@end
