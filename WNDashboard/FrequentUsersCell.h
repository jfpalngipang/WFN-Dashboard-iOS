//
//  FrequentUsersCell.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/12/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKProfilePictureView.h>

@interface FrequentUsersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainFBImage;
@property (weak, nonatomic) IBOutlet UILabel *timeDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *usageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;



@end
