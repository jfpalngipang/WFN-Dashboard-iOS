//
//  ConnectedUsersController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/11/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "ConnectedUsersController.h"
#import "SWRevealViewController.h"
#import "Data.h"
#import "WNDashboard-Bridging-Header.h"

@interface ConnectedUsersController () <ChartViewDelegate>

@end

@implementation ConnectedUsersController
{
    ChartYAxis *leftAxis;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.a = [[NSMutableArray alloc] init];
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    // Do any additional setup after loading the view.
    
    _lineChartView.delegate = self;
    
    _lineChartView.highlightEnabled = YES;
    _lineChartView.dragEnabled = NO;
    _lineChartView.pinchZoomEnabled = NO;
    _lineChartView.drawGridBackgroundEnabled = YES;
    
    leftAxis = _lineChartView.leftAxis;
    leftAxis.customAxisMax = 20;
    leftAxis.customAxisMin = 0;
    leftAxis.startAtZeroEnabled = YES;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _lineChartView.rightAxis.enabled = NO;
    _lineChartView.legend.form = ChartLegendFormLine;
    
    [_lineChartView animateWithXAxisDuration:3.5 easingOption:ChartEasingOptionEaseInOutQuart];
    self.a = active;
    [self setDataCount:self.a.count range:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataCount: (int)count range: (double)range{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    
     
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        NSString *valStr = [NSString stringWithFormat:@"%@", self.a[i]];
        double val;
        if([valStr isEqualToString:@"0"]){
            val = 0.1;
        }else {
            val = (double)[valStr doubleValue];
        }
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"Connected Users"];
    
    set1.lineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.orangeColor];
    [set1 setCircleColor:UIColor.blackColor];
    set1.lineWidth = 2.0;
    set1.circleRadius = 0.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.orangeColor;
    set1.drawValuesEnabled = NO;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    _lineChartView.data = data;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)beginCharting{
    NSLog(@"CHARTING..........");
    [self setDataCount:self.a.count range:1];
    
    
}

@end
