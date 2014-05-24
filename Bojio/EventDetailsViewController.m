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

@interface EventDetailsViewController ()

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
  
	//Event is viewed
	[self eventIsViewed];

  
    // Do any additional setup after loading the view.
	[self displayEventDetails];
}


#pragma mark -

-(void)eventIsViewed {
	
  NSLog(@"Event is viewed");
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



-(NSString *)getUserEventTypes : (id)eventTypes {
  NSString *interest = @"";
  
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  
  if([eventTypes isKindOfClass:[NSArray class]]) {
	
	for(int i=0; i < [eventTypes count]; i ++) {
	  
	  NSString *eventTypeId = [eventTypes objectAtIndex:i];
	  //NSLog(@"eventTypeId : %@", eventTypeId);
	  
	  for(int j=0; j < delegate.userInterests.count; j++) {
		
		PFObject *object = delegate.userInterests[j];
		//NSLog(@"object.objectId : %@", object.objectId);
		
		if ([object.objectId isEqualToString:eventTypeId]) {
		  interest = [NSString stringWithFormat:@"%@%@%@", interest, (interest.length)?@", ":@"", [object objectForKey:@"title"]];
		}
	  }
	}
	
  } else if([eventTypes isKindOfClass:[NSString class]]) {
	;
  }
  
  NSLog(@"interest 22 : %@", interest);
  
  if([interest length]) {
	
  }
  
  return interest;
  
}



#pragma mark - Yes Button Action


- (IBAction)yesBtnAction:(id)sender {
  NSLog(@"Yes Button Clicked");
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
