//
//  SurveyDetailsController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/16/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyDetailsController : UIViewController
{
    NSMutableArray *responses;
    NSMutableArray *responseCounts;
    NSArray *responseAPList;
    
}
@property (weak, nonatomic) IBOutlet UILabel *surveyLabel;
@property (weak, nonatomic) IBOutlet UIView *pieChartContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *apListContainer;

@property (nonatomic, strong) NSString *surveyQuestion;
@property (nonatomic, strong) NSMutableArray *responses;
@property (nonatomic, strong) NSMutableArray *responseCounts;
@property (nonatomic, strong) NSArray *responseAPList;
- (IBAction)indexChanged:(id)sender;

@end
