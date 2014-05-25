//
//  ProfileViewController.m
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import "ProfileViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileViewController ()
{
    BOOL _isNavBarHidden;
    CGFloat _originY;
    CGFloat _previousY;
    GPUImageiOSBlurFilter *_blurFilter;
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
    
    if(!_blurFilter){
        _blurFilter = [[GPUImageiOSBlurFilter alloc] init];
        _blurFilter.blurRadiusInPixels = 1.0f;
    }
    
    UIImage* picture = [UIImage imageNamed:@"cover.jpg"];
    GPUImagePicture* gpuPicture = [[GPUImagePicture alloc] initWithImage:picture];
    [gpuPicture addTarget:_blurFilter];
    [_blurFilter addTarget:self.coverPhoto];
    [self.coverPhoto setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
    [gpuPicture processImage];
    
    if(!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
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
            [self.tableView reloadData];
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


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    header.backgroundColor = [UIColor colorWithRed:240/255.0f green:233/255.0f blue:221/255.0f alpha:1.0];
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 28)];
    headerLabel.text = @"Activities";
    [header addSubview:headerLabel];
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"new_activity_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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

- (IBAction)logoutAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
