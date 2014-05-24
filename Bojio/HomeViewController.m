//
//  HomeViewController.m
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () {
  NSArray *eventsList;
}

@end

@implementation HomeViewController

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
  
  
  NSString *currentUser = [PFUser currentUser].username;
  NSLog(@"Current USer : %@", currentUser);
  
  
    
    [self.navigationItem setHidesBackButton:YES animated:YES];

    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if(!error){
            NSLog(@"requested from fb");
        }else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]){
            NSLog(@"Invalid oauth");
            [self logoutAction];
        }else{
            NSLog(@"has error");
        }
    }];
    
  
  //--------- Load Events from Parse --------
  [[NSNotificationCenter defaultCenter] addObserver:self
										   selector:@selector(refreshTable:)
											   name:@"refreshTable"
											 object:nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];

}



#pragma mark - Events list




- (void)refreshTable:(NSNotification *) notification
{
  
  NSLog(@"Getting user events");
  
  // Reload the recipes
  PFQuery *query = [PFQuery queryWithClassName:@"User_events"];
  //[query whereKey:@"parent" equalTo:@"Dan Stemkoski"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
	if (!error) {
	  // The find succeeded.
	  NSLog(@"Successfully retrieved %d events.", objects.count);
	  // Do something with the found objects
	  for (PFObject *object in objects) {
        NSLog(@"Event : %@", object.objectId);
		NSLog(@"Event 22 : %@", [object objectForKey:@"eventDate"]);

	  }
	  
	  eventsList = objects;
	  NSLog(@"EventsList : %@", eventsList);
	  [self.aTableView reloadData];
	  
	} else {
	  // Log details of the failure
	  NSLog(@"Error: %@ %@", error, [error userInfo]);
	}
  }];
  
}


#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)logoutAction
{
    [PFUser logOut];
	[self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark -

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}

#pragma mark -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSLog(@"EventsList Count : %d", eventsList.count);
  return [eventsList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *identifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if(cell == nil) {
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  
  
  PFObject *object = [eventsList objectAtIndex:indexPath.row];
  
  NSString *eventName	= [object objectForKey:@"title"];
  NSString *eventPlace	= [[object objectForKey:@"location_info"] objectForKey:@"Name"];
  NSString *eventTime	= @"";
  NSString *eventDesc	= [object objectForKey:@"summary"];
  NSString *eventType	= @"";
  
  
  UILabel *eventNameLbl	  = (UILabel *)[cell.contentView viewWithTag:1];
  UILabel *eventPlaceLbl  = (UILabel *)[cell.contentView viewWithTag:2];
  UILabel *eventTimeLbl	  = (UILabel *)[cell.contentView viewWithTag:3];
  UILabel *eventDescLbl	  = (UILabel *)[cell.contentView viewWithTag:4];
  UILabel *eventTypeLbl	  = (UILabel *)[cell.contentView viewWithTag:5];
  
  eventNameLbl.text		  = eventName;
  eventPlaceLbl.text	  = eventPlace;
  eventTimeLbl.text		  = eventTime;
  eventDescLbl.text		  = eventDesc;
  eventTypeLbl.text		  = eventType;
  
  
  return cell;
}





#pragma mark -




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)profileOnTap:(id)sender {
}
@end
