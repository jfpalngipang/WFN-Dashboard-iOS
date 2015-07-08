//
//  FrequentUsersCell.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/12/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "FrequentUsersCell.h"

@implementation FrequentUsersCell

@synthesize profilePicture = _profilePicture;
@synthesize nameLabel = _nameLabel;
@synthesize usageLabel = _usageLabel;
@synthesize timeDateLabel = _timeDateLabel;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
