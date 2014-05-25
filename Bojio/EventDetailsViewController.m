//
//  EventDetailsViewController.m
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import "EventDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"

@interface EventDetailsViewController () {
    BOOL _isNavBarHidden;
    CGFloat _originY;
    CGFloat _previousY;
    NSMutableDictionary *attendeeNames;
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
    self.hostPicture.layer.masksToBounds = YES;
    self.hostPicture.layer.cornerRadius = self.hostPicture.bounds.size.width/2.0f;
    self.hostPicture.layer.borderWidth = 2.0f;
    self.hostPicture.layer.borderColor = [[UIColor whiteColor] CGColor];

    self.yesBtn.hidden = YES;
    self.noBtn.hidden = YES;

    // Do any additional setup after loading the view.
	[self displayEventDetails];
  
    attendeeNames = [NSMutableDictionary dictionary];
  
	//Display list of attending users
	[self displayListOfUsersAttending];
}


#pragma mark -


-(void)displayListOfUsersAttending {
  
  PFQuery *query = [PFQuery queryWithClassName:@"Event_attendance"];
  [query whereKey:@"eventId" equalTo:self.object];
  
  
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
	if (!error) {
        
        for(PFObject* obj in objects){
            if([[[obj objectForKey:@"userId"] objectId] isEqualToString:[[PFUser currentUser] objectId]]){
                self.yesBtn.hidden = NO;
                self.noBtn.hidden = NO;
                break;
            }
        }
	  // The find succeeded.
	  NSLog(@"----Successfully retrieved %d Users Attending-------", objects.count);
	  
	  usersAttending = objects;
	  NSLog(@"usersAttending : %@", usersAttending);
	  [self.tableView reloadData];
    
	} else {
	  // Log details of the failure
	  NSLog(@"User's Attending Error: %@ %@", error, [error userInfo]);
	}
  }];
  
}



-(void)displayEventDetails {
  if(self.object){

	AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

      NSString* eventType = [self getUserEventTypes: [self.object objectForKey:@"eventTypes"]];
      UIImage *eventImg = nil;
      if([eventType isEqualToString:@"Gym"]){
          eventImg = [UIImage imageNamed:@"gym.jpg"];
      }else if([eventType isEqualToString:@"Breakfast"]){
          eventImg = [UIImage imageNamed:@"meal.jpg"];
      }else if([eventType isEqualToString:@"Lunch"]){
          eventImg = [UIImage imageNamed:@"meal.jpg"];
      }else if([eventType isEqualToString:@"Dinner"]){
          eventImg = [UIImage imageNamed:@"meal.jpg"];
      }else if([eventType isEqualToString:@"Movie"]){
          eventImg = [UIImage imageNamed:@"movie.jpg"];
      }else if([eventType isEqualToString:@"Hangout"]){
          eventImg = [UIImage imageNamed:@"hangout.jpg"];
      }else{
          eventImg = [UIImage imageNamed:@"hangout.jpg"];
      }
      
      NSString* userId = [[self.object objectForKey:@"parent"] objectId];
      PFQuery *query = [PFUser query];
      PFUser *who = (PFUser*)[query getObjectWithId:userId];
      
      self.eventNameLbl.text	= [self.object objectForKey:@"title"];
      self.eventPlaceLbl.text = [[self.object objectForKey:@"location_info"] objectForKey:@"Name"];
      self.eventDateTime.text = [delegate formatDate: [self.object objectForKey:@"eventDate"]];
      self.eventDescLbl.text	= [self.object objectForKey:@"summary"];
      self.eventType.image = eventImg;
      [self.hostPicture setImageWithURL:[NSURL URLWithString:[who objectForKey:@"profile_picture"]]];
	//self.eventTypeLbl.text	= [self getUserEventTypes: [self.object objectForKey:@"eventTypes"]];
	
	
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
    
    PFObject *myPost = [PFObject objectWithClassName:@"Event_attendance"];
    myPost[@"attendance"] = [NSNumber numberWithBool:YES];
    myPost[@"summary"] = @"I will be there";
    
    myPost[@"eventId"] = self.object;
    myPost[@"userId"] = [PFUser currentUser];
    
    // This will save both myPost and myComment
    [myPost saveInBackground];
    
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
  
    UIView* thickBorder = (UIView*)[cell.contentView viewWithTag:99];
//  UIImageView *imageView  = (UIImageView *)[cell.contentView viewWithTag:1];
  UILabel *userNameLbl	  = (UILabel *)[cell.contentView viewWithTag:2];

//  userNameLbl.text		  = eventType;
  if(attendance) {
      thickBorder.backgroundColor = [UIColor colorWithRed:46/255.0f green:204/255.0f blue:113/255.0f alpha:1.0] ;

//	imageView.image = [UIImage imageNamed:@"green.png"];
  } else {
      thickBorder.backgroundColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0];

//	imageView.image = [UIImage imageNamed:@"red.png"];
  }
  
  
//  //----------- Get user names from userId ------------------
    NSString* userId = [[object objectForKey:@"userId"] objectId];
    PFUser *who = nil;
    
    if([attendeeNames objectForKey:userId]){
        who = [attendeeNames objectForKey:userId];
    }else{
        PFQuery *query = [PFUser query];
        who = (PFUser*)[query getObjectWithId:userId];
        [attendeeNames setObject:who forKey:userId];
    }

    userNameLbl.text = [who objectForKey:@"display_name"];
    
  return cell;
}



#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _originY = _previousY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat scrolledDistance = _originY - currentOffset;
    CGFloat lastScrolledDistance = _previousY - currentOffset;
    _previousY = currentOffset;
    
    if(scrolledDistance < 0){
        if(scrollView.isTracking && abs(lastScrolledDistance) > 1){
            if(_isNavBarHidden)
                return;
            
            _isNavBarHidden = YES;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            
        }
    }else{
        if(scrollView.isTracking && abs(lastScrolledDistance) > 1){
            if(!_isNavBarHidden)
                return;
            
            _isNavBarHidden = NO;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            
        }
    }
}


-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if(_isNavBarHidden)
        return YES;
    
    _isNavBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    return YES;
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

- (IBAction)notGoingAction:(id)sender {
    PFObject *myPost = [PFObject objectWithClassName:@"Event_attendance"];
    myPost[@"attendance"] = [NSNumber numberWithBool:NO];
    myPost[@"summary"] = @"I will be there";
    
    myPost[@"eventId"] = self.object;
    myPost[@"userId"] = [PFUser currentUser];
    
    // This will save both myPost and myComment
    [myPost saveInBackground];
}


@end
