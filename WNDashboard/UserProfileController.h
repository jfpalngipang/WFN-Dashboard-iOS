//
//  UserProfileController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/25/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *locationTextView;
- (IBAction)backgroundTap:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;

@property (weak, nonatomic) IBOutlet UITextField *lastTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;


@end
