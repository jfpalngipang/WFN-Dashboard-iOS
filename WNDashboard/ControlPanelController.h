//
//  ControlPanelController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/18/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"
#import "DateSelectionController.h"

@interface ControlPanelController : UIViewController <UITextFieldDelegate, modalDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITextField *apTextField;
@property (weak, nonatomic) IBOutlet UITextField *ssidTextField;
@property (weak, nonatomic) IBOutlet UISwitch *maxdownloadSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *maxsessionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *passkeySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fbpageSwitch;
@property (weak, nonatomic) IBOutlet UITextField *passkeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *fbpageTextField;
@property (weak, nonatomic) IBOutlet UISwitch *privatessidSwitch;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (strong, nonatomic) DownPicker *downPicker;
- (IBAction)updateClicked:(id)sender;
- (IBAction)max_download:(id)sender;
- (IBAction)max_time:(id)sender;
- (IBAction)passkey:(id)sender;
- (IBAction)ap_page:(id)sender;
- (IBAction)private_ssid:(id)sender;
- (IBAction)passkey_changed:(id)sender;
- (IBAction)ssid_changed:(id)sender;
- (IBAction)ap_page_changed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *maxdownloadTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxsessionTextField;

- (IBAction)max_download_changed:(id)sender;
- (IBAction)max_session_changed:(id)sender;


@end
