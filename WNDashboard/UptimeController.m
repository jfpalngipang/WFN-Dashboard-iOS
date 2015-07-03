//
//  UptimeController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/11/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "UptimeController.h"
#import "SWRevealViewController.h"
#import "requestUtility.h"
#import "Data.h"
#import "WNDashboard-Bridging-Header.h"

@interface UptimeController () <ChartViewDelegate>

@end

@implementation UptimeController
{

    NSString *beats;
    NSString *temp;
    NSMutableArray *hbArray;
    NSMutableArray *chartData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentedControl.selectedSegmentIndex = 0;
    chartData = [[NSMutableArray alloc] init];
    self.beatsData = [[NSMutableArray alloc] init];
    hbArray = [[NSMutableArray alloc] init];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil GETRequestSender:@"getRPM" completion:^(NSDictionary *responseDict){
        NSLog(@"%@", responseDict);
    }];

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:11.0f]};
    [self.segmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    //self.segmentedControl.selectedSegmentIndex = 0;
    NSDate *dateToday = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    for(int i = 6; i >=0; i--){
        [dateComponents setDay:-i];
        NSDate *DaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dateToday options:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd"];
        NSString *stringDaysAgo = [dateFormatter stringFromDate:DaysAgo];
        //NSLog(@"%@", stringDaysAgo);
        [self.segmentedControl setTitle:stringDaysAgo forSegmentAtIndex:i];
    }
    
    _lineChartView.delegate = self;
    _lineChartView.descriptionText = @"Heartbeats";
    _lineChartView.highlightEnabled = NO;
    _lineChartView.dragEnabled = NO;
    _lineChartView.pinchZoomEnabled = NO;
    _lineChartView.drawGridBackgroundEnabled = NO;
    _lineChartView.doubleTapToZoomEnabled = NO;
    
    ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:6.0 label:@"Weak"];
    ll1.lineWidth = 2.0;
    ll1.lineColor = [UIColor redColor];
    ll1.lineDashLengths = @[@6.f, @2.f];
    ll1.labelPosition = ChartLimitLabelPositionRight;
    ll1.valueFont = [UIFont systemFontOfSize:8.0];
    
    ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:8.0 label:@"Moderate"];
    ll2.lineWidth = 2.0;
    ll2.lineColor = [UIColor orangeColor];
    ll2.lineDashLengths = @[@6.f, @2.f];
    ll2.labelPosition = ChartLimitLabelPositionRight;
    ll2.valueFont = [UIFont systemFontOfSize:8.0];
    
    ChartLimitLine *ll3 = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Strong"];
    ll3.lineWidth = 2.0;
    ll3.lineColor = [UIColor yellowColor];
    ll3.lineDashLengths = @[@6.f, @2.f];
    ll3.labelPosition = ChartLimitLabelPositionRight;
    ll3.valueFont = [UIFont systemFontOfSize:8.0];
    
    ChartLimitLine *ll4 = [[ChartLimitLine alloc] initWithLimit:12.2 label:@"Excellent"];
    ll4.lineWidth = 2.0;
    ll4.lineColor = [UIColor greenColor];
    ll4.lineDashLengths = @[@6.f, @2.f];
    ll4.labelPosition = ChartLimitLabelPositionRight;
    ll4.valueFont = [UIFont systemFontOfSize:8.0];
    
    ChartYAxis *leftAxis = _lineChartView.leftAxis;
    leftAxis.customAxisMax = 13.0f;
    leftAxis.customAxisMin = 0.0f;
    leftAxis.startAtZeroEnabled = YES;
    //leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = NO;
    
    [leftAxis addLimitLine:ll1];
    [leftAxis addLimitLine:ll2];
    [leftAxis addLimitLine:ll3];
    [leftAxis addLimitLine:ll4];

    
    _lineChartView.rightAxis.enabled = NO;
    _lineChartView.legend.form = ChartLegendFormLine;
    
    [_lineChartView animateWithXAxisDuration:3.5 easingOption:ChartEasingOptionEaseInOutQuart];

    
    
    
}

- (void)setDataCount: (int)count range: (double)range{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableArray *xVals = [[NSMutableArray alloc] initWithObjects:@"12AM",@"1AM",@"2AM",@"3AM",@"4AM", @"5AM", @"6AM", @"7AM", @"8AM", @"9AM", @"10AM", @"11AM",@"12PM", @"1PM",@"2PM",@"3PM",@"4PM", @"5PM", @"6PM", @"7PM", @"8PM", @"9PM", @"10PM", @"11PM", nil];
    
    /*
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    */
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double val; //(double)[@"0" doubleValue];

        if([chartData[i] isEqualToString:@"0"]){
            val = 0.01;
        } else {
            val = (double)[chartData[i] doubleValue];
        }

        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"Router Uptime"];
    

    [set1 setColor:UIColor.blueColor];

    set1.lineWidth = 2.0;
    set1.circleRadius = 0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.greenColor;
    set1.drawValuesEnabled = NO;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    _lineChartView.data = data;
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addToData:(NSString *)data{
    [chartData addObject:data];
    NSLog(@"CHART: hihi: %@", chartData);
}
- (IBAction)segmentChanged:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex){
        case 0:{
            [hbArray removeAllObjects];
            [chartData removeAllObjects];
            beats = [NSString stringWithFormat:@"%@", self.beatsData[6]];
            NSLog(@"BEATS: %@", beats);
            
            NSString *dayHeartbeats;
            for(int i = 0; i < 288; i+=12){
                NSRange range = NSMakeRange(i, 12);
                dayHeartbeats = [beats substringWithRange:range];
                [hbArray addObject:dayHeartbeats];
                
                
            }
            NSLog(@"********** %@", hbArray);
            for (NSString *heart in hbArray){
                int ones = [[heart componentsSeparatedByString:@"1"] count] - 1;
                [chartData addObject:[NSString stringWithFormat:@"%d", ones]];
            }
            [self setDataCount:chartData.count range:1];
            break;
        }

        case 1:{
            [hbArray removeAllObjects];
            [chartData removeAllObjects];
            beats = [NSString stringWithFormat:@"%@", self.beatsData[5]];
            NSString *dayHeartbeats;
            for(int i = 0; i < 288; i+=12){
                NSRange range = NSMakeRange(i, 12);
                dayHeartbeats = [beats substringWithRange:range];
                [hbArray addObject:dayHeartbeats];
                
                
            }
            NSLog(@"********** %@", hbArray);
            for (NSString *heart in hbArray){
                int ones = [[heart componentsSeparatedByString:@"1"] count] - 1;
                [chartData addObject:[NSString stringWithFormat:@"%d", ones]];
            }
            [self setDataCount:chartData.count range:1];
            break;
        }
        case 2:{
            [hbArray removeAllObjects];
            [chartData removeAllObjects];
            beats = [NSString stringWithFormat:@"%@", self.beatsData[4]];

            NSString *dayHeartbeats;
            for(int i = 0; i < 288; i+=12){
                NSRange range = NSMakeRange(i, 12);
                dayHeartbeats = [beats substringWithRange:range];
                [hbArray addObject:dayHeartbeats];
                
                
            }
            NSLog(@"********** %@", hbArray);
            for (NSString *heart in hbArray){
                int ones = [[heart componentsSeparatedByString:@"1"] count] - 1;
                [chartData addObject:[NSString stringWithFormat:@"%d", ones]];
            }
            [self setDataCount:chartData.count range:1];
            break;
        }
        case 3:{
            [hbArray removeAllObjects];
            [chartData removeAllObjects];
            beats = [NSString stringWithFormat:@"%@", self.beatsData[3]];

            NSString *dayHeartbeats;
            for(int i = 0; i < 288; i+=12){
                NSRange range = NSMakeRange(i, 12);
                dayHeartbeats = [beats substringWithRange:range];
                [hbArray addObject:dayHeartbeats];
                
                
            }
            NSLog(@"********** %@", hbArray);
            for (NSString *heart in hbArray){
                int ones = [[heart componentsSeparatedByString:@"1"] count] - 1;
                [chartData addObject:[NSString stringWithFormat:@"%d", ones]];
            }
            [self setDataCount:chartData.count range:1];
            break;
        }
        case 4:{
            [hbArray removeAllObjects];
            [chartData removeAllObjects];
            beats = [NSString stringWithFormat:@"%@", self.beatsData[2]];

            NSString *dayHeartbeats;
            for(int i = 0; i < 288; i+=12){
                NSRange range = NSMakeRange(i, 12);
                dayHeartbeats = [beats substringWithRange:range];
                [hbArray addObject:dayHeartbeats];
                
                
            }
            NSLog(@"********** %@", hbArray);
            for (NSString *heart in hbArray){
                int ones = [[heart componentsSeparatedByString:@"1"] count] - 1;
                [chartData addObject:[NSString stringWithFormat:@"%d", ones]];
            }
            [self setDataCount:chartData.count range:1];
            break;
        }
        case 5:{
            [hbArray removeAllObjects];
            [chartData removeAllObjects];
            beats = [NSString stringWithFormat:@"%@", self.beatsData[1]];

            NSString *dayHeartbeats;
            for(int i = 0; i < 288; i+=12){
                NSRange range = NSMakeRange(i, 12);
                dayHeartbeats = [beats substringWithRange:range];
                [hbArray addObject:dayHeartbeats];
                
                
            }
            NSLog(@"********** %@", hbArray);
            for (NSString *heart in hbArray){
                int ones = [[heart componentsSeparatedByString:@"1"] count] - 1;
                [chartData addObject:[NSString stringWithFormat:@"%d", ones]];
            }
            [self setDataCount:chartData.count range:1];
            break;
        }
        case 6:
            [hbArray removeAllObjects];
            [chartData removeAllObjects];
            beats = [NSString stringWithFormat:@"%@", self.beatsData[0]];

            NSString *dayHeartbeats;
            for(int i = 0; i < 288; i+=12){
                NSRange range = NSMakeRange(i, 12);
                dayHeartbeats = [beats substringWithRange:range];
                [hbArray addObject:dayHeartbeats];
                
                
            }
            NSLog(@"********** %@", hbArray);
            for (NSString *heart in hbArray){
                int ones = [[heart componentsSeparatedByString:@"1"] count] - 1;
                [chartData addObject:[NSString stringWithFormat:@"%d", ones]];
            }
            [self setDataCount:chartData.count range:1];
            break;
    }
}
- (void)beginCharting{
    NSLog(@"CHARTING..........");
    
    beats = [NSString stringWithFormat:@"%@", self.beatsData[6]];
    [chartData removeAllObjects];
    NSString *dayHeartbeats;
    for(int i = 0; i < 288; i+=12){
        NSRange range = NSMakeRange(i, 12);
        dayHeartbeats = [beats substringWithRange:range];
        [hbArray addObject:dayHeartbeats];
        
        
    }
    for (NSString *heart in hbArray){
        int ones = [[heart componentsSeparatedByString:@"1"] count] - 1;
        [chartData addObject:[NSString stringWithFormat:@"%d", ones]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setDataCount:chartData.count range:1];
        self.segmentedControl.selectedSegmentIndex = 0;
    });
    
    
    
}

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}
@end
