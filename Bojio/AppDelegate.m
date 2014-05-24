//
//  AppDelegate.m
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // to get currently login user id
    // [[PFUser currentUser] objectId]

    [Parse setApplicationId:@"Yi325bn8AIUm3a6BkE02BAzfOvjjVZCgdishElTt" clientKey:@"eSIvsSwDlEi2h9yawgZYeocCOeyCq545oWy5Azfl"];
    
    [PFFacebookUtils initializeFacebook];
    
    // fb app id 284315155080351
    // Override point for customization after application launch.
  //Sample Test
  
	
  
    return YES;
}



-(void)loadUserInterests {
  
  //------------------ Load the Users --------------------------
  PFQuery *query = [PFQuery queryWithClassName:@"Store_interest"];
  
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
	if (!error) {
	  // The find succeeded.
	  NSLog(@"Successfully retrieved %d interests.", objects.count);
	  // Do something with the found objects
	  
	  
	  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	  delegate.userInterests = [NSMutableArray arrayWithArray: objects];
	  
	  NSLog(@"userInterests : %@", delegate.userInterests);
	  
	  
	} else {
	  // Log details of the failure
	  NSLog(@"UserInterests Error: %@ %@", error, [error userInfo]);
	}
  }];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
        [[PFFacebookUtils session] close];
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

@end
