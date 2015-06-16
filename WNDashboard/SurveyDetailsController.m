//
//  SurveyDetailsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/16/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "SurveyDetailsController.h"

@interface SurveyDetailsController ()

@end

@implementation SurveyDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.surveyLabel.text = @"Sample Survey Question";
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
