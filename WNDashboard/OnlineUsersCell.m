//
//  OnlineUsersCell.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/12/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "OnlineUsersCell.h"

@implementation OnlineUsersCell
@synthesize onlineImage = _onlineImage;
@synthesize countLabel = _countLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
