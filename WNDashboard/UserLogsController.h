//
//  UserLogsController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/10/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"

@interface UserLogsController : UIViewController 
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@property (strong, nonatomic) DownPicker *downPicker;
@property (weak, nonatomic) IBOutlet UITextField *APListTextField;

- (IBAction)APSelectClicked:(id)sender;

@end
