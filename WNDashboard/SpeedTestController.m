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
#import "Data.h"


@interface SpeedTestController () <ChartViewDelegate>

@end

@implementation SpeedTestController{
    NSMutableArray *labels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    labels = [[NSMutableArray alloc] init];
    NSDate *dateToday = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    for(int i = 2; i >=0; i--){
        [dateComponents setDay:-i];
        NSDate *DaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dateToday options:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd"];
        NSString *stringDaysAgo = [dateFormatter stringFromDate:DaysAgo];
        [labels addObject:stringDaysAgo];
        
    }
    
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil GETRequestSender:@"getRPM" completion:^(NSDictionary *responseDict){
        NSLog(@"%@", responseDict);
    }];
    
    
    _lineChartView.delegate = self;
    
    _lineChartView.descriptionText = @"";
 
    
    _lineChartView.highlightEnabled = YES;
    _lineChartView.dragEnabled = YES;
    [_lineChartView setScaleEnabled:YES];
    _lineChartView.pinchZoomEnabled = NO;
    _lineChartView.drawGridBackgroundEnabled = YES;
    
    _lineChartView.xAxis.enabled = YES;
    _lineChartView.leftAxis.enabled = YES;
    _lineChartView.rightAxis.enabled = NO;
    _lineChartView.legend.enabled = NO;
    
    [_lineChartView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
    
    [self setDataCount:3 range:1];
    //NSLog(@"SPEEDS: %@", speed);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataCount:(int)count range:(double)range{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];

    for (int i = 0; i < count; i++){
        [xVals addObject:labels[i]];
    }
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    if(count == 0){
        /*
        for (int i = 0; i < 3; i++){
            int val = 0;
            [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];

        }
         */
    } else {
        for (int i = 0; i < count; i++)
        {
            double val = (double)[speed[i][1] doubleValue];
            //double mult = (range + 1);
            //double val = (double) (arc4random_uniform(mult)) + 20;
            [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
        }
    }
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals1 label:@"Speedtest"];
    set1.lineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.orangeColor];
    //[set1 setCircleColor:UIColor.blackColor];
    
    set1.lineWidth = 2.0;
    set1.circleRadius = 0.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:8.f];
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.orangeColor;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    _lineChartView.data = data;
    
}

- (void)beginCharting:(int)size {
    NSLog(@"CHARTING..........");
        [self setDataCount:size range:1];
    
    
    
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
