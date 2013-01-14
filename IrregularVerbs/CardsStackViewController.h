//
//  CardsStackViewController.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 07/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
 
#import "CardViewController.h"

@interface CardsStackViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic) enum CardViewControllerPresentationMode presentationMode;

@end
