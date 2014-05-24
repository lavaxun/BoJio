//
//  HomeViewController.m
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

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
}



#pragma mark - Events list


- (PFQuery *)queryForTable
{
  NSString *parseClassName = @"user_events";
  
  PFQuery *query = [PFQuery queryWithClassName:parseClassName];
  
  // If no objects are loaded in memory, we look to the cache first to fill the table
  // and then subsequently do a query against the network.
  /*    if ([self.objects count] == 0) {
   query.cachePolicy = kPFCachePolicyCacheThenNetwork;
   }*/
  
  //    [query orderByAscending:@"name"];
  
  return query;
}



- (void)refreshTable:(NSNotification *) notification
{
  // Reload the recipes
  [self loadObjects];
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
  return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
  
  static NSString *identifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if(cell == nil) {
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  
  NSString *eventName	= [NSString stringWithFormat:@"Test Event : %d", indexPath.row];
  NSString *eventPlace	= [NSString stringWithFormat:@"Place : %d", indexPath.row];
  NSString *eventTime	= @"";
  NSString *eventDesc	= @"";
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


- (void) objectsDidLoad:(NSError *)error
{
  [super objectsDidLoad:error];
  
  NSLog(@"error: %@", [error localizedDescription]);
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
