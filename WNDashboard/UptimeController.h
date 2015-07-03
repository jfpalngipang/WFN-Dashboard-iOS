//
//  UptimeController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/11/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

@interface UptimeController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;
- (IBAction)segmentChanged:(id)sender;
- (void)beginCharting;
- (void)addToData:(NSString *)data;
@property(strong, nonatomic) NSMutableArray *beatsData;
@end
