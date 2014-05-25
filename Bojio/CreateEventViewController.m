//
//  CreateEventViewController.m
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import "CreateEventViewController.h"

@interface CreateEventViewController () {
  
  NSArray *userInterests;
}

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
  
  [self loadUserInterests];
}



-(void)loadUserInterests {
  
  //------------------ Load the Users --------------------------
  PFQuery *query = [PFQuery queryWithClassName:@"Store_interest"];
  
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
	if (!error) {
	  NSLog(@"Successfully retrieved %d interests.", objects.count);
	  
	  [self performSelectorOnMainThread:@selector(saveInterest:) withObject:objects waitUntilDone:NO];
	  NSLog(@"userInterests : %@", objects);
	  
	} else {
	  NSLog(@"UserInterests Error: %@ %@", error, [error userInfo]);
	}
  }];
}


-(void)saveInterest:(NSArray *)objects {
  
  userInterests = [NSMutableArray arrayWithArray:objects];
  NSLog(@"userInterests saved : %@", userInterests);
}



#pragma mark - Create Event -

-(BOOL)isValidEvent {
  BOOL isValid = YES;
  
  
  NSString *eventTitle		  = [self.eventNameTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventPlaceTxtFld  = [self.eventPlaceTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventTimeTxtFld	  = [self.eventTimeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventTypeTxtFld	  = [self.eventTypeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventDescTxtView  = [self.eventDescTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  if(!eventTitle.length) {
	NSLog(@"No event title");
	isValid = NO;
  } else if(!eventDescTxtView.length) {
	NSLog(@"No event description");
	isValid = NO;
  }
  
  return isValid;
}


- (IBAction)createEventBtnAction:(id)sender {
  
 /*
  // Create PFObject with recipe information
  PFObject *event = [PFObject objectWithClassName:@"User_events"];

  [event setObject:@"Test Event" forKey:@"title"];
  [event setObject:@"Summary" forKey:@"summary"];

  [event setObject:@"12-02-2014" forKey:@"eventDate"];
  [event setObject:@"300" forKey:@"eventPeriod"];
  [event setObject:@"" forKey:@"location"];
  [event setObject:@"Summary" forKey:@"location_info"];
  [event setObject:@"" forKey:@"eventTypes"];
  [event setObject:@"" forKey:@"event_public"];
  */
  
//  if([self isValidEvent]) {
//	NSLog(@"Please enter mandatory fields");
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter event details" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//	[alert show];
//	return;
//  }
  
  
  
  
  
  NSString *eventTitle		  = [self.eventNameTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventPlaceTxtFld  = [self.eventPlaceTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventTimeTxtFld	  = [self.eventTimeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventTypeTxtFld	  = [self.eventTypeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventDescTxtView  = [self.eventDescTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

  NSMutableArray *eventTypesArr = [NSMutableArray arrayWithCapacity:0];
  [eventTypesArr addObject:@"Movie"];
  [eventTypesArr addObject:@"Gym"];

  
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"dd-MMM-yyyy HH:mm:ss a"];
  NSDate *eventDate = [df dateFromString:eventTimeTxtFld];
  
  NSLog(@"Event Date : %@", eventDate);
  if(!eventDate) {
	NSLog(@"Failed to create Event: No eventDate found");
  }
  
  
  PFUser *parentPointer	  = [PFUser currentUser];
  NSNumber *eventPeriod	  = [NSNumber numberWithInt:120];
  NSNumber *event_Public  = [NSNumber numberWithBool:NO];

  CLLocationCoordinate2D coordinate ;
  coordinate.latitude = 10.093f;
  coordinate.longitude = 17.8282;
  
  PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
												longitude:coordinate.longitude];
  
  
  NSMutableDictionary *locationInfoObj = [NSMutableDictionary dictionaryWithCapacity:0];
  [locationInfoObj setObject:@"Address name" forKey:@"Name"];
  [locationInfoObj setObject:@"This is the address" forKey:@"Address"];
  
  
  
  PFObject *event = [PFObject objectWithClassName:@"User_events"];
  
  [event setObject:eventTitle		forKey:@"title"];
  [event setObject:eventDescTxtView forKey:@"summary"];
  [event setObject:eventDate		forKey:@"eventDate"];
  [event setObject:eventPeriod		forKey:@"eventPeriod"];
  [event setObject:geoPoint			forKey:@"location"];
  [event setObject:locationInfoObj	forKey:@"location_info"];
  [event setObject:eventTypesArr	forKey:@"eventTypes"];
  [event setObject:event_Public		forKey:@"event_public"];
  [event setObject:parentPointer	forKey:@"parent"];

  
  
  
  [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
	NSLog(@"Succeeded : %d", succeeded);
	NSLog(@"Error : %@", [error description]);
	
	NSString *msg = @"";
	
	if (!error) {
	  msg = @"Event Created Successfully";
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:[NSString stringWithFormat:@"%@%@",@"push",[[PFUser currentUser] objectId]]];
        [push setMessage:[NSString stringWithFormat:@"%@ created an %@ activity",[[PFUser currentUser] objectForKey:@"display_name"] , [[event objectForKey:@"eventTypes"] firstObject]]];
        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            //
        }];
	} else {
	  msg = @"Failed to create event";

	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];

	
  }];

  
}





#pragma mark - Move Up / Move Down Screen 

-(void)moveUp {
  CGRect frame = self.view.frame;
  frame.origin.y = -40;
  
  [UIView animateWithDuration:0.5f animations:^{
	self.view.frame = frame;
  } completion:^(BOOL finished) {
	;
  }];
  
}




-(void)moveDown {
  CGRect frame = self.view.frame;
  frame.origin.y = 0;
  
  [UIView animateWithDuration:0.5f animations:^{
	self.view.frame = frame;
  } completion:^(BOOL finished) {
	;
  }];
  
  [self hideKeyboard];
}


-(void)hideKeyboard {
  if([self.eventNameTxtFld isFirstResponder]){
	[self.eventNameTxtFld resignFirstResponder];
  } else if([self.eventPlaceTxtFld isFirstResponder]) {
	[self.eventPlaceTxtFld resignFirstResponder];
  } else if([self.eventTimeTxtFld isFirstResponder]) {
	[self.eventTimeTxtFld resignFirstResponder];
  } else if([self.eventTypeTxtFld isFirstResponder]){
	[self.eventTypeTxtFld resignFirstResponder];
  } else if([self.eventDescTxtView isFirstResponder]) {
	[self.eventDescTxtView resignFirstResponder];
  }
}




#pragma mark - Touches Began

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self moveDown];
  [self hideKeyboard];
}



#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  
  BOOL shouldBeginEditing = YES;
  
  if(textField == self.eventPlaceTxtFld) {
	
	[self hideKeyboard];
	shouldBeginEditing =  NO;

  } else if(textField == self.eventTimeTxtFld) {
	
	[self showDateTimePickerView];
	[self hideKeyboard];
	shouldBeginEditing =  NO;

  } else if(textField == self.eventTypeTxtFld) {
	
	[self showEventTypes];
	[self hideKeyboard];
	shouldBeginEditing =  NO;
	
  }
  
  return shouldBeginEditing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self moveDown];
  return YES;
}

#pragma mark - UITextView Delegates


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  [self moveUp];
  return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
  [self moveDown];
  [self hideKeyboard];
  [textView resignFirstResponder];
  return YES;
}


#pragma mark -

-(void)showDateTimePickerView {
  self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:@" " otherButtonTitles:@" ", @" ", @" ",@" ",nil];
  
  
  self.actionSheet.frame = CGRectMake(0, 0, 400, 500);
  
  self.actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
  
  
  UIDatePicker *datePicker=[[UIDatePicker alloc]init];//Date picker
  datePicker.frame=CGRectMake(0,44,320, 300);
  datePicker.datePickerMode = UIDatePickerModeDateAndTime;
  [datePicker setMinuteInterval:5];
  [datePicker setTag:10];
  [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
  [self.actionSheet addSubview:datePicker];
  
  
  //----------Toolbar-----------------
  UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  pickerToolbar.barStyle = UIBarStyleBlackOpaque;
  [pickerToolbar sizeToFit];
  
  NSMutableArray *barItems = [[NSMutableArray alloc] init];
  
  UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hideActionSheet)];
  [barItems addObject:cancelBtn];
  
  UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
  [barItems addObject:flexSpace];
  
  UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideActionSheet)];
  [barItems addObject:doneBtn];
  
  [pickerToolbar setItems:barItems animated:YES];
  
  
  
  [self.actionSheet addSubview:pickerToolbar];
  [self.actionSheet showInView:self.view];
}


- (void)hideActionSheet {
  [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark -


-(void)dateChanged : (UIDatePicker *)datePicker {
  
  NSDate *date = datePicker.date;
  NSLog(@"Date Selected : %@", date);
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
  [dateFormatter setDateFormat:@"dd-MMM-YYYY hh:mm:ss a"];
  //  [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
  NSString *dateStr = [dateFormatter stringFromDate:date];
  
  NSLog(@"DateStr : %@", dateStr);
  self.eventTimeTxtFld.text = dateStr;
}


-(void)showEventTypes {
  
  if(self.actionSheet) {
	self.actionSheet = nil;
  }
  
  self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:@" " otherButtonTitles:@" ", @" ", @" ",@" ",nil];
  
  
  self.actionSheet.frame = CGRectMake(0, 0, 320, 400);
  self.actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
  
  

  
  
  UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320,480)];
  pickerView.backgroundColor = [UIColor whiteColor];
  pickerView.delegate = self;
  pickerView.dataSource = self;
  [pickerView setShowsSelectionIndicator:YES];
  [self.actionSheet addSubview:pickerView];
  
  
  
  
  
  //----------Toolbar-----------------
  UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  pickerToolbar.barStyle = UIBarStyleBlackOpaque;
  [pickerToolbar sizeToFit];
  
  NSMutableArray *barItems = [[NSMutableArray alloc] init];
  
  UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hideActionSheet)];
  [barItems addObject:cancelBtn];
  
  UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
  [barItems addObject:flexSpace];
  
  UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideActionSheet)];
  [barItems addObject:doneBtn];
  
  [pickerToolbar setItems:barItems animated:YES];
  
  
  
  [self.actionSheet addSubview:pickerToolbar];
  [self.actionSheet showInView:self.view];
}




#pragma mark Picker View Delegates


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  
  return [userInterests count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  return [[userInterests objectAtIndex:row] objectForKey:@"title"];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
  return 40.0f;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  NSLog(@"pickerViewDid SelectRow : %d", row);
  self.eventTypeTxtFld.text = [[userInterests objectAtIndex:row] objectForKey:@"title"];
  
}




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





