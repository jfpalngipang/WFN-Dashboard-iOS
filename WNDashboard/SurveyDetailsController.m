//
//  SurveyDetailsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/16/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "SurveyDetailsController.h"
#import "requestUtility.h"

@interface SurveyDetailsController ()

@end

@implementation SurveyDetailsController
@synthesize surveyQuestion;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.surveyLabel.text = surveyQuestion;
    self.pieChartContainer.hidden = false;
    self.apListContainer.hidden = true;
    
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

- (IBAction)indexChanged:(id)sender {
}
@end
