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

@implementation SpeedTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    _lineChartView.drawGridBackgroundEnabled = NO;
    
    _lineChartView.xAxis.enabled = YES;
    _lineChartView.leftAxis.enabled = NO;
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
    NSMutableArray *xVals = [[NSMutableArray alloc] initWithObjects: @"Jun 17", @"Jun 18", @"Jun 19", @"Jun 20", nil];
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        int val = [speed[i][1] doubleValue];
        //double mult = (range + 1);
        //double val = (double) (arc4random_uniform(mult)) + 20;
        [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals1 label:@"Speedtest"];
    set1.drawCubicEnabled = YES;
    set1.cubicIntensity = 0.3;
    set1.drawCirclesEnabled = NO;
    set1.lineWidth = 2.0;
    set1.circleRadius = 5.0;
    set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
    [set1 setColor:[UIColor colorWithRed:104/255.f green:241/255.f blue:175/255.f alpha:1.f]];
    set1.fillColor = [UIColor orangeColor];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSet:set1];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9.f]];
    [data setDrawValues:NO];
    
    _lineChartView.data = data;
    
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
