//
//  UptimeController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/11/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "UptimeController.h"
#import "SWRevealViewController.h"
#import "requestUtility.h"

@interface UptimeController ()

@end

@implementation UptimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil GETRequestSender:@"getRPM" completion:^(NSDictionary *responseDict){
        NSLog(@"%@", responseDict);
    }];

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:11.0f]};
    [self.segmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    self.segmentedControl.selectedSegmentIndex = 0;
    NSDate *dateToday = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-6];
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:dateToday options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
    NSString *stringDateToday = [dateFormatter stringFromDate:dateToday];
    NSString *stringDateSixDaysAgo = [dateFormatter stringFromDate:sevenDaysAgo];
    NSLog(@"%@", stringDateToday);
    NSLog(@"%@", stringDateSixDaysAgo);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
