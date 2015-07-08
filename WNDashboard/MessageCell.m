//
//  MessageCell.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/15/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "MessageCell.h"
#import <FBSDKCoreKit/FBSDKProfilePictureView.h>


@implementation MessageCell
@synthesize userImage = _userImage;
@synthesize nameLabel = _nameLabel;
@synthesize estabLabel = _estabLabel;
@synthesize timeLabel = _timeLabel;
@synthesize testimonialLabel = _testimonialLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
