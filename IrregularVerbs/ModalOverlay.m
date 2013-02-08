//
//  ModalImageOverlayViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 04/02/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "ModalOverlay.h"

@interface ModalOverlay ()

@property (strong, nonatomic) UIView *viewToShow;
@property (strong, nonatomic) UIViewController *rootViewController;
@property (strong, nonatomic) void(^completionBlock)(void);

@end

@implementation ModalOverlay

- (void)showView:(UIView *)view {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.rootViewController = window.rootViewController;
    self.rootViewController.view.frame = CGRectOffset(self.rootViewController.view.frame,
                                                      0,
                                                      -[[UIApplication sharedApplication] statusBarFrame].size.height);
    [self.view addSubview:self.rootViewController.view];
    window.rootViewController = self;
    
    self.viewToShow = view;
    self.viewToShow.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.viewToShow.frame = window.frame;
    DLog(@"%@",NSStringFromCGRect(window.frame));
    self.viewToShow.alpha = 0.0;
    [self.view addSubview:self.viewToShow];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = self.viewToShow.frame;
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    [UIView animateWithDuration:0.2 animations:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        self.viewToShow.alpha = 0.6;
    }];
}

- (void)dismiss {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if ([window.rootViewController isEqual:self]) {
        [UIView animateWithDuration:0.2 animations:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            self.viewToShow.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.rootViewController.view removeFromSuperview];
                window.rootViewController = self.rootViewController;
                self.completionBlock();
            }
        }];
    }
}

+ (void)showView:(UIView *)view completion:(void(^)(void))completionBlock; {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if ([window.rootViewController isKindOfClass:[ModalOverlay class]]) return;

    ModalOverlay * popup = [[ModalOverlay alloc] init];
    popup.completionBlock = completionBlock;
    [popup showView:view];
}

+ (void)showImage:(UIImage *)image completion:(void(^)(void))completionBlock; {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleToFill;
    DLog(@"%@",NSStringFromCGRect(imageView.frame));
    [self showView:imageView completion:completionBlock];
}

+ (void)showImageWithName:(NSString *)imageName completion:(void(^)(void))completionBlock; {
    UIImage *image = [UIImage imageNamed:imageName];
    [self showImage:image completion:completionBlock];
}

+ (void)dismiss {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if ([window.rootViewController isKindOfClass:[ModalOverlay class]]) {
        ModalOverlay *popup = (ModalOverlay *)window.rootViewController;
        [popup dismiss];
    }
}
@end
