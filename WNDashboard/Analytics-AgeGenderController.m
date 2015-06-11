//
//  Analytics-AgeGenderController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/10/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "Analytics-AgeGenderController.h"
#import "SWRevealViewController.h"
#import "WNDashboard-Bridging-Header.h"


@interface Analytics_AgeGenderController () <ChartViewDelegate>
@property (nonatomic, strong) IBOutlet HorizontalBarChartView *barChartView;


@end

@implementation Analytics_AgeGenderController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
    _barChartView.delegate = self;
    
    ChartXAxis *xAxis = _barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawAxisLineEnabled = YES;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.gridLineWidth = .3;
    
    ChartYAxis *leftAxis = _barChartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.drawAxisLineEnabled = YES;
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.gridLineWidth = .3;

    ChartYAxis *rightAxis = _barChartView.rightAxis;
    rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
    rightAxis.drawAxisLineEnabled = YES;
    rightAxis.drawGridLinesEnabled = NO;
    
    [_barChartView animateWithYAxisDuration:2.5];
    
     
    
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
