//
//  RevealViewCell.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/25/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RevealViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *viewImage;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)logout:(id)sender;

@end
