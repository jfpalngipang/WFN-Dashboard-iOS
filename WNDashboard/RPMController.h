//
//  RPMController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/14/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"
#import "DateSelectionController.h"

@interface RPMController : UIViewController <modalDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *uptimeContainer;

@property (weak, nonatomic) IBOutlet UIView *speedtestContainer;
@property (weak, nonatomic) IBOutlet UITextField *apTextField;

@property (weak, nonatomic) IBOutlet UIView *activityIndicatorContainer;


- (IBAction)indexChanged:(id)sender;




@end
