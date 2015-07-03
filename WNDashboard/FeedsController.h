//
//  FeedsController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedsController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLSessionDataDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)fetchFeedUpdateWithCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler;
@property (weak, nonatomic) IBOutlet UIView *activityIndicatorContainer;
- (IBAction)frontViewTap:(id)sender;

@end
