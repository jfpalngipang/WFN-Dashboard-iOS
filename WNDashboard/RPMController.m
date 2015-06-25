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

@interface RPMController ()

@end

@implementation RPMController

- (void)viewDidLoad {
    [super viewDidLoad];
    //requestUtility *reqUtil = [[requestUtility alloc] init];
    //[reqUtil GETRequestSender:@"getRPM" withParams:apId completion:^(NSDictionary* responseDict){
    
   // }];
    
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
    NSString *selectedValue = [self.downPicker text];
    NSLog(@"%@", selectedValue);
}

@end
