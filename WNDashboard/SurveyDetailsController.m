//
//  SurveyDetailsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/16/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "SurveyDetailsController.h"
#import "requestUtility.h"
#import "SurveyDetailsViewController.h"
#import "SurveyAPViewController.h"
#import "Data.h"

@interface SurveyDetailsController ()

@end

@implementation SurveyDetailsController
@synthesize surveyQuestion;
@synthesize responseCounts;
@synthesize responses;
@synthesize responseAPList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    surveyClicked = NO;
    self.pieChartContainer.hidden = false;
    self.apListContainer.hidden = true;
    /*
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"Title";
    self.navigationItem.backBarButtonItem = item;
    */
    self.surveyLabel.text = surveyQuestion;
    self.pieChartContainer.hidden = false;
    self.apListContainer.hidden = true;

    
    SurveyDetailsViewController *chart = [self.childViewControllers objectAtIndex:0];
    [chart beginCharting];

    SurveyAPViewController *apTable = [self.childViewControllers objectAtIndex:1];

    [apTable refreshTable];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)indexChanged:(id)sender {
    switch(self.segmentedControl.selectedSegmentIndex){
        case 0:
            self.pieChartContainer.hidden = false;
            self.apListContainer.hidden = true;
            break;
        case 1:
            self.pieChartContainer.hidden = true;
            self.apListContainer.hidden = false;
            break;
    }
}
@end
