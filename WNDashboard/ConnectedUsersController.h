//
//  ConnectedUsersController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/11/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

@interface ConnectedUsersController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;

- (void)beginCharting;

@property (strong, nonatomic) NSMutableArray *a;
@end
