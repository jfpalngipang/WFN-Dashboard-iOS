//
//  ActivityIndicatorController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/26/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "ActivityIndicatorController.h"

@interface ActivityIndicatorController ()

@end

@implementation ActivityIndicatorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.activityIndicator startAnimating];
    [self.activityIndicatorOrange startAnimating];
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

@end
