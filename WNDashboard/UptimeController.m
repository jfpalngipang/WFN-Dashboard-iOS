//
//  UptimeController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/11/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
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
    NSMutableArray *chartData;
    NSString *beats;
    NSString *temp;
    NSMutableArray *hbArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    chartData = [[NSMutableArray alloc] init];
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
    
    ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:4.0 label:@"Low Heartbeats"];
    ll1.lineWidth = 2.0;
    ll1.lineColor = [UIColor redColor];
    ll1.lineDashLengths = @[@5.f, @5.f];
    ll1.labelPosition = ChartLimitLabelPositionRight;
    ll1.valueFont = [UIFont systemFontOfSize:8.0];
    
    ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:8.0 label:@"Average Heartbeats"];
    ll2.lineWidth = 2.0;
    ll2.lineColor = [UIColor yellowColor];
    ll2.lineDashLengths = @[@5.f, @5.f];
    ll2.labelPosition = ChartLimitLabelPositionRight;
    ll2.valueFont = [UIFont systemFontOfSize:8.0];
    
    ChartLimitLine *ll3 = [[ChartLimitLine alloc] initWithLimit:12.0 label:@"High Heartbeats"];
    ll3.lineWidth = 2.0;
    ll3.lineColor = [UIColor greenColor];
    ll3.lineDashLengths = @[@5.f, @5.f];
    ll3.labelPosition = ChartLimitLabelPositionRight;
    ll3.valueFont = [UIFont systemFontOfSize:8.0];
    
    ChartYAxis *leftAxis = _lineChartView.leftAxis;
    leftAxis.customAxisMax = 13.0f;
    leftAxis.customAxisMin = 0.0f;
    leftAxis.startAtZeroEnabled = YES;
    //leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = NO;
    [leftAxis addLimitLine:ll1];
    [leftAxis addLimitLine:ll2];
    [leftAxis addLimitLine:ll3];

    
    _lineChartView.rightAxis.enabled = NO;
    _lineChartView.legend.form = ChartLegendFormLine;
    
    [_lineChartView animateWithXAxisDuration:3.5 easingOption:ChartEasingOptionEaseInOutQuart];

    
    
    
}

- (void)setDataCount: (int)count range: (double)range{
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
        //NSLog(@"VAL ********* :%f", val);
        
        if([chartData[i] isEqualToString:@"0"]){
            val = 0.01;
        } else {
            val = (double)[chartData[i] doubleValue];
        }
        
        //NSLog(@"BEAT: %@", chartData[i]);
        //double mult = (range + 1);
        //double val = (double) (arc4random_uniform(mult)) + 3;
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"Router Uptime"];
    
    //set1.lineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.orangeColor];
    //[set1 setCircleColor:UIColor.blackColor];

    set1.lineWidth = 2.0;
    set1.circleRadius = 0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.greenColor;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    _lineChartView.data = data;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentChanged:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex){
        case 0:{
            [hbArray removeAllObjects];
            [chartData removeAllObjects];
            beats = [NSString stringWithFormat:@"%@", heartbeats[6][1]];
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
            //[self setDataCount:chartData.count range:1];
            break;
        }

        case 1:{
            [hbArray removeAllObjects];
            [chartData removeAllObjects];
            beats = [NSString stringWithFormat:@"%@", heartbeats[5][1]];
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
            beats = [NSString stringWithFormat:@"%@", heartbeats[4][1]];

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
            beats = [NSString stringWithFormat:@"%@", heartbeats[3][1]];

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
            beats = [NSString stringWithFormat:@"%@", heartbeats[2][1]];

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
            beats = [NSString stringWithFormat:@"%@", heartbeats[1][1]];

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
            beats = [NSString stringWithFormat:@"%@", heartbeats[0][1]];

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
- (void)beginCharting:(int)size {
    NSLog(@"CHARTING..........");
    [self setDataCount:size range:1];
    
    
    
}
@end
