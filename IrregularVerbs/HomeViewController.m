//
//  NewHomeViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 21/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "HomeViewController.h"
#import "VerbsStore.h"
#import <QuartzCore/QuartzCore.h>
#import "CardsTableViewController.h"
#import "TestSelectorViewController.h"
#import "PreferencesViewController.h"
#import "HistoryViewController.h"
#import "VSRotatingView.h"
#import "ASDepthModalViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *labelPopUp;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIButton *buttonLearn;
@property (weak, nonatomic) IBOutlet UIButton *buttonTest;
@property (weak, nonatomic) IBOutlet UIButton *buttonHistory;
@property (weak, nonatomic) IBOutlet UIButton *buttonSetup;
@property (weak, nonatomic) IBOutlet UIButton *buttonClosePopUp;
 
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
     
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    VSRotatingView *rv = [VSRotatingView new];
    rv.rotatingViewDelegate = self;
    
    
    [rv setCurrentSegment:[[VerbsStore sharedStore] currentFrequencyByGroup]];
    
    [[self bottomView] addSubview:rv];
    
    self.popupView.layer.cornerRadius = 12;
    self.popupView.layer.shadowOpacity = 0.7;
    self.popupView.layer.shadowOffset = CGSizeMake(6, 6);
    self.popupView.layer.shouldRasterize = YES;
    self.popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [[self labelPopUp] setText:NSLocalizedString(@"InfoPopupHome", @"info about App at home")];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"whiteButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    // Set the background for any states you plan to use
    [[self.buttonLearn imageView] setContentMode: UIViewContentModeScaleAspectFit];
  
    [self.buttonLearn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.buttonLearn setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
  
     self.buttonLearn.layer.cornerRadius = 1;
    
    [self.buttonLearn setTitle:NSLocalizedString(@"LearnLabel", nil) forState:UIControlStateNormal];
    
    [[self.buttonTest imageView] setContentMode: UIViewContentModeScaleAspectFit];
 
    [self.buttonTest setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.buttonTest setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
   
    [self.buttonTest setTitle:NSLocalizedString(@"TestLabel", nil) forState:UIControlStateNormal];
    
    [[self.buttonHistory imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [self.buttonHistory setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.buttonHistory setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.buttonHistory setTitle:NSLocalizedString(@"HistoryLabel", nil) forState:UIControlStateNormal];
    
    [[self.buttonSetup imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [self.buttonSetup setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.buttonSetup setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.buttonSetup setTitle:NSLocalizedString(@"SetupLabel", nil) forState:UIControlStateNormal];
    
    [self.buttonClosePopUp setTitle:NSLocalizedString(@"close", nil) forState:UIControlStateNormal];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.title = NSLocalizedString(@"Home", @"Title for Home screen and back buttons");
  
    }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
 
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[self headLabel] setAttributedText:[self attributedHomeLabel]];
    //How strange! if you set textAlignment in UIBuilder it doesn't work
    self.headLabel.textAlignment = NSTextAlignmentCenter;
  
    //firs time? show popupview assistant
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firsTimeAssistantShown"]){
        [ASDepthModalViewController presentView:self.popupView withBackgroundColor:nil popupAnimationStyle:ASDepthModalAnimationShrink];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firsTimeAssistantShown"];
    }
}

-(NSAttributedString *) attributedHomeLabel{
    
    int cntVerbs = [[[VerbsStore sharedStore] alphabetic] count] ;
    NSString *str = [NSString stringWithFormat: NSLocalizedString(@"verbstolearn", @"home label descriptor"), cntVerbs];
    NSMutableAttributedString *result  = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSDictionary *attributesForNumber = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:20.0],NSForegroundColorAttributeName:TURQUESATINT};
    
        NSDictionary *attributesForTest = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:20.0],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
 
    [result setAttributes:attributesForNumber range: NSMakeRange(0,[[NSString stringWithFormat:@"%d",cntVerbs ] length])];
    [result setAttributes:attributesForTest   range: NSMakeRange([[NSString stringWithFormat:@"%d",cntVerbs ] length], ([result length] - [[NSString stringWithFormat:@"%d",cntVerbs ] length]))];
    
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

#pragma mark RotatingViewDelegateMethods

- (void)viewCirculatedToSegmentIndex:(NSUInteger)index
{
    float f = [[[[VerbsStore sharedStore] defaultFrequencyGroups] objectAtIndex:index] floatValue];
    [[VerbsStore sharedStore] setFrequency:f];
    [[self headLabel] setAttributedText:[self attributedHomeLabel]];
}



 

- (IBAction)showInfo:(id)sender {
        [ASDepthModalViewController presentView:self.popupView withBackgroundColor:nil popupAnimationStyle:ASDepthModalAnimationDisplace];
}
- (IBAction)openLearn:(id)sender {
    [[self navigationController] pushViewController:[[CardsTableViewController alloc] init]
                                           animated:YES];
}

- (IBAction)openTest:(id)sender {
    [[self navigationController] pushViewController:[[TestSelectorViewController alloc] init]
                                           animated:YES];
}

- (IBAction)openHistory:(id)sender {
       [[self navigationController] pushViewController:[[HistoryViewController alloc] init]  animated:YES];
}

- (IBAction)openSetup:(id)sender {
    [[self navigationController] pushViewController:[[PreferencesViewController alloc] init]
                                           animated:YES];
}

- (IBAction)closePopUp:(id)sender {
      [ASDepthModalViewController dismiss];
}
@end
