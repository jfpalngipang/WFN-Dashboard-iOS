//
//  ControlPanelController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/18/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "ControlPanelController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"
#import "DownPicker.h"

@interface ControlPanelController ()

@end

@implementation ControlPanelController
{
    NSMutableArray *ap_list;
    NSMutableArray *apId_list;
    NSMutableArray *apSettings;
    NSMutableArray *dd_array;
    NSMutableDictionary *ap_dict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    ap_list = [[NSMutableArray alloc] init];
    apId_list = [[NSMutableArray alloc] init];
    apSettings = [[NSMutableArray alloc] init];
    ap_dict = [[NSMutableDictionary alloc] init];
    self.apTextField.text = @"";
    self.ssidTextField.text = @"";
    self.passkeyTextField.text = @"";
    self.fbpageTextField.text = @"";
    
    
    [reqUtil GETRequestSender:@"getAPSettings" completion:^(NSDictionary* responseDict){
        //NSLog(@"AP Settings: %@", responseDict[@"response"]);
    
        for (id ap in responseDict[@"response"]){
            [ap_list addObject:ap[@"ap"]];
            [apId_list addObject:ap[@"id"]];
            [apSettings addObject:ap[@"settings"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.downPicker = [[DownPicker alloc] initWithTextField:self.apTextField withData:ap_list];
            [self.downPicker addTarget:self
                                action:@selector(apSelected:)
                      forControlEvents:UIControlEventValueChanged];
            self.apTextField.text = ap_list[0];
        [self showSettings];
        });
    }];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    

    // Do any additional setup after loading the view.
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
-(void)showSettings
{
    //NSString *ssid = [NSString stringWithFormat:@"%@",ap_list[0][@"settings"][@"ssid"]];
    //[self.apTextField setText:ap_list[0][@"ap"]];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *max_down = [NSString stringWithFormat:@"%@", apSettings[0][@"max_down"]];
        NSString *max_time = [NSString stringWithFormat:@"%@", apSettings[0][@"max_time"]];
        NSString *ap_auth = [NSString stringWithFormat:@"%@", apSettings[0][@"ap_auth"]];
        NSString *ap_like_page = [NSString stringWithFormat:@"%@", apSettings[0][@"ap_like_page"]];
        NSString *ssid_private = [NSString stringWithFormat:@"%@", apSettings[0][@"ssid_private"]];
        self.ssidTextField.text = apSettings[0][@"ssid"];
        
        //[self.apTextField setText:ap_list[0][@"ap"]];
        if([max_down isEqualToString:@"<null>"]){
            [self.maxdownloadSwitch setOn:NO animated:YES];
        } else {
            [self.maxdownloadSwitch setOn:YES animated:YES];
        }
        
        if([max_time isEqualToString:@"<null>"]){
            [self.maxsessionSwitch setOn:NO animated:YES];
        } else {
            [self.maxsessionSwitch setOn:YES animated:YES];
            
        }
        
        if([ap_auth isEqualToString:@"<null>"]){
            [self.passkeySwitch setOn:NO animated:YES];
            self.passkeyTextField.text = @"";
        } else{
            [self.passkeySwitch setOn:YES animated:YES];
            self.passkeyTextField.text = ap_auth;
        }
        
        
        if([ap_like_page isEqualToString: @"<null>"]){
            [self.fbpageSwitch setOn:NO animated:YES];
        } else{
            [self.fbpageSwitch setOn:YES animated:NO];
            self.fbpageTextField.text = ap_like_page;
            
        }
        if([ssid_private isEqualToString: @"<null>"]){
            [self.privatessidSwitch setOn:NO animated:YES];
        } else{
            [self.privatessidSwitch setOn:YES animated:NO];
        }
         
        
    });
    
}

-(void)apSelected:(id)ap{
    NSString *selectedAP = [self.downPicker text];
    int selected_index = [ap_list indexOfObject:selectedAP];
    NSLog(@"%@", apSettings[selected_index]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *max_down = [NSString stringWithFormat:@"%@", apSettings[selected_index][@"max_down"]];
        NSString *max_time = [NSString stringWithFormat:@"%@", apSettings[selected_index][@"max_time"]];
        NSString *ap_auth = [NSString stringWithFormat:@"%@", apSettings[selected_index][@"ap_auth"]];
        NSString *ap_like_page = [NSString stringWithFormat:@"%@", apSettings[selected_index][@"ap_like_page"]];
        NSString *ssid_private = [NSString stringWithFormat:@"%@", apSettings[selected_index][@"ssid_private"]];
        self.ssidTextField.text = apSettings[selected_index][@"ssid"];
        
        //[self.apTextField setText:ap_list[0][@"ap"]];
        if([max_down isEqualToString:@"<null>"]){
            [self.maxdownloadSwitch setOn:NO animated:YES];
        } else {
            [self.maxdownloadSwitch setOn:YES animated:YES];
        }
        
        if([max_time isEqualToString:@"<null>"]){
            [self.maxsessionSwitch setOn:NO animated:YES];
        } else {
            [self.maxsessionSwitch setOn:YES animated:YES];
            
        }
        
        if([ap_auth isEqualToString:@"<null>"]){
            [self.passkeySwitch setOn:NO animated:YES];
        } else{
            [self.passkeySwitch setOn:YES animated:YES];
            self.passkeyTextField.text = ap_auth;
        }
        
        
        if([ap_like_page isEqualToString: @"<null>"]){
            [self.fbpageSwitch setOn:NO animated:YES];
        } else{
            [self.fbpageSwitch setOn:YES animated:NO];
            self.fbpageTextField.text = ap_like_page;
            
        }
        if([ssid_private isEqualToString: @"<null>"]){
            [self.privatessidSwitch setOn:NO animated:YES];
        } else{
            [self.privatessidSwitch setOn:YES animated:NO];
        }
        
        
    });
    
}

@end
