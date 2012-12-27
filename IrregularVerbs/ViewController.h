//
//  ViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IrregularVerb.h"
#import "PreferencesViewController.h"

@interface ViewController : UIViewController <PreferencesViewControllerDelegate, IrregularVerbDelegate>

//array mutable donde guardar las entradas de los verbos
@property (nonatomic, strong) IrregularVerb *verbs;
//verbo actual
@property int current_Pos;
//outlets para las etiquetas
@property (nonatomic, weak) IBOutlet UILabel *labelPresent;
@property (nonatomic, weak) IBOutlet UILabel *labelPast;
@property (nonatomic, weak) IBOutlet UILabel *labelParticiple;
@property (nonatomic, weak) IBOutlet UILabel *labelTranslation;
@property (weak, nonatomic) IBOutlet UIImageView *shuffleIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
