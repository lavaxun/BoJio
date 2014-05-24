//
//  CreateEventViewController.m
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import "CreateEventViewController.h"

@interface CreateEventViewController ()

@end

@implementation CreateEventViewController

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
}


#pragma mark - Create Event -


- (IBAction)createEventBtnAction:(id)sender {
  
 
  // Create PFObject with recipe information
  PFObject *event = [PFObject objectWithClassName:@"user_events"];
  [event setObject:@"Test Event" forKey:@"title"];
  [event setObject:@"Summary" forKey:@"summary"];

  [event setObject:@"12-02-2014" forKey:@"eventDate"];
  [event setObject:@"300" forKey:@"eventPeriod"];
  [event setObject:@"" forKey:@"location"];
  [event setObject:@"Summary" forKey:@"location_info"];
  [event setObject:@"" forKey:@"eventTypes"];
  [event setObject:@"" forKey:@"event_public"];

  [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
	NSLog(@"Succeeded : %d", succeeded);
	NSLog(@"Error : %@", [error description]);
	
	NSString *msg = @"";
	
	if (!error) {
	  msg = @"Successful......";
	} else {
	  msg = [NSString stringWithFormat:@"Upload Failure...... : %@", [error localizedDescription]];

	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];

	
  }];

  
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





