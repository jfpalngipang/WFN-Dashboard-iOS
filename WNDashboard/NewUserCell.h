//
//  NewUserCell.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/17/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKProfilePictureView.h>

@interface NewUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newuserImage;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *minorImage1;
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *minorImage2;
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *minorImage3;

@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *minorImage4;
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *minorImage5;

@end
