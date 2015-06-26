//
//  RPMController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/14/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "RPMController.h"
#import "SWRevealViewController.h"
#import "requestUtility.h"
#import "Data.h"
#import "DownPicker.h"
#import "UptimeController.h"
#import "SpeedTestController.h"

@interface RPMController ()

@end

@implementation RPMController
{
    NSMutableArray *sp;
    NSMutableArray *hb;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //requestUtility *reqUtil = [[requestUtility alloc] init];
    //[reqUtil GETRequestSender:@"getRPM" withParams:apId completion:^(NSDictionary* responseDict){
    
   // }];
    hb = [[NSMutableArray alloc] init];
    sp = [[NSMutableArray alloc] init];
    self.downPicker = [[DownPicker alloc] initWithTextField:self.apTextField withData:apNames];
    [self.downPicker addTarget:self
                        action:@selector(apSelected:)
              forControlEvents:UIControlEventValueChanged];
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    self.activityIndicatorContainer.hidden = true;
    self.speedtestContainer.hidden = false;
    self.uptimeContainer.hidden = true;

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


- (IBAction)indexChanged:(id)sender {
    
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
            self.speedtestContainer.hidden = false;
            self.uptimeContainer.hidden = true;
            break;
        case 1:
            self.speedtestContainer.hidden = true;
            self.uptimeContainer.hidden = false;
            break;
        default:
            break;
            
    }
    
}
-(void)apSelected:(id)ap {
    if(self.segmentedControl.selectedSegmentIndex == 0){
        self.speedtestContainer.hidden = true;
        self.activityIndicatorContainer.hidden = false;
    } else if(self.segmentedControl.selectedSegmentIndex == 1){
        self.uptimeContainer.hidden = true;
        self.activityIndicatorContainer.hidden = false;
    }
    NSString *selectedValue = [self.downPicker text];
    NSLog(@"%@", selectedValue);
    NSUInteger selected_index = [apNames indexOfObject:selectedValue];
    NSString *selected_apId = [Data getIdForAPAtIndex:selected_index];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil GETRequestSender:@"getRPM" withParams:selected_apId completion:^(NSDictionary* responseDict){
        NSLog(@"******** %@", responseDict);
        SpeedTestController *spC = [self.childViewControllers objectAtIndex:0];
        SpeedTestController *hbC = [self.childViewControllers objectAtIndex:1];
        sp = responseDict[@"speed"];
        if([sp count] == 0 ){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 [self alertLoginError];
             }];
        }else {
            [Data setRPM:sp andHeartbeats:hb];
            [spC beginCharting:sp.count];
        }
        hb = responseDict[@"heartbeats"];
        if([hb count] == 0 ){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 [self alertLoginError];
             }];
        } else {
            [Data setRPM:sp andHeartbeats:hb];
            [hbC beginCharting:hb.count];
        }

        
        
        
     }];
}
- (void)alertLoginError{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Empty Data"
                                  message:@"No data available."
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
