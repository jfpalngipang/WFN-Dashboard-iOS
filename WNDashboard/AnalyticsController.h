//
//  AnalyticsController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateSelectionController.h"


@interface AnalyticsController : UIViewController <UITextFieldDelegate, modalDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *connectedusersContainer;
@property (weak, nonatomic) IBOutlet UIView *agegenderContainer;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *apTextField;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
- (IBAction)goClicked:(id)sender;

@end
