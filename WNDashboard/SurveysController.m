//
//  SurveysController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "SurveysController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"

@implementation SurveysController
{
    NSMutableArray *survey_array;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil GETRequestSender:@"getSurveys" completion:^(NSDictionary* responseDict){
        NSLog(@"SURVEYS: %@", responseDict);
    
    }];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }

}


@end
