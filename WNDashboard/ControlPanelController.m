//
//  ControlPanelController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "ControlPanelController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"

@implementation ControlPanelController
{
    NSMutableArray *ap_list;
    NSMutableArray *dd_array;
    NSMutableDictionary *ap_dict;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    ap_list = [[NSMutableArray alloc] init];
    ap_dict = [[NSMutableDictionary alloc] init];
    
    [reqUtil GETRequestSender:@"getAPList" completion:^(NSDictionary* responseDict){
        //NSLog(@"AP Settings: %@", responseDict);
        for (id ap in responseDict){
            [ap_list addObject:ap[1]];
        }
        NSLog(@"%@", ap_list);
    }];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
    
}

@end
