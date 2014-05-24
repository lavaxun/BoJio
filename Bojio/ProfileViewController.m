//
//  ProfileViewController.m
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import "ProfileViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSDateFormatter *_dateFormatter;
    NSArray* _activities;
}
@end

@implementation ProfileViewController

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
    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if ([PFUser currentUser]) {
        [self updateProfile];
    }
    
    self.activityTable.delegate = self;
    self.activityTable.dataSource = self;
    [self refreshTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateProfile
{
    NSString* profilePictureUrl =  (NSString*)[[PFUser currentUser] objectForKey:@"profile_picture"];
    NSString* displayName = (NSString*) [[PFUser currentUser] objectForKey:@"display_name"];
    NSString* email = (NSString*) [[PFUser currentUser] objectForKey:@"email"];
    
    self.email.text = email;
    self.displayName.text = displayName;
    [self.profilePicture setImageWithURL:[NSURL URLWithString:profilePictureUrl]];
}


- (void)refreshTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"User_events"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %d events.", objects.count);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                NSLog(@"Event : %@", object.objectId);
//                NSLog(@"Event 22 : %@", [object objectForKey:@"eventDate"]);
//            }
            _activities = objects;
            [self.activityTable reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_activities count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"profile_activity_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if(!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    PFObject *object = [_activities objectAtIndex:indexPath.row];
    NSDate* eventDate = (NSDate *)[object objectForKey:@"eventDate"];
    [_dateFormatter setDateFormat:@"MMM d, hh:mm"];
    
    NSString *eventName	= [object objectForKey:@"title"];
    NSString *eventPlace	= [[object objectForKey:@"location_info"] objectForKey:@"Name"];
    NSString *eventTime	= [_dateFormatter stringFromDate:eventDate];
    NSString *eventType	= [[object objectForKey:@"eventTypes"] firstObject];
    
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
    
    UILabel *eventNameLbl	  = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *eventPlaceLbl  = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *eventTimeLbl	  = (UILabel *)[cell.contentView viewWithTag:3];
    UIImageView *eventTypeImg	  = (UIImageView *)[cell.contentView viewWithTag:4];
    
    eventNameLbl.text		  = eventName;
    eventPlaceLbl.text        = eventPlace;
    eventTimeLbl.text		  = eventTime;
    eventTypeImg.image		  = eventImg;
    
    return cell;
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

- (IBAction)logoutAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
