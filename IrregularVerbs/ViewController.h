//
//  ViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    CGPoint posPresent;
    CGPoint posTranslation;
}
//array mutable donde guardar las entradas de los verbos
@property (nonatomic, strong) NSMutableArray *verbs;
//verbo actual
@property int current_Pos;
//outlets para las etiquetas
@property (nonatomic, strong) IBOutlet UILabel *labelPresent;
@property (nonatomic, strong) IBOutlet UILabel *labelPast;
@property (nonatomic, strong) IBOutlet UILabel *labelParticiple;
@property (nonatomic, strong) IBOutlet UILabel *labelTranslation;

- (IBAction)showVerbalForms:(id)sender;
- (IBAction)showRandomVerb:(id)sender;
@end
