//
//  ViewController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    NSString *username;
}

@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;


@property (weak, nonatomic) IBOutlet UIView *activityIndicatorContainer;
- (IBAction)buttonLogInClicked:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;



@end

