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
        [self performSegueWithIdentifier:@"after_login" sender:self];
    }else{
	  
        /*
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
			delegate.objectIdForLoggedInUser = PFUser currentUserobject.objectId;
			
			NSLog(@"UserObjectId : %@", object.objectId);
			
		  }
		  

		  
		} else {
		  // Log details of the failure
		  NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	  }];
	  
	  */
	  
	  
	  // Push the next view controller without animation
	  //[self performSegueWithIdentifier:@"after_login" sender:self];
	  
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
    NSArray *permissionsArray = @[ @"email", @"user_friends"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self performSegueWithIdentifier:@"after_login" sender:self];
        } else {
            
            // Create request for user's Facebook data
            FBRequest *request = [FBRequest requestForMe];
            
            // Send request to Facebook
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                // handle response
                if(!error){
                    NSDictionary *userData = (NSDictionary*)result;
                    
                    NSString *facebookID = userData[@"id"];
                    NSString *email = userData[@"email"];
                    NSString *displayName = userData[@"name"];
                    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                    
                    [[PFUser currentUser] setObject:facebookID forKey:@"facebook_id"];
                    [[PFUser currentUser] setObject:email forKey:@"email"];
                    [[PFUser currentUser] setObject:displayName forKey:@"display_name"];
                    [[PFUser currentUser] setObject:[pictureURL absoluteString] forKey:@"profile_picture"];
                    
                    [[PFUser currentUser] saveInBackground];
                    
                     [FBRequestConnection startWithGraphPath:@"/me/taggable_friends" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {

                        if (!error && result)
                        {
                            NSArray* friends = [[NSArray alloc] initWithArray:[result objectForKey:@"data"]];
                            NSMutableArray* friendList = [[NSMutableArray alloc] initWithCapacity:[friends count]];
                            
                            for (NSDictionary<FBGraphUser>* friend in friends) {
                                [friendList addObject:[friend objectID]];
                            }
                            
                            PFObject *userRelationObject = [PFObject objectWithClassName:@"User_relations"];
                            userRelationObject[@"parent"] = [PFUser currentUser];
                            
                            PFQuery *query = [PFQuery queryWithClassName:@"User"];
                            [query whereKey:@"facebook_id" containedIn:friendList];
                            
                            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                if (!error) {
                                    for (PFObject *object in objects) {
                                        NSLog(@"adding [%@]", object.objectId);
                                        [userRelationObject addUniqueObject:[object objectId] forKey:@"relations"];
                                    }
                                } else {
                                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                                }
                            }];
                            [userRelationObject saveInBackground];

                        }
                    }];
                    
                    NSLog(@"requested from fb");
                }else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]){
                    NSLog(@"Invalid oauth");
                    [PFUser logOut];
                }else{
                    NSLog(@"has error");
                }
            }];
            
            NSLog(@"User with facebook logged in!");
            [self performSegueWithIdentifier:@"after_login" sender:self];

        }
        
    }];
}


@end
