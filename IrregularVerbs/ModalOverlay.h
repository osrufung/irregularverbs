//
//  ModalImageOverlayViewController.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 04/02/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalOverlay : UIViewController

+ (void)showView:(UIView *)view completion:(void(^)(void))completionBlock;
+ (void)showImage:(UIImage *)image completion:(void(^)(void))completionBlock;
+ (void)showImageWithName:(NSString *)imageName completion:(void(^)(void))completionBlock;
+ (void)dismiss;

@end
