//
//  UserProfileController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/25/15.
//  Copyright (c) 2015 WiFi Nation All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileController : UIViewController <UIGestureRecognizerDelegate>


- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
- (IBAction)updateClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *disableView;
@property (weak, nonatomic) IBOutlet UIView *activityIndicatorContainer;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
