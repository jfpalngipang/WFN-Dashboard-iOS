//
//  RPMController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "RPMController.h"
#import "requestUtility.h"

@implementation RPMController

- (void)viewDidLoad {
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil GETRequestSender:@"getRPM" completion:^(NSDictionary* responseDict){
        NSLog(@"RPM: %@", responseDict);
    }];
}

@end
