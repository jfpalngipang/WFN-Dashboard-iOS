//
//  AnalyticsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "AnalyticsController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"

@implementation AnalyticsController
NSMutableArray *active = nil;
NSMutableArray *males = nil;
NSMutableArray *females = nil;
NSMutableArray *others = nil;
-(void)viewDidLoad {
    [super viewDidLoad];
    self.connectedusersContainer.hidden = true;
    self.agegenderContainer.hidden = true;
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil GETRequestSender:@"getAnalytics" completion:^(NSDictionary *responseDict){
        
        active = responseDict[@"active"];
        females = responseDict[@"agegender"][@"f"];
        males = responseDict[@"agegender"][@"m"];
        others = responseDict[@"agegender"][@"o"];
        self.connectedusersContainer.hidden = false;
        self.agegenderContainer.hidden = true;
    }];
    
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
}

- (IBAction)segmentChanged:(id)sender {
    switch (self.segmentControl.selectedSegmentIndex){
        case 0:
            self.connectedusersContainer.hidden = false;
            self.agegenderContainer.hidden = true;
            break;
        case 1:
            self.connectedusersContainer.hidden = true;
            self.agegenderContainer.hidden = false;
            break;
        default:
            break;
    }
}
@end
