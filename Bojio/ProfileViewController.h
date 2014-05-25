//
//  ProfileViewController.h
//  Bojio
//
//  Created by Biranchi on 24/05/14.
//  Copyright (c) 2014 Biranchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage.h>

@interface ProfileViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

- (IBAction)logoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet GPUImageView *coverPhoto;

@end
