//
//  SurveyDetailsViewController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/16/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

@interface SurveyDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet PieChartView *pieChartView;
@property (nonatomic, strong) NSMutableArray *responses;
@property (nonatomic, strong) NSMutableArray *responseCounts;


- (void)beginCharting;
@end
