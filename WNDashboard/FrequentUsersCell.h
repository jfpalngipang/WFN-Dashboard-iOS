//
//  FrequentUsersCell.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/12/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrequentUsersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainFBImage;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
