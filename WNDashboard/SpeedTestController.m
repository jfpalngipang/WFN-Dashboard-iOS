//
//  SpeedTestController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/11/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "SpeedTestController.h"
#import "WNDashboard-Bridging-Header.h"
#import "requestUtility.h"
#import "Data.h"


@interface SpeedTestController () <ChartViewDelegate>

@end

@implementation SpeedTestController{
    NSMutableArray *labels;
    NSMutableArray *chartData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    labels = [[NSMutableArray alloc] init];
    chartData = [[NSMutableArray alloc] init];
    self.speedData = [[NSMutableArray alloc] init];

    

 
    _lineChartView.delegate = self;
    _lineChartView.descriptionText = @"Speedtest";
    _lineChartView.highlightEnabled = NO;
    _lineChartView.dragEnabled = NO;
    _lineChartView.pinchZoomEnabled = NO;
    _lineChartView.drawGridBackgroundEnabled = NO;
    _lineChartView.doubleTapToZoomEnabled = NO;
    _lineChartView.xAxis.enabled = YES;
    _lineChartView.leftAxis.enabled = YES;
    _lineChartView.rightAxis.enabled = NO;
    _lineChartView.legend.enabled = YES;
    _lineChartView.leftAxis.startAtZeroEnabled = YES;

    

    
    [_lineChartView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
    
    //[self setDataCount:3 range:1];
    //NSLog(@"SPEEDS: %@", speed);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataCount:(int)count range:(double)range{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSDate *dateToday = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    for(int i = 6; i >=0; i--){
        [dateComponents setDay:-i];
        NSDate *DaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dateToday options:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd"];
        NSString *stringDaysAgo = [dateFormatter stringFromDate:DaysAgo];
        [xVals addObject:stringDaysAgo];
        //NSLog(@"LABELS: %@", xVals);
        
    }
    //xVals = labels;
    
    /*
    for (int i = 0; i < count; i++){
        [xVals addObject:labels[i]];
    }
     */
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    if(chartData.count == 0){
        /*
        for (int i = 0; i < 3; i++){
            int val = 0;
            [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];

        }
         */
    } else {
        for (int i = 0; i < count; i++)
        {
            double val = (double)[chartData[i] doubleValue];
            [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
        }
    }
    
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals1 label:@"Speedtest"];
    set1.lineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.blueColor];
    
    set1.lineWidth = 2.0;
    set1.circleRadius = 0.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:8.f];
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.orangeColor;
    set1.drawValuesEnabled = NO;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    _lineChartView.data = data;
    });
    
}

- (void)beginCharting{
    //NSLog(@"CHARTING..........");
    chartData = self.speedData;
    
    if(chartData.count < 7){
        for(int i = 0; i <= (7 - chartData.count); i++){
            [chartData addObject:@"0"];
        }
    }
    //NSLog(@"%@", chartData);
    
    [self setDataCount:(int)chartData.count range:1];
    
    
    
}

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    //NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    //NSLog(@"chartValueNothingSelected");
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
