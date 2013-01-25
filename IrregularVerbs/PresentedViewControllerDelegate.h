//
//  PresentedViewControllerDelegate.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 25/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PresentedViewControllerDelegate <NSObject>
- (void)presentedViewControllerWillDisapear:(UIViewController *)controller;
@end
