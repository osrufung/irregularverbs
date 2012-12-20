//
//  ViewController.h
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//Mutable array of verbs
@property (nonatomic, strong) NSMutableArray *verbs;
//current verb (randomnly selected)
@property int current_Pos;
//current show state(0 = present, 1 = past, 2 = participle)
@property int current_State;
//outlets for labels
@property (nonatomic, weak) IBOutlet UILabel *labelPresent;
@property (nonatomic, weak) IBOutlet UILabel *labelPast;
@property (nonatomic, weak) IBOutlet UILabel *labelParticiple;
@property (nonatomic, weak) IBOutlet UILabel *labelTranslation;
//button tapped event
- (IBAction)screenTapped:(id)sender;
//logic method
- (void)showRandomVerb:(UISwipeGestureRecognizer *)sender;
@end
