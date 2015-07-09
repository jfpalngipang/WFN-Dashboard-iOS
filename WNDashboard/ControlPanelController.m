//
//  ControlPanelController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/18/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "ControlPanelController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"

#import "Data.h"
#import "DateSelectionController.h"

@interface ControlPanelController ()

@end

@implementation ControlPanelController
{

    NSMutableArray *apSettings;
    NSMutableArray *dd_array;
    NSMutableDictionary *ap_dict;
    requestUtility *reqUtil;
    NSMutableDictionary *settings;
    NSMutableArray *settingsArr;
    NSString *sAP;
    NSString *sID;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    sAP = [[NSString alloc] init];
    sID = [[NSString alloc] init];
    settings = [[NSMutableDictionary alloc] init];
    settingsArr = [[NSMutableArray alloc] init];
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    reqUtil = [[requestUtility alloc] init];
    //NSLog(@"APDATA: %@", apNames);
    //ap_list = [[NSMutableArray alloc] init];
    //apId_list = [[NSMutableArray alloc] init];
    apSettings = [[NSMutableArray alloc] init];
    ap_dict = [[NSMutableDictionary alloc] init];
    self.apTextField.text = @"";
    self.ssidTextField.text = @"";
    self.passkeyTextField.text = @"";
    self.fbpageTextField.text = @"";
    self.apTextField.delegate = self;
    
    
    [reqUtil getData:@"apsettings" completion:^(NSDictionary *responseDict){
        //NSLog(@"AP Settings: %@", responseDict[@"response"]);
    
        for (id ap in responseDict[@"response"]){
            //[ap_list addObject:ap[@"ap"]];
            //[apId_list addObject:ap[@"id"]];
            [apSettings addObject:ap[@"settings"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.downPicker = [[DownPicker alloc] initWithTextField:self.apTextField withData:apNames];
            /*
            [self.downPicker addTarget:self
                                action:@selector(apSelected:)
                      forControlEvents:UIControlEventValueChanged];
             */
            self.apTextField.text = apNames[0];
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
    NSString *selectedAP = self.apTextField.text;
    NSUInteger selected_index = [apNames indexOfObject:selectedAP];
    //NSLog(@"%@", apSettings[selected_index]);
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
            self.passkeyTextField.text = @"";
        } else{
            [self.passkeySwitch setOn:YES animated:YES];
            self.passkeyTextField.text = ap_auth;
        }
        
        
        if([ap_like_page isEqualToString: @"<null>"]){
            [self.fbpageSwitch setOn:NO animated:YES];
            self.fbpageTextField.text = @"";
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
    NSUInteger selected_index = [apNames indexOfObject:apNames[0]];
    sID = [Data getIdForAPAtIndex:selected_index];
    sAP = apNames[0];
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
            self.maxdownloadTextField.hidden = true;
        } else {
            [self.maxdownloadSwitch setOn:YES animated:YES];
            self.maxdownloadTextField.text = max_down;
            self.maxdownloadTextField.hidden = false;
            self.maxdownloadTextField.text = max_down;
        }
        
        if([max_time isEqualToString:@"<null>"]){
            [self.maxsessionSwitch setOn:NO animated:YES];
            self.maxsessionTextField.hidden = true;
        } else {
            [self.maxsessionSwitch setOn:YES animated:YES];
            self.maxsessionTextField.text = max_time;
            self.maxsessionTextField.hidden = false;
            self.maxsessionTextField.text = max_time;
            
        }
        
        if([ap_auth isEqualToString:@"<null>"]){
            [self.passkeySwitch setOn:NO animated:YES];
            self.passkeyTextField.text = @"";
            self.passkeyTextField.hidden = true;
        } else{
            [self.passkeySwitch setOn:YES animated:YES];
            self.passkeyTextField.text = ap_auth;
            self.passkeyTextField.hidden = false;
            self.passkeyTextField.text = ap_auth;
        }
        
        
        if([ap_like_page isEqualToString: @"<null>"]){
            [self.fbpageSwitch setOn:NO animated:YES];
            self.fbpageTextField.text = @"";
            self.fbpageTextField.hidden = true;
        } else{
            [self.fbpageSwitch setOn:YES animated:NO];
            self.fbpageTextField.text = ap_like_page;
            self.fbpageTextField.hidden = false;
            self.fbpageTextField.text = ap_like_page;
            
        }
        if([ssid_private isEqualToString: @"<null>"]){
            [self.privatessidSwitch setOn:NO animated:YES];
        } else{
            [self.privatessidSwitch setOn:YES animated:NO];
        }
         
        
    });
    
}
/*
-(void)apSelected:(id)ap{
    NSString *selectedAP = [self.downPicker text];
    sAP = selectedAP;
    NSUInteger selected_index = [apNames indexOfObject:selectedAP];
    sID = [Data getIdForAPAtIndex:selected_index];
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
            self.maxdownloadTextField.hidden = true;
        } else {
            [self.maxdownloadSwitch setOn:YES animated:YES];
            self.maxdownloadTextField.text = max_down;
            self.maxdownloadTextField.hidden = false;
        }
        
        if([max_time isEqualToString:@"<null>"]){
            [self.maxsessionSwitch setOn:NO animated:YES];
            self.maxsessionTextField.hidden = true;
        } else {
            [self.maxsessionSwitch setOn:YES animated:YES];
            self.maxsessionTextField.text = max_time;
            self.maxsessionTextField.hidden = false;
            
        }
        
        if([ap_auth isEqualToString:@"<null>"]){
            [self.passkeySwitch setOn:NO animated:YES];
            self.passkeyTextField.text = @"";
            self.passkeyTextField.hidden = true;
        } else{
            [self.passkeySwitch setOn:YES animated:YES];
            self.passkeyTextField.text = ap_auth;
            self.passkeyTextField.hidden = false;
        }
        
        
        if([ap_like_page isEqualToString: @"<null>"]){
            [self.fbpageSwitch setOn:NO animated:YES];
            self.fbpageTextField.text = @"";
            self.fbpageTextField.hidden = true;
        } else{
            [self.fbpageSwitch setOn:YES animated:NO];
            self.fbpageTextField.text = ap_like_page;
            self.fbpageTextField.hidden = false;
            
        }
        if([ssid_private isEqualToString: @"<null>"]){
            [self.privatessidSwitch setOn:NO animated:YES];
        } else{
            [self.privatessidSwitch setOn:YES animated:NO];
        }
        
        
    });
    
}
*/
- (IBAction)updateClicked:(id)sender {
    
    [settings setValue:[NSString stringWithFormat:@"%@", sID] forKey:@"id"];
    [settings setValue:settingsArr forKey:@"settings"];
    
    NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    [setting setValue:@"ssid" forKey:@"name"];
    [setting setValue:self.ssidTextField.text forKey:@"value"];
    [settingsArr addObject:setting];
    
    //PASSKEY
    if([self.passkeySwitch isOn]){
        NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
        [setting setValue:@"ap_auth" forKey:@"name"];
        [setting setValue:self.passkeyTextField.text forKey:@"value"];
        [settingsArr addObject:setting];
        
    }else{
        NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
        [setting setValue:@"ap_auth" forKey:@"name"];
        [setting setValue:@"" forKey:@"value"];
        [settingsArr addObject:setting];
    }
    //FB PAGE
    if([self.fbpageSwitch isOn]){
        NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
        [setting setValue:@"ap_like_page" forKey:@"name"];
        [setting setValue:self.fbpageTextField.text forKey:@"value"];
        [settingsArr addObject:setting];
        
    }else{
        NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
        [setting setValue:@"ap_like_page" forKey:@"name"];
        [setting setValue:@"" forKey:@"value"];
        [settingsArr addObject:setting];
    }
    //MAX DOWNLOAD
    if([self.maxdownloadSwitch isOn]){
        NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
        [setting setValue:@"max_down" forKey:@"name"];
        [setting setValue:self.maxdownloadTextField.text forKey:@"value"];
        [settingsArr addObject:setting];
        
    }else{
        NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
        [setting setValue:@"max_down" forKey:@"name"];
        [setting setValue:@"" forKey:@"value"];
        [settingsArr addObject:setting];
    }
    
    //MAX SESSION
    if([self.maxsessionSwitch isOn]){
        NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
        [setting setValue:@"max_time" forKey:@"name"];
        [setting setValue:self.maxsessionTextField.text forKey:@"value"];
        [settingsArr addObject:setting];
        
    }else{
        NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
        [setting setValue:@"max_time" forKey:@"name"];
        [setting setValue:@"" forKey:@"value"];
        [settingsArr addObject:setting];
    }


    //NSLog(@"SETTINGS: %@", settings);
    
    [reqUtil postControlPanelUpdate:settings completion:^(NSString *statusCode){
        //NSLog(@"STATUS CODE FOR CONTROL PANEL UPDATE: %@", statusCode);
        if([statusCode isEqualToString:@"200"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertSuccess];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertError];
            });
        }
    }];
     
}
- (void)alertError{
    if([UIAlertController class]){
        UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error"
                                  message:@"Could not update"
                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Dismiss"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
        [alert addAction:ok];
    
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Could not update"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }

}

- (void)alertSuccess{
    if([UIAlertController class]){
        UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Success"
                                  message:@"Settings Updated"
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
        
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success"
                                                              message:@"Settings Updated"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];
    }

}

- (IBAction)max_download:(id)sender {
    //NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    if([self.maxdownloadSwitch isOn]){
        self.maxdownloadTextField.hidden = false;
        
    }else{
        self.maxdownloadTextField.hidden = true;
    }
    
}

- (IBAction)max_time:(id)sender {
    //NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    if([self.maxsessionSwitch isOn]){
        self.maxsessionTextField.hidden = false;
    }else{
        self.maxsessionTextField.hidden = true;
    }
}

- (IBAction)passkey:(id)sender {
    //NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    if([self.passkeySwitch isOn]){
        self.passkeyTextField.hidden = false;
        
    }else{
        self.passkeyTextField.hidden = true;
    }
}

- (IBAction)ap_page:(id)sender {
    
    if([self.fbpageSwitch isOn]){
        self.fbpageTextField.hidden = false;

    }else{
        self.fbpageTextField.hidden = true;
    }
}

- (IBAction)private_ssid:(id)sender {
}

- (IBAction)passkey_changed:(id)sender {

}

- (IBAction)ssid_changed:(id)sender {
   
}

- (IBAction)ap_page_changed:(id)sender {
    
}
- (IBAction)max_download_changed:(id)sender {
    
}

- (IBAction)max_session_changed:(id)sender {
    }
@end
