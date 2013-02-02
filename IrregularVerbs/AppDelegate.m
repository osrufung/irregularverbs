//
//  AppDelegate.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import "AppDelegate.h"
#import "VerbsStore.h" 
#import "HomeViewController.h"
#import "ColorsDefinition.h"


  
@implementation AppDelegate

 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //load default Settings
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[ UIScreen mainScreen]bounds]];
    
    //not frequency? default frequency for a minimal verbs 
    float frequency = [[NSUserDefaults standardUserDefaults] floatForKey:@"frequency"];
    
    if(frequency == 0.0){
        int defFreq = [[[[VerbsStore sharedStore] defaultFrequencyGroups]objectAtIndex:0] intValue];    
        [[NSUserDefaults standardUserDefaults] setFloat:defFreq forKey:@"frequency"];
    }
    
    [[UINavigationBar appearance] setTintColor:TURQUESA_TINT];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], UITextAttributeTextColor,
                                                           [UIColor colorWithWhite:0.000 alpha:0.090], UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"Signika" size:0.0], UITextAttributeFont,
                                                           nil]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIColor whiteColor], UITextAttributeTextColor,
                                                             [UIColor colorWithWhite:0.000 alpha:0.090], UITextAttributeTextShadowColor,
                                                             [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                             nil] forState:UIControlStateNormal];
    
    [[UIToolbar appearance] setTintColor:TURQUESA_TINT];
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [UIColor whiteColor], UITextAttributeTextColor,
                                                            [UIColor colorWithWhite:0.000 alpha:0.090], UITextAttributeTextShadowColor,
                                                            [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                            nil] forState:UIControlStateNormal];
    [[UISwitch appearance] setOnTintColor:TURQUESA_TINT];
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
  
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:hvc];
     
    [[self window] setRootViewController:nc];
    self.window.backgroundColor = [UIColor darkGrayColor];
    [self.window makeKeyAndVisible];
 
    return YES;
}
 
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL successSaveState = [[VerbsStore sharedStore] saveChanges];
    if(successSaveState){
        NSLog(@"Saved VerbStore State");
        
    }else{
        NSLog(@"Error saving VerbStore State");
    }
    
     
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[VerbsStore sharedStore] failedOrNotTestedVerbsCount];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
