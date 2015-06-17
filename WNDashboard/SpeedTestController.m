//
//  SpeedTestController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/11/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "SpeedTestController.h"
#import "WNDashboard-Bridging-Header.h"
#import "requestUtility.h"


@interface SpeedTestController () <ChartViewDelegate>

@end

@implementation SpeedTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    
    _lineChartView.delegate = self;
    
    _lineChartView.descriptionText = @"";
    _lineChartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    _lineChartView.highlightEnabled = YES;
    _lineChartView.dragEnabled = YES;
    [_lineChartView setScaleEnabled:YES];
    _lineChartView.pinchZoomEnabled = NO;
    _lineChartView.drawGridBackgroundEnabled = NO;
    
    _lineChartView.xAxis.enabled = NO;
    _lineChartView.leftAxis.enabled = NO;
    _lineChartView.rightAxis.enabled = NO;
    _lineChartView.legend.enabled = NO;
    
    [_lineChartView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
    
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
