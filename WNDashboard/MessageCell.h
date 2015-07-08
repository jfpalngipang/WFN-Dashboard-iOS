//
//  MessageCell.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/15/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import <FBSDKCoreKit/FBSDKProfilePictureView.h>



@interface MessageCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *estabLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *testimonialLabel;

@end
