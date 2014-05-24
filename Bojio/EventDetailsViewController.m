//
//  EventDetailsViewController.m
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import "EventDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface EventDetailsViewController () {
  
  NSArray *usersAttending;
}

@end

@implementation EventDetailsViewController

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
	self.yesBtn.layer.cornerRadius = 10.0f;
  
  
    // Do any additional setup after loading the view.
	[self displayEventDetails];
  
  
	//Display list of attending users
	[self displayListOfUsersAttending];
}


#pragma mark -


-(void)displayListOfUsersAttending {
  
  
  
  PFQuery *query = [PFQuery queryWithClassName:@"Event_attendance"];
  [query whereKey:@"eventId" equalTo:self.object];
  
  
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
	if (!error) {
	  // The find succeeded.
	  NSLog(@"----Successfully retrieved %d Users Attending-------", objects.count);
	  
	  usersAttending = objects;
	  NSLog(@"usersAttending : %@", usersAttending);
	  [self.aTableView reloadData];
	  
	} else {
	  // Log details of the failure
	  NSLog(@"User's Attending Error: %@ %@", error, [error userInfo]);
	}
  }];
  
}



-(void)displayEventDetails {
  if(self.object){

	AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

	self.eventNameLbl.text	= [self.object objectForKey:@"title"];
	self.eventPlaceLbl.text = [[self.object objectForKey:@"location_info"] objectForKey:@"Name"];
	self.eventDateTime.text = [delegate formatDate: [self.object objectForKey:@"eventDate"]];
	self.eventDescLbl.text	= [self.object objectForKey:@"summary"];
	self.eventTypeLbl.text	= [self getUserEventTypes: [self.object objectForKey:@"eventTypes"]];
	
	
  } else {
	NSLog(@"Object is empty");
  }
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
  //NSLog(@"interest : %@", interest);
  
    return interest;
  
}



#pragma mark - Yes Button Action


- (IBAction)yesBtnAction:(id)sender {
  NSLog(@"Yes Button Clicked");
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSLog(@"User's Attending Count : %d", usersAttending.count);
  return [usersAttending count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *identifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if(cell == nil) {
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  
  
  PFObject *object		= [usersAttending objectAtIndex:indexPath.row];
  
  NSLog(@"Event Attendance : %@", object);
  
  BOOL attendance	= [[object objectForKey:@"attendance"] boolValue];
  
  UIImageView *imageView  = (UIImageView *)[cell.contentView viewWithTag:1];
  UILabel *userNameLbl	  = (UILabel *)[cell.contentView viewWithTag:2];

//  userNameLbl.text		  = eventType;
  if(attendance) {
	imageView.image = [UIImage imageNamed:@"green.png"];
  } else {
	imageView.image = [UIImage imageNamed:@"red.png"];
  }
  
  
//  //----------- Get user names from userId ------------------
//  
  NSLog(@"object 2323 : %@", [object objectForKey:@"userId"]);
  NSLog(@"object 2222 : %@", [[object objectForKey:@"userId"] objectId]);


//  PFUser *userObj = (PFUser *)[object objectForKey:@"userId"];
//  NSLog(@"Username : %@", [userObj objectForKey:@"username"]);
//  
//  
//  
//  
//  PFQuery *query = [PFQuery queryWithClassName:@"User"];
//  //[query whereKey:@"objectId" equalTo:[object objectForKey:@"userId"]];
//  
//  
//  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//	if (!error) {
//	  // The find succeeded.
//	  NSLog(@"----Successfully retrieved %d Users Names-------", objects.count);
//	  
//	  //usersAttending = objects;
//	  NSLog(@"users 123 : %@", objects);
//	  //[self.aTableView reloadData];
//	  
//	} else {
//	  // Log details of the failure
//	  NSLog(@"User's name Error: %@ %@", error, [error userInfo]);
//	}
//  }];
  
  
  
  return cell;
}



#pragma mark -


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

@end
