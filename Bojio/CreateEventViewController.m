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

-(BOOL)isValidEvent {
  BOOL isValid = YES;
  
  
  NSString *eventTitle		  = [self.eventNameTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventPlaceTxtFld  = [self.eventNameTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventTimeTxtFld	  = [self.eventTimeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventTypeTxtFld	  = [self.eventNameTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *eventDescTxtView  = [self.eventDescTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  if(!eventTitle.length) {
	isValid = NO;
  } else if(!eventDescTxtView.length) {
	isValid = NO;
  }
  
  return isValid;
}


- (IBAction)createEventBtnAction:(id)sender {
  
 /*
  // Create PFObject with recipe information
  [event setObject:@"Test Event" forKey:@"title"];
  [event setObject:@"Summary" forKey:@"summary"];

  [event setObject:@"12-02-2014" forKey:@"eventDate"];
  [event setObject:@"300" forKey:@"eventPeriod"];
  [event setObject:@"" forKey:@"location"];
  [event setObject:@"Summary" forKey:@"location_info"];
  [event setObject:@"" forKey:@"eventTypes"];
  [event setObject:@"" forKey:@"event_public"];
  */
  
  if([self isValidEvent]) {
	NSLog(@"Please enter mandatory fields");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter event details" delegate:nil cancelButtonTitle:@"" otherButtonTitles:@"OK", nil];
	[alert show];
	return;
  }
  
  
  PFObject *event = [PFObject objectWithClassName:@"User_events"];
  
  [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
	NSLog(@"Succeeded : %d", succeeded);
	NSLog(@"Error : %@", [error description]);
	
	NSString *msg = @"";
	
	if (!error) {
	  msg = @"Event Created Successfully";
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
  }
}




#pragma mark - Touches Began

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self moveDown];
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
	
	//[self showEventTypes];
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
  //[datePicker addTarget:self action:@selector(Result) forControlEvents:UIControlEventValueChanged];
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



#pragma mark Picker View Delegates


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  
  return 10;// [self.blocksArr count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  return @""; //[self.blocksArr objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
  return 40.0f;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  NSLog(@"pickerViewDid SelectRow : %d", row);
  //self.blockNameLbl.text = [self.blocksArr objectAtIndex:row];
  
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





