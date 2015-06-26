//
//  UserProfileController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/25/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "UserProfileController.h"
#import "SWRevealViewController.h"
#import "Data.h"


@interface UserProfileController ()

@end

@implementation UserProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationTextView.layer.borderWidth = 1.0f;
    self.locationTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.emailTextField.text = userInfo[0];
        self.firstTextField.text = userInfo[1];
        self.lastTextField.text = userInfo[2];
        self.phoneTextField.text = userInfo[3];
        self.locationTextView.text = userInfo[4];
    
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}
@end
