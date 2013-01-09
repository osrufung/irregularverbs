//
//  CardsStackViewController.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 07/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerbsStore.h"
 
#import "CardViewController.h"
#import "PreferencesViewController.h"

@interface CardsStackViewController : UIPageViewController <VerbsStoreDelegate,UIPageViewControllerDataSource, UIPageViewControllerDelegate,PreferencesViewControllerDelegate>

@property (nonatomic) enum CardViewControllerPresentationMode presentationMode;


@end
