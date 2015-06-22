//
//  UserLogsController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/10/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"

@interface UserLogsController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
- (IBAction)dateTextFieldEditing:(UITextField *)sender;


@property (strong, nonatomic) DownPicker *downPicker;
@property (weak, nonatomic) IBOutlet UITextField *APListTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backgroundTap:(id)sender;



@end
