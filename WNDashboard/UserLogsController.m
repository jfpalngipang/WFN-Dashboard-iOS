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
#import "Data.h"


@interface UserLogsController () {
    NSMutableArray *_ap_list;
    NSMutableArray *logs;
    NSDate *today;
    UIDatePicker *datePickerView;
    NSArray *searchResults;
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
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
    headerLabel.text = NSLocalizedString(@"name     device  start time  total time", @"");
    headerLabel.backgroundColor = [UIColor orangeColor];
    [header addSubview:headerLabel];
    
    
    //self.tableView.tableHeaderView = header;
    //[reqUtil GETRequestSender:@"getAPList" completion:^(NSDictionary* responseDict){
      /*
        for(id ap in responseDict){
            [_ap_list addObject:ap[1]];
        }
       */
        //NSLog(@"Picker Items: %@", _ap_list);
        self.downPicker = [[DownPicker alloc] initWithTextField:self.APListTextField withData:apNames];
        [self.downPicker addTarget:self
                                action:@selector(apSelected:)
                      forControlEvents:UIControlEventValueChanged];

   // }];
    [reqUtil GETRequestSender:@"getUserLogs" withParams: @"06/02/15" completion:^(NSDictionary* logsDict){
        
        for (id log in logsDict){
           [logs addObject:log];
        }
        
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
        //NSLog(@"%@", logs);
    }];
    
    //Get date today
    
    

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
    /*
    if(indexPath.row == 0){
        cell.nameLabel.text = @"User";
        
        cell.startLabel.text = @"Start Time";
        cell.totalLabel.text = @"Total Time";
    }
    */
    NSString* firstLetter = [[logs objectAtIndex:indexPath.row][@"device"] substringToIndex:1];
    if([firstLetter isEqualToString:@"A"]){
        cell.deviceImage.image = [UIImage imageNamed:@"and.png"];
    } else if([firstLetter isEqualToString:@"i"] || [firstLetter isEqualToString:@"M"] ){
        cell.deviceImage.image = [UIImage imageNamed:@"ios.png"];
    } else if([firstLetter isEqualToString:@"W"]){
        cell.deviceImage.image = [UIImage imageNamed:@"win.png"];
    }
    
    //cell.deviceImage.image = [UIImage imageNamed:@"and.png"];
    cell.nameLabel.text = [logs objectAtIndex:indexPath.row][@"user"];

    cell.startLabel.text = [logs objectAtIndex:indexPath.row][@"time_start"];
    cell.totalLabel.text = [logs objectAtIndex:indexPath.row][@"total_mins"];
    
    return cell;
    
}

-(void)apSelected:(id)ap {
    NSString *selectedValue = [self.downPicker text];
    NSLog(@"%@", selectedValue);
}




- (IBAction)dateTextFieldEditing:(UITextField *)sender {
    datePickerView = [[UIDatePicker alloc] init];
    datePickerView.datePickerMode = UIDatePickerModeDate;
    sender.inputView = datePickerView;
    [datePickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)datePickerValueChanged:(UIDatePicker*) sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSString *stringFromDate = [dateFormatter stringFromDate:sender.date];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dateTextField.text = stringFromDate;
    });
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [logs filteredArrayUsingPredicate:resultPredicate];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

@end
