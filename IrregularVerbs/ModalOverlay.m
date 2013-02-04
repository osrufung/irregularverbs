//
//  ModalImageOverlayViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 04/02/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "ModalOverlay.h"

@interface ModalOverlay ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UIViewController *rootViewController;
@property (strong, nonatomic) void(^completionBlock)(void);

@end

@implementation ModalOverlay

- (void)showImage:(NSString *)imageName {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.rootViewController = window.rootViewController;
    self.rootViewController.view.frame = CGRectOffset(self.rootViewController.view.frame,
                                                      0,
                                                      -[[UIApplication sharedApplication] statusBarFrame].size.height);
    [self.view addSubview:self.rootViewController.view];
    window.rootViewController = self;
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.imageView.frame = window.frame;
    self.imageView.alpha = 0.0;
    [self.view addSubview:self.imageView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = self.imageView.frame;
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.alpha = 0.5;
    }];
}

- (void)dismiss {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if ([window.rootViewController isEqual:self]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.rootViewController.view removeFromSuperview];
                window.rootViewController = self.rootViewController;
                self.completionBlock();
            }
        }];
    }
}


+ (void)showImage:(NSString *)imageName completion:(void(^)(void))completionBlock; {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if ([window.rootViewController isKindOfClass:[ModalOverlay class]]) return;
    
    ModalOverlay * popup = [[ModalOverlay alloc] init];
    popup.completionBlock = completionBlock;
    [popup showImage:imageName];
}

+ (void)dismiss {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if ([window.rootViewController isKindOfClass:[ModalOverlay class]]) {
        ModalOverlay *popup = (ModalOverlay *)window.rootViewController;
        [popup dismiss];
    }
}
@end
