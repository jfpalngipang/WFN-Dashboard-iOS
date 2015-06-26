//
//  SurveyCell.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/12/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

@interface SurveyCell : UITableViewCell <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *surveyResultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *surveyImage;
@property (weak, nonatomic) IBOutlet PieChartView *pieChartView;

@end
