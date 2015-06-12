//
//  FrequentUsersCell.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/12/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "FrequentUsersCell.h"

@implementation FrequentUsersCell
@synthesize nameLabel = _nameLabel;
@synthesize countLabel = _countLabel;
@synthesize mainFBImage = _mainFBImage;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
