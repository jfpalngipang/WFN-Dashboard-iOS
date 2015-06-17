//
//  SurveyDetailsController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/16/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyDetailsController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *surveyLabel;
@property (weak, nonatomic) IBOutlet UIView *pieChartContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)indexChanged:(id)sender;

@end
