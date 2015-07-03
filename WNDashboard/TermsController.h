//
//  TermsController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/18/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
