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
#import "ASDepthModalViewController.h"
#import "LevelDialSelectorControl.h"
#import "ImgIndependentHelper.h"

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
@property (weak, nonatomic) IBOutlet UILabel *labelHeader;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
 
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
   
 
    [[self view] insertSubview: [ImgIndependentHelper getBackgroundImageView] atIndex:0];
 
    LevelDialSelectorControl *dial =  [[LevelDialSelectorControl alloc] initWithFrame:CGRectMake(0, 0, 320, 440) andDelegate:self withSections:3 initialSection:[[VerbsStore sharedStore] currentFrequencyByGroup]];
    
    [[self bottomView] addSubview:dial];
    
    self.popupView.layer.cornerRadius = 4;
    self.popupView.layer.shadowOpacity = 0.3;
    self.popupView.layer.shadowOffset = CGSizeMake(10, 10   );
    self.popupView.layer.shouldRasterize = YES;
    self.popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [[self labelPopUp] setText:NSLocalizedString(@"InfoPopupHome", @"info about App at home")];

    UIFont* fontButton = [UIFont fontWithName:@"Signika" size:18];
    
    // Set the background for any states you plan to use
    [[self.buttonLearn imageView] setContentMode: UIViewContentModeScaleAspectFit];
 
    [self.buttonLearn setTitle:NSLocalizedString(@"LearnLabel", nil) forState:UIControlStateNormal];
    self.buttonLearn.titleLabel.font = fontButton;
    
    [[self.buttonTest imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [self.buttonTest setTitle:NSLocalizedString(@"TestLabel", nil) forState:UIControlStateNormal];
    self.buttonTest.titleLabel.font = fontButton;
    
    [[self.buttonHistory imageView] setContentMode: UIViewContentModeScaleAspectFit];

    [self.buttonHistory setTitle:NSLocalizedString(@"HistoryLabel", nil) forState:UIControlStateNormal];
    self.buttonHistory.titleLabel.font = fontButton;
    
    [[self.buttonSetup imageView] setContentMode: UIViewContentModeScaleAspectFit];

    [self.buttonSetup setTitle:NSLocalizedString(@"SetupLabel", nil) forState:UIControlStateNormal];
    self.buttonSetup.titleLabel.font = fontButton;
    
    [self.buttonClosePopUp setTitle:NSLocalizedString(@"close", nil) forState:UIControlStateNormal];

    //We can change this system button for a custom button with a look more integrated
    //
 
    //[button addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:[self infoButton]];
    
    // labelHeader is isolated in the XIB, it will be better to construct it with code
    [self.labelHeader setAttributedText:[self attributedNavLabel]];
    [self.labelHeader setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.labelHeader;
    self.navigationItem.rightBarButtonItem = rightButton;
    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [hideButton setHidden:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hideButton];
    self.title = NSLocalizedString(@"Home", @"Title for Home screen and back buttons");
  
    }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
 
    [[self headLabel] setAttributedText:[self attributedHomeLabel]];
    //How strange! if you set textAlignment in UIBuilder it doesn't work
    self.headLabel.textAlignment = NSTextAlignmentCenter;
  
    //firs time? show popupview assistant
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firsTimeAssistantShown"]){
        [ASDepthModalViewController presentView:self.popupView withBackgroundColor:nil popupAnimationStyle:ASDepthModalAnimationShrink];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firsTimeAssistantShown"];
    }
}
-(NSAttributedString *) attributedNavLabel{
    UIFont* fontLight = [UIFont fontWithName:@"Signika-Light" size:24];    
    UIFont* fontBold= [UIFont fontWithName:@"Signika-Bold" size:24];
    NSString *str1 = @"a list of";
    NSString *str2 = @" Verbs";
    
    NSMutableAttributedString *result  = [[NSMutableAttributedString alloc] initWithString:[str1 stringByAppendingString:str2]];
    
    NSDictionary *attributesForLight = @{NSFontAttributeName:fontLight,NSForegroundColorAttributeName:[UIColor whiteColor] };
    
    NSDictionary *attributesForBold = @{NSFontAttributeName:fontBold,NSForegroundColorAttributeName:[UIColor whiteColor]};

    
    [result setAttributes:attributesForLight range:NSMakeRange(0, [str1 length])];
    [result setAttributes:attributesForBold range:NSMakeRange([str1 length], [str2 length])];
    
    return [[NSAttributedString alloc] initWithAttributedString:result];;
   
}
-(NSAttributedString *) attributedHomeLabel{
 
    UIFont* fontBold = [UIFont fontWithName:@"Signika-Bold" size:20];
  
    UIFont* fontRegular = [UIFont fontWithName:@"Signika" size:20];
    
    int cntVerbs = [[[VerbsStore sharedStore] alphabetic] count] ;
    NSString *str = [NSString stringWithFormat: NSLocalizedString(@"verbstolearn", @"home label descriptor"), cntVerbs];
    NSMutableAttributedString *result  = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSDictionary *attributesForNumber = @{NSFontAttributeName:fontBold,NSForegroundColorAttributeName:TURQUESATINT};
    
        NSDictionary *attributesForTest = @{NSFontAttributeName:fontRegular,NSForegroundColorAttributeName:[UIColor darkGrayColor]};
 
    [result setAttributes:attributesForNumber range: NSMakeRange(0,[[NSString stringWithFormat:@"%d",cntVerbs ] length])];
    [result setAttributes:attributesForTest   range: NSMakeRange([[NSString stringWithFormat:@"%d",cntVerbs ] length], ([result length] - [[NSString stringWithFormat:@"%d",cntVerbs ] length]))];
    
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

#pragma mark LevelDialSelectorProtocol
- (void) dialDidChangeValue:(int)newValue{
    float f = [[[[VerbsStore sharedStore] defaultFrequencyGroups] objectAtIndex:newValue] floatValue];
    [[VerbsStore sharedStore] setFrequency:f];
    [[self headLabel] setAttributedText:[self attributedHomeLabel]];
}


 

- (IBAction)showInfo:(id)sender {
        [ASDepthModalViewController presentView:self.popupView withBackgroundColor:[UIColor whiteColor] popupAnimationStyle:ASDepthModalAnimationGrow];
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
