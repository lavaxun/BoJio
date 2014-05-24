//
//  EventDetailsViewController.h
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EventDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  
}

@property (nonatomic, strong) PFObject *object;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *eventPlaceLbl;
@property (weak, nonatomic) IBOutlet UILabel *eventDateTime;
@property (weak, nonatomic) IBOutlet UILabel *eventDescLbl;
@property (weak, nonatomic) IBOutlet UILabel *eventTypeLbl;

@property (weak, nonatomic) IBOutlet UIButton *yesBtn;

@property (weak, nonatomic) IBOutlet UITableView *aTableView;

@end
