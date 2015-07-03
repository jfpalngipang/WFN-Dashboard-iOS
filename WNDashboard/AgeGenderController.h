//
//  AgeGenderController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/11/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

@interface AgeGenderController : UIViewController


@property (weak, nonatomic) IBOutlet HorizontalBarChartView *barChartView;

@property (strong, nonatomic) NSMutableArray *f;
@property (strong, nonatomic) NSMutableArray *m;
@property (strong, nonatomic) NSMutableArray *o;

- (void)beginCharting;
@end
