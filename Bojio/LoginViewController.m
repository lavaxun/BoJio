//
//  LoginViewController.m
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController () <PFLogInViewControllerDelegate>

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
	  
	  //------------------ Load the User Interests --------------------------
	  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	  [delegate loadUserInterests];
	  
	  
	  
	  //------------------ Load the Users --------------------------
	  PFQuery *query = [PFQuery queryWithClassName:@"User"];
	  [query whereKey:@"username" equalTo:[PFUser currentUser].username];
	  
	  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error) {
		  // The find succeeded.
		  NSLog(@"Successfully retrieved %d users.", objects.count);
		  // Do something with the found objects
		  
		  if (objects.count) {
			
			PFObject *object = [objects objectAtIndex:0];
			delegate.objectIdForLoggedInUser = object.objectId;
			
			NSLog(@"UserObjectId : %@", object.objectId);
			
		  }
		  

		  
		} else {
		  // Log details of the failure
		  NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	  }];
	  
	  
	  
	  
	  // Push the next view controller without animation
	  [self performSegueWithIdentifier:@"after_login" sender:self];
	  

	  
	  
	  
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginAction:(id)sender {
    
    self.activityIndicator.hidden = NO;
    
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self performSegueWithIdentifier:@"after_login" sender:self];
        } else {
            NSLog(@"User with facebook logged in!");
            [self performSegueWithIdentifier:@"after_login" sender:self];
        }
    }];
}


@end
