//
//  AnalyticsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "AnalyticsController.h"
#import "CorePlot-CocoaTouch.h"
#import "requestUtility.h"

@implementation AnalyticsController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil GETRequestSender:@"getAnalytics" completion:^(NSDictionary *responseDict){
        NSLog(@"ANALYTICS: %@", responseDict);
    }];
    
}

@end
