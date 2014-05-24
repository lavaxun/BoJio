//
//  HomeViewController.m
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "EventDetailsViewController.h"

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
  NSLog(@"Current User : %@", currentUser);
  
  
    
    [self.navigationItem setHidesBackButton:YES animated:YES];

    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // handle successful response
        } else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [self logoutAction];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    
    [self.navigationItem setHidesBackButton:YES animated:YES];

  //--------- Load Events from Parse --------
  [[NSNotificationCenter defaultCenter] addObserver:self
										   selector:@selector(refreshTable:)
											   name:@"refreshTable"
											 object:nil];
  //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];

  [self loadUserInterests];
}



#pragma mark - Events list


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
	  [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
	  
	} else {
	  // Log details of the failure
	  NSLog(@"UserInterests Error: %@ %@", error, [error userInfo]);
	}
  }];
}



- (void)refreshTable:(NSNotification *) notification
{
  
  
  // Reload the recipes
  PFQuery *query = [PFQuery queryWithClassName:@"User_events"];
  [query whereKey:@"parent" equalTo:[PFUser currentUser]];
  
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
	if (!error) {
	  // The find succeeded.
	  NSLog(@"Successfully retrieved %d events.", objects.count);
	  
//	  // Do something with the found objects
//	  for (PFObject *object in objects) {
//        NSLog(@"Event : %@", object.objectId);
//		NSLog(@"Event 22 : %@", [object objectForKey:@"eventDate"]);
//	  }
	  
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

#pragma mark - TableView


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
  
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  
  PFObject *object		= [eventsList objectAtIndex:indexPath.row];
  
  NSString *eventName	= [object objectForKey:@"title"];
  NSString *eventPlace	= [[object objectForKey:@"location_info"] objectForKey:@"Name"];
  NSString *eventTime	= [delegate formatDate: [object objectForKey:@"eventDate"]];
  NSString *eventDesc	= [object objectForKey:@"summary"];
  NSString *eventType	= [self getUserEventTypes: [object objectForKey:@"eventTypes"]];
  
  
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
  selectedRow = indexPath.row;
  [self performSegueWithIdentifier:@"EventDetailSegue" sender:self];

}



#pragma mark - User Interests


-(NSString *)formatDate : (NSDate *)date {
  NSString *dateStr = @"";
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
  [dateFormatter setDateFormat:@"dd-MMM-YYYY hh:mm:ss a"];
  //  [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
  dateStr = [dateFormatter stringFromDate:date];
  
  NSLog(@"DateStr : %@", dateStr);
  return  dateStr;
}



-(NSString *)getUserEventTypes : (NSArray *)eventTypes {
  NSString *interest = @"";
  
  
  for(int j=0; j < eventTypes.count; j++) {
	
	  interest = eventTypes[j];
	  interest = [NSString stringWithFormat:@"%@,", interest];
  }

  
  NSMutableArray *components = (NSMutableArray *)[interest componentsSeparatedByString:@","];
  [components removeLastObject];
  interest = [components componentsJoinedByString:@","];
  NSLog(@"interest : %@", interest);
  

  
  return interest;
  
}



#pragma mark -


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  
  
  if([[segue identifier] isEqualToString:@"EventDetailSegue"]) {
	
	EventDetailsViewController *controller = [segue destinationViewController];
	controller.object = [eventsList objectAtIndex:selectedRow];
	
  }
  
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
