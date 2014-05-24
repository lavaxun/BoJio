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
    
    // Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES animated:YES];

}

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

 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
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
