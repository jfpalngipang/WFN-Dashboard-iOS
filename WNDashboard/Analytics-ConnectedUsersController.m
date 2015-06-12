//
//  Analytics-ConnectedUsersController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "Analytics-ConnectedUsersController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"


@implementation Analytics_ConnectedUsersController
-(void)viewDidLoad {
    [super viewDidLoad];
    
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil GETRequestSender:@"getAnalytics" completion:^(NSDictionary *responseDict){
        NSLog(@"ANALYTICS: %@", responseDict);
    }];
       
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }

}

@end
