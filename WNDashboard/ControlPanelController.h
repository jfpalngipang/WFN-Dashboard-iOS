//
//  ControlPanelController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/18/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"

@interface ControlPanelController : UIViewController
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

@end
