//
//  UserLogsCell.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/15/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "UserLogsCell.h"

@implementation UserLogsCell
@synthesize nameLabel = _nameLabel;
@synthesize deviceImage = _deviceImage;
@synthesize startLabel = _startLabel;
@synthesize totalLabel = _totalLabel;
@synthesize deviceLabel = _deviceLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
