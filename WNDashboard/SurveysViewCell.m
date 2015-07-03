//
//  SurveysViewCell.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/15/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "SurveysViewCell.h"

@implementation SurveysViewCell
@synthesize questionLabel = _questionLabel;
@synthesize respLabel = _respLabel;
@synthesize statusImage = _statusImage;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
