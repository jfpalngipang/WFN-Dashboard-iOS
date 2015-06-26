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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    chartData = [[NSMutableArray alloc] init];
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
    
    _lineChartView.highlightEnabled = NO;
    _lineChartView.dragEnabled = NO;
    _lineChartView.pinchZoomEnabled = NO;
    _lineChartView.drawGridBackgroundEnabled = NO;
    
    ChartYAxis *leftAxis = _lineChartView.leftAxis;
    leftAxis.customAxisMax = 1;
    leftAxis.customAxisMin = 0;
    leftAxis.startAtZeroEnabled = YES;
    //leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _lineChartView.rightAxis.enabled = NO;
    _lineChartView.legend.form = ChartLegendFormLine;
    
    [_lineChartView animateWithXAxisDuration:3.5 easingOption:ChartEasingOptionEaseInOutQuart];

    
    
    
}

- (void)setDataCount: (int)count range: (double)range{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double val = 1.2;
        
        if([chartData[i] isEqualToString:@"0"]){
            val = 0.1;
        } else {
            val = 0.1;
        }
        
        //NSLog(@"BEAT: %@", chartData[i]);
        //double mult = (range + 1);
        //double val = (double) (arc4random_uniform(mult)) + 3;
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"Router Uptime"];
    
    set1.lineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.orangeColor];
    //[set1 setCircleColor:UIColor.blackColor];

    set1.lineWidth = 1.0;
    set1.circleRadius = 0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.orangeColor;
    
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
        case 0:
            beats = [NSString stringWithFormat:@"%@", heartbeats[6][1]];
            
            for(int i = 0; i < [beats length]; i++){
                temp = [NSString stringWithFormat:@"%C", [beats characterAtIndex:i]];
                [chartData addObject:temp];
            }
             
            NSLog(@"BEATS %@", chartData);
            //chartData = heartbeats[6][1];
            [self setDataCount:10 range:1];
            break;
        case 1:
            beats = [NSString stringWithFormat:@"%@", heartbeats[5][1]];
            for(int i = 0; i < [beats length]; i++){
                temp = [NSString stringWithFormat:@"%C", [beats characterAtIndex:i]];
                [chartData addObject:temp];
            }
            NSLog(@"BEATS %@", beats);
            break;
        case 2:
            beats = [NSString stringWithFormat:@"%@", heartbeats[4][1]];
            for(int i = 0; i < [beats length]; i++){
                temp = [NSString stringWithFormat:@"%C", [beats characterAtIndex:i]];
                [chartData addObject:temp];
            }
            NSLog(@"BEATS %@", beats);
            break;
        case 3:
            beats = [NSString stringWithFormat:@"%@", heartbeats[3][1]];
            for(int i = 0; i < [beats length]; i++){
                temp = [NSString stringWithFormat:@"%C", [beats characterAtIndex:i]];
                [chartData addObject:temp];
            }
            NSLog(@"BEATS %@", beats);
            break;
        case 4:
            beats = [NSString stringWithFormat:@"%@", heartbeats[2][1]];
            for(int i = 0; i < [beats length]; i++){
                temp = [NSString stringWithFormat:@"%C", [beats characterAtIndex:i]];
                [chartData addObject:temp];
            }
            NSLog(@"BEATS %@", beats);
            break;
        case 5:
            beats = [NSString stringWithFormat:@"%@", heartbeats[1][1]];
            for(int i = 0; i < [beats length]; i++){
                temp = [NSString stringWithFormat:@"%C", [beats characterAtIndex:i]];
                [chartData addObject:temp];
            }
            NSLog(@"BEATS %@", beats);
            break;
        case 6:
            beats = [NSString stringWithFormat:@"%@", heartbeats[0][1]];
            for(int i = 0; i < [beats length]; i++){
                temp = [NSString stringWithFormat:@"%C", [beats characterAtIndex:i]];
                [chartData addObject:temp];
            }
            NSLog(@"BEATS %@", beats);
            break;
    }
}
- (void)beginCharting:(int)size {
    NSLog(@"CHARTING..........");
    [self setDataCount:size range:1];
    
    
    
}
@end
