//
//  AgeGenderController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/11/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "AgeGenderController.h"
#import "SWRevealViewController.h"
#import "WNDashboard-Bridging-Header.h"
#import "requestUtility.h"
#import "Data.h"

@interface AgeGenderController () <ChartViewDelegate>


@end

@implementation AgeGenderController
{
    NSMutableArray *f;
    NSMutableArray *m;
    NSMutableArray *o;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    f = [[NSMutableArray alloc] init];
    m = [[NSMutableArray alloc] init];
    o = [[NSMutableArray alloc] init];
    
    //NSLog(@"%@", males);
    
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil GETRequestSender:@"getAnalytics" completion:^(NSDictionary *responseDict){
        //NSLog(@"ANALYTICS: %@", responseDict[@"agegender"]);
        f = responseDict[@"agegender"][@"f"];
        m = responseDict[@"agegender"][@"m"];
        o = responseDict[@"agegender"][@"o"];
    }];
    
    
    // Do any additional setup after loading the view.

    self.title = @"Age/Gender Distribution";

    
    _barChartView.delegate = self;
    
    _barChartView.descriptionText = @"";
    _barChartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    _barChartView.drawBarShadowEnabled = NO;
    _barChartView.drawValueAboveBarEnabled = YES;
    
    _barChartView.maxVisibleValueCount = 60;
    _barChartView.pinchZoomEnabled = NO;
    _barChartView.drawGridBackgroundEnabled = NO;
    
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
    
    _barChartView.legend.position = ChartLegendPositionBelowChartLeft;
    _barChartView.legend.form = ChartLegendFormSquare;
    _barChartView.legend.formSize = 8.0;
    _barChartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    _barChartView.legend.xEntrySpace = 4.0;
    
    [_barChartView animateWithYAxisDuration:2.5];
    
    [self setDataCount:11 range:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataCount:(int)count range:(double)range {
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSArray *testX = [[NSArray alloc] initWithObjects:@"14&below", @"15-19", @"20-24", @"24-29", @"30-34", @"35-39", @"40-44", @"45-49", @"50-54", @"55-59", @"60&above", nil];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject: testX[i]];
    }
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        
        int val = [males[i] doubleValue];
        //double mult = (range + 1);
        //double val = (double) (arc4random_uniform(mult));
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
        //NSLog(@"double value: %d", val2);
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"Dataset"];
    set1.barSpace = 0.35;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    _barChartView.data = data;

}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
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
