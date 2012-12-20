//
//  ViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IrregularVerb.h"

@interface ViewController : UIViewController

//array mutable donde guardar las entradas de los verbos
@property (nonatomic, strong) IrregularVerb *verbs;
//verbo actual
@property int current_Pos;
//outlets para las etiquetas
@property (nonatomic, strong) IBOutlet UILabel *labelPresent;
@property (nonatomic, strong) IBOutlet UILabel *labelPast;
@property (nonatomic, strong) IBOutlet UILabel *labelParticiple;
@property (nonatomic, strong) IBOutlet UILabel *labelTranslation;
@property (weak, nonatomic) IBOutlet UIImageView *shuffleIndicator;

@end
