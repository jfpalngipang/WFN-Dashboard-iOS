//
//  AgeGenderController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/11/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.f = [[NSMutableArray alloc] init];
    self.m = [[NSMutableArray alloc] init];
    self.o = [[NSMutableArray alloc] init];
    self.f = females;
    self.m = males;
    self.o = others;
    
    self.title = @"Age/Gender Distribution";

    
    _barChartView.delegate = self;
    _barChartView.highlightEnabled = NO;

    _barChartView.descriptionText = @"";
    _barChartView.noDataTextDescription = @"You need to provide data for the chart.";

    _barChartView.drawBarShadowEnabled = NO;
    _barChartView.drawValueAboveBarEnabled = NO;
    [_barChartView setScaleEnabled:NO];
    _barChartView.maxVisibleValueCount = 60;
    _barChartView.pinchZoomEnabled = NO;
    _barChartView.doubleTapToZoomEnabled = NO;
    _barChartView.drawGridBackgroundEnabled = NO;
    ChartXAxis *xAxis = _barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.labelTextColor = [UIColor blackColor];
    xAxis.drawAxisLineEnabled = YES;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.gridLineWidth = .3;
    xAxis.gridColor = [UIColor blackColor];
    ChartYAxis *leftAxis = _barChartView.leftAxis;
    leftAxis.labelTextColor = [UIColor blackColor];
    leftAxis.gridColor = [UIColor blackColor];
    ChartYAxis *rightAxis = _barChartView.rightAxis;
    rightAxis.labelTextColor = [UIColor blackColor];
    rightAxis.gridColor = [UIColor blackColor];
    rightAxis.customAxisMax = 10;
    rightAxis.customAxisMin = 0;
    leftAxis.customAxisMax = 10;
    leftAxis.customAxisMin = 0;

    _barChartView.legend.position = ChartLegendPositionBelowChartLeft;
    _barChartView.legend.form = ChartLegendFormSquare;
    _barChartView.legend.formSize = 8.0;
    _barChartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    _barChartView.legend.xEntrySpace = 4.0;
    _barChartView.legend.textColor = [UIColor blackColor];
    [_barChartView animateWithYAxisDuration:2.5];
    
    [self setDataCount:(int)self.m.count range:10];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setDataCount:(int)count range:(double)range {
    dispatch_async(dispatch_get_main_queue(), ^{
    NSArray *xVals = [[NSMutableArray alloc] init];
    xVals = [[NSArray alloc] initWithObjects:@"14&below", @"15-19", @"20-24", @"24-29", @"30-34", @"35-39", @"40-44", @"45-49", @"50-54", @"55-59", @"60&above", nil];

    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals3 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double val;
        NSString *valStr = [NSString stringWithFormat:@"%@", self.m[i]];
        if([valStr isEqualToString:@"0"]){
            val = 0.1;
        }else {
            val = (double)[valStr doubleValue];
        }
        
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
        
        valStr = [NSString stringWithFormat:@"%@", self.f[i]];
        if([valStr isEqualToString:@"0"]){
            val = 0.1;
        }else {
            val = (double)[valStr doubleValue];
        }
        [yVals2 addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
        
        valStr = [NSString stringWithFormat:@"%@", self.o[i]];
        if([valStr isEqualToString:@"0"]){
            val = 0.1;
        }else {
            val = (double)[valStr doubleValue];
        }
        [yVals3 addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals1 label:@"males"];
    [set1 setColor:[UIColor redColor]];
    BarChartDataSet *set2 = [[BarChartDataSet alloc] initWithYVals:yVals2 label:@"females"];
    [set2 setColor:[UIColor blueColor]];
    BarChartDataSet *set3 = [[BarChartDataSet alloc] initWithYVals:yVals3 label:@"other"];
    [set3 setColor:[UIColor greenColor]];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    [dataSets addObject:set3];
    set1.drawValuesEnabled = NO;
    set2.drawValuesEnabled = NO;
    set3.drawValuesEnabled = NO;
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    _barChartView.data = data;
    });
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    //NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    //NSLog(@"chartValueNothingSelected");
}

- (void)beginCharting{
    //NSLog(@"CHARTING..........");
    [self setDataCount:(int)self.m.count range:1];
    //NSLog(@"MALES: %@", self.m);
    
    
}


@end
