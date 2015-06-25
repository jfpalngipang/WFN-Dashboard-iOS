//
//  SurveysController.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/9/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SurveysController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *currentPageLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPageLabel;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)nextClicked:(id)sender;
- (IBAction)prevClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
