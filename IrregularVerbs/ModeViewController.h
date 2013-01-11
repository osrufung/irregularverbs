//
//  ModeViewController.h
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 08/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerbsStore;

@interface ModeViewController : UITabBarController<UITabBarControllerDelegate>
{
    NSArray *_verbs;
}

@end
