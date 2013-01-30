//
//  PreferencesViewController.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 20/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import "PreferencesViewController.h"
#import "VerbsStore.h"
#import "ImgIndependentHelper.h"

@interface PreferencesViewController ()

@end

@implementation PreferencesViewController

#pragma mark - Load and store

- (void)viewWillAppear:(BOOL)animated {
    [self.aboutLabel setText:[NSString stringWithFormat:@"Version %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] ];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

-(void)viewDidLoad
{
    self.title = NSLocalizedString(@"SetupLabel", nil);
[[self view] insertSubview: [ImgIndependentHelper getBackgroundImageView] atIndex:0];
    UIImage *buttonImage = [[UIImage imageNamed:@"greyButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"greyButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];

    
    UIFont* fontButton = [UIFont fontWithName:@"Signika" size:18];
     
    
    [self.buttonClear setTitle:NSLocalizedString(@"clearbuttontitle", nil) forState:UIControlStateNormal];
    [self.buttonClear setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.buttonClear setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    self.buttonClear.titleLabel.font = fontButton;
    
    [self.buttonAbout setTitle:NSLocalizedString(@"aboutbuttontitle", nil) forState:UIControlStateNormal];
    [self.buttonAbout setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.buttonAbout setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    self.buttonAbout.titleLabel.font = fontButton;
}

- (IBAction)clearStatistics:(UIButton *)sender {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"clearhistorydata", nil)
                                                 message:NSLocalizedString(@"clearconsequence", nil)
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                       otherButtonTitles:NSLocalizedString(@"clearall", nil), nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [[VerbsStore sharedStore] resetHistory];
    }
}
 
-(IBAction)showAboutLink:(id)sender
{
    NSString *launchUrl= [[NSUserDefaults standardUserDefaults] stringForKey:@"aboutProjectURL"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

@end
