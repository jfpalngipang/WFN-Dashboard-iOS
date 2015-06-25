//
//  UserProfileController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/25/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "UserProfileController.h"


@interface UserProfileController ()

@end

@implementation UserProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationTextView.layer.borderWidth = 1.0f;
    self.locationTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    // Do any additional setup after loading the view.
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
