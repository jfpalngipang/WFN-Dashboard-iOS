//
//  SurveyDetailsViewController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/16/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "SurveyDetailsViewController.h"
#import "WNDashboard-Bridging-Header.h"
#import "requestUtility.h"
#import <Charts/Charts.h>
#import "SurveyDetailsController.h"

@interface SurveyDetailsViewController () <ChartViewDelegate>

@end


@implementation SurveyDetailsViewController
{
    NSMutableArray *valuesForChart;
    NSString *surveyId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"R: %@", self.responses);
    // Do any additional setup after loading the view.
    //requestUtility *reqUtil = [[requestUtility alloc] init];
    /*
    [reqUtil GETRequestSender:@"getSurveyDetails" withParams:surveyId completion:^(NSDictionary *responseDict){
        NSLog(@"%@", responseDict);
    }];
    */
    
    _pieChartView.delegate = self;
    
    _pieChartView.usePercentValuesEnabled = YES;
    _pieChartView.holeTransparent = YES;
    _pieChartView.centerTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    _pieChartView.holeRadiusPercent = 0.58;
    _pieChartView.transparentCircleRadiusPercent = 0.61;
    _pieChartView.descriptionText = @"";
    _pieChartView.drawCenterTextEnabled = YES;
    _pieChartView.drawHoleEnabled = YES;
    _pieChartView.rotationAngle = 0.0;
    _pieChartView.rotationEnabled = YES;
    _pieChartView.centerText = @"Survey Details Chart";
    
    ChartLegend *l = _pieChartView.legend;
    l.position = ChartLegendPositionRightOfChart;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    [_pieChartView animateWithXAxisDuration:1.5 yAxisDuration:1.5 easingOption:ChartEasingOptionEaseOutBack];

    
    
}

- (void)beginCharting{
    UIViewController *parent = self.parentViewController;
    NSLog(@"^^^^^^PARENT^^^^^: %@", parent);
    [self setDataCount:(int)((SurveyDetailsController *)parent).responseCounts.count range:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataCount:(int)count range:(double)range{
    //double mult = range;
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    UIViewController *parent = self.parentViewController;
    for (int i = 0; i < count; i++)
    {
    
        int val = [((SurveyDetailsController *)parent).responseCounts[i] doubleValue];//[self.parentViewController.responseCounts[i] doubleValue];
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    //NSArray *test = [[NSArray alloc] initWithObjects:@"10",@"35",@"20",@"8",@"12", nil];
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:((SurveyDetailsController *)parent).responses[i]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@"Survey Details"];
    dataSet.sliceSpace = 3.0;
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    _pieChartView.data = data;
    [_pieChartView highlightValues:nil];
    ((SurveyDetailsController *)parent).responseCounts = nil;
    ((SurveyDetailsController *)parent).responses = nil;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

@end
