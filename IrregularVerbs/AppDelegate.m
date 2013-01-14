//
//  AppDelegate.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 19/12/12.
//  Copyright (c) 2012 Oswaldo Rubio. All rights reserved.
//

#import "AppDelegate.h"
#import "VerbsStore.h"
#import "CardsTableViewController.h"

@implementation AppDelegate

//#define TESTING_NEW_TABLE_VC

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
#ifdef TESTING_NEW_TABLE_VC
    self.window = [[UIWindow alloc] initWithFrame:[[ UIScreen mainScreen]bounds]];
    CardsTableViewController *tmvc = [[CardsTableViewController alloc] init];
    [[self window] setRootViewController:tmvc];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
        
#endif
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
    
    
    //update Badge Icon when App exit (NOTE: I'm not sure about this. Maybe the previous Model "IrregularVerbs" is needed for this kind of things?)
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPendingOrFailed == %d",TRUE];
    
    NSArray *pendingVerbs = [[[VerbsStore sharedStore] alphabetic] filteredArrayUsingPredicate:predicate];
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [pendingVerbs count];
    
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
