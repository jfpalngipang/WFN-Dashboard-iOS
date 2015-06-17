//
//  OnlineUsersCell.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/12/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineUsersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *onlineImage;

@end
