//
//  RPMController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/14/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "RPMController.h"
#import "SWRevealViewController.h"
#import "requestUtility.h"
#import "Data.h"
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
    
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    //requestUtility *reqUtil = [[requestUtility alloc] init];
    //[reqUtil GETRequestSender:@"getRPM" withParams:apId completion:^(NSDictionary* responseDict){
    
   // }];
    
    self.apTextField.delegate = self;
    hb = [[NSMutableArray alloc] init];
    sp = [[NSMutableArray alloc] init];

    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    self.apTextField.text = apNames[0];
    NSUInteger selected_index = [apNames indexOfObject:apNames[0]];
    NSString *selected_apId = [Data getIdForAPAtIndex:selected_index];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil getData:@"rpm" withParams:selected_apId completion:^(NSDictionary * responseDict){

        sp = responseDict[@"speed"];
        hb = responseDict[@"heartbeats"];

        SpeedTestController *spC = [self.childViewControllers objectAtIndex:2];
        UptimeController *hbC = [self.childViewControllers objectAtIndex:0];

        
        [hbC.beatsData removeAllObjects];
        [spC.speedData removeAllObjects];
        
        for(id beat in hb){
            [hbC.beatsData addObject:beat[1]];
        }
        
        for(id speed in sp){
            [spC.speedData addObject:speed[1]];
        }
        
        [spC beginCharting];
        [hbC beginCharting];
    }];

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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DateSelectionController *selectModal = [storyboard instantiateViewControllerWithIdentifier:@"DateSelectionController"];
    selectModal.selectMode = @"ap";
    selectModal.myDelegate = self;
    [selectModal setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:selectModal animated:YES completion:nil];
    return NO;
}


- (void)modalViewDismissed:(NSString *)value withSelectMode:(NSString *)mode{
    self.apTextField.text = value;
    self.activityIndicatorContainer.hidden = false;
    self.speedtestContainer.hidden = true;
    self.uptimeContainer.hidden = true;
    NSUInteger selected_index = [apNames indexOfObject:value];
    NSString *selected_apId = [Data getIdForAPAtIndex:selected_index];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    //NSLog(@"%@ : %@", selected_apId, value);
    self.segmentedControl.selectedSegmentIndex = 0;
    [reqUtil getData:@"rpm" withParams:selected_apId completion:^(NSDictionary * responseDict){
        //NSLog(@"********%@", responseDict);
        sp = responseDict[@"speed"];
        hb = responseDict[@"heartbeats"];
        //NSLog(@"1. put data in hb array : %@", hb);
        SpeedTestController *spC = [self.childViewControllers objectAtIndex:2];
        UptimeController *hbC = [self.childViewControllers objectAtIndex:0];
        //NSLog(@"2. make instance oh Uptime Controller");
        
        [hbC.beatsData removeAllObjects];
        [spC.speedData removeAllObjects];
        
        for(id beat in hb){
            [hbC.beatsData addObject:beat[1]];
        }
        
        for(id speed in sp){
            [spC.speedData addObject:speed[1]];
        }
    
        [spC beginCharting];
        [hbC beginCharting];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.speedtestContainer.hidden = false;
            self.uptimeContainer.hidden = false;
            self.activityIndicatorContainer.hidden = true;
        });


  /*
        if(self.segmentedControl.selectedSegmentIndex == 0){
            if(sp.count == 0){
                [self alertEmptyError:@"speed"];
            }
        }else{
            if(hb.count == 0){
                [self alertEmptyError:@"uptime"];
            }
        }
   */
        //NSLog(@"4. copy to char data of hbC %@", hbC.chartData);
    }];
    //NSLog(@"4. copy to char data of hbC %@", hbC.chartData);
}
/*
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
            NSLog(@"*******%@", sp);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 [self alertEmptyError];
             }];
            
        }else {
            [Data setRPM:sp andHeartbeats:hb];
            [spC beginCharting:sp.count];
        }
        hb = responseDict[@"heartbeats"];
        if([hb count] == 0 ){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 [self alertEmptyError];
             }];
        } else {
            [Data setRPM:sp andHeartbeats:hb];
            [hbC beginCharting:hb.count];
        }

        
        
        
     }];
}
 */
- (void)alertEmptyError:(NSString *)type{
    NSString *alertFor = [[NSString alloc] init];
    if([type isEqualToString:@"speed"]){
        alertFor = @"No Speed Test Data Available";
    }else if([type isEqualToString:@"uptime"]){
        alertFor = @"No Uptime Data Available";
    }
    if ([UIAlertController class]){
        UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:alertFor
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
    }else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:alertFor
                                                          message:@"No Data Available"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}
@end
