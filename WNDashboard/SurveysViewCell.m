//
//  SurveysViewCell.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/15/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "SurveysViewCell.h"

@implementation SurveysViewCell
@synthesize questionLabel = _questionLabel;
@synthesize responseLabel = _responseLabel;
@synthesize apLabel = _apLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
