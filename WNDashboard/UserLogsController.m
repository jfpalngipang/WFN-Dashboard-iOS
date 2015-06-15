//
//  UserLogsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/10/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "UserLogsController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"
#import "DownPicker.h"
#import "UserLogsCell.h"


@interface UserLogsController () {
    NSMutableArray *_ap_list;
    NSMutableArray *logs;
    NSDate *today;
}

@end

@implementation UserLogsController

- (void)viewDidLoad {
    [super viewDidLoad];
    today = [[NSDate alloc] init];
    logs = [[NSMutableArray alloc] init];
    _ap_list = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil GETRequestSender:@"getAPList" completion:^(NSDictionary* responseDict){
        
        for(id ap in responseDict){
            [_ap_list addObject:ap[1]];
        }
        //NSLog(@"Picker Items: %@", _ap_list);
        self.downPicker = [[DownPicker alloc] initWithTextField:self.APListTextField withData:_ap_list];

    }];
    [reqUtil GETRequestSender:@"getUserLogs" withParams: @"06/02/15" completion:^(NSDictionary* logsDict){
       
        for (id log in logsDict){
           [logs addObject:log];
        }
        
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        NSLog(@"%@", logs);
        //NSLog(@"%@", today);
    }];
    
    

    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
      
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
*/

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return logs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UserLogsCell *cell = (UserLogsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserLogsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLabel.text = [logs objectAtIndex:indexPath.row][@"user"];

    cell.startLabel.text = [logs objectAtIndex:indexPath.row][@"time_start"];
    cell.totalLabel.text = [logs objectAtIndex:indexPath.row][@"total_mins"];
    return cell;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
