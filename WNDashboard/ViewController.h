//
//  ViewController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
- (IBAction)buttonLogInClicked:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end

