//
//  UserLogsController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/10/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"
#import "DateSelectionController.h"

@interface UserLogsController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, modalDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
- (IBAction)dateTextFieldEditing:(UITextField *)sender;
- (IBAction)apTextFieldEditing:(UITextField *)sender;

- (IBAction)test:(UITextField *)sender;

@property (weak, nonatomic) IBOutlet UIView *activityIndicatorContainer;


@property (weak, nonatomic) IBOutlet UITextField *APListTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backgroundTap:(id)sender;



@end
