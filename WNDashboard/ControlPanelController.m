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
    NSMutableArray *ap_array;
    NSMutableArray *dd_array;
    NSMutableDictionary *ap_dict;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    ap_array = [[NSMutableArray alloc] init];
    ap_dict = [[NSMutableDictionary alloc] init];
    
    [reqUtil GETRequestSender:@"getAPList" completion:^(NSDictionary* responseDict){
        //NSLog(@"AP Settings: %@", responseDict);
        for (id ap in responseDict){
            //[ap_array addObject:ap];
            //NSLog(@"AP Array: %@", ap[0]);
            //NSLog(@"AP Array: %@", ap[1]);
            
            [ap_dict setValue:ap[0] forKey:@"id"];
            [ap_dict setValue:ap[1] forKey:@"ap"];
            
            
        }
    }];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
    NSLog(@"%@", ap_dict);
}

@end
