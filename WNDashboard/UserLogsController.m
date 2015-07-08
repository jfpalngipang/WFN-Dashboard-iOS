//
//  UserLogsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/10/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import "UserLogsController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"
#import "UserLogsCell.h"
#import "Data.h"
#import "DateSelectionController.h"


@interface UserLogsController () <UISearchBarDelegate>
{
    NSMutableArray *_ap_list;
    NSMutableArray *logs;
    NSMutableArray *logsCopy;
    NSMutableArray *filteredLogs;
    UIDatePicker *datePickerView;
    NSArray *searchResults;
    NSString *accessoryMode;
    NSMutableArray *searches;
}

@end

@implementation UserLogsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.disableView.hidden = false;
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    filteredLogs = [[NSMutableArray alloc] init];
    searches = [[NSMutableArray alloc] init];
    accessoryMode = [[NSString alloc] init];
    logs = [[NSMutableArray alloc] init];
    logsCopy = [[NSMutableArray alloc] init];
    _ap_list = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    requestUtility *reqUtil = [[requestUtility alloc] init];

    self.dateTextField.delegate = self;
    self.APListTextField.delegate = self;
    
    self.dateTextField.text = today;
    self.APListTextField.text = apNames[0];
    
    self.tableView.hidden = true;
    self.activityIndicatorContainer.hidden = false;
    
    [reqUtil getData:@"userlogs" completion:^(NSDictionary *logsDict){
        
        for (id log in logsDict){
            [logs addObject:log];
            [logsCopy addObject:log];
        }
        self.tableView.hidden = false;
        self.disableView.hidden = true;
        self.activityIndicatorContainer.hidden = true;
        if(logs.count == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertEmptyData];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            });

        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            });
        }

    }];
    
    
    

    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
      
}
- (void)alertEmptyData{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Empty Data"
                                  message:@"No data available."
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    } else {
        return logs.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.rowHeight = 60;
    static NSString *identifier = @"Cell";
    
    if (indexPath.row == 0){
        UserLogsCell *cell = (UserLogsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserLogsCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor orangeColor];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.startLabel.textColor = [UIColor whiteColor];
        cell.totalLabel.textColor = [UIColor whiteColor];
        cell.deviceLabel.textColor = [UIColor whiteColor];
        cell.nameLabel.textAlignment = NSTextAlignmentCenter;
        cell.nameLabel.text = @"Name";
        cell.deviceImage.image = nil;
        cell.deviceLabel.text = @"Device";
        cell.startLabel.text = @"Start";
        cell.totalLabel.text = @"Total";
        return cell;
    } else {
        UserLogsCell *cell = (UserLogsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserLogsCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
    
        if (tableView == self.searchDisplayController.searchResultsTableView){
            NSString* firstLetter = [[searchResults objectAtIndex:indexPath.row][@"device"] substringToIndex:1];
            if([firstLetter isEqualToString:@"A"]){
                cell.deviceImage.image = [UIImage imageNamed:@"and.png"];
            } else if([firstLetter isEqualToString:@"i"] || [firstLetter isEqualToString:@"M"] ){
                cell.deviceImage.image = [UIImage imageNamed:@"ios.png"];
            } else if([firstLetter isEqualToString:@"W"]){
                cell.deviceImage.image = [UIImage imageNamed:@"win.png"];
            } else if([firstLetter isEqualToString:@"o"]){
                cell.deviceImage.image = [UIImage imageNamed:@"unk.png"];
            }

            cell.nameLabel.text = [searchResults objectAtIndex:indexPath.row][@"user"];
            cell.deviceLabel.text = nil;
            cell.startLabel.text = [searchResults objectAtIndex:indexPath.row][@"time_start"];
            cell.totalLabel.text = [searchResults objectAtIndex:indexPath.row][@"total_mins"];
        

        } else {
            NSString* firstLetter = [[logs objectAtIndex:indexPath.row][@"device"] substringToIndex:1];
            if([firstLetter isEqualToString:@"A"]){
                cell.deviceImage.image = [UIImage imageNamed:@"and.png"];
            } else if([firstLetter isEqualToString:@"i"] || [firstLetter isEqualToString:@"M"] ){
                cell.deviceImage.image = [UIImage imageNamed:@"ios.png"];
            } else if([firstLetter isEqualToString:@"W"]){
                cell.deviceImage.image = [UIImage imageNamed:@"win.png"];
            } else if([firstLetter isEqualToString:@"o"]){
                cell.deviceImage.image = [UIImage imageNamed:@"unk.png"];
            }
            
        

            cell.nameLabel.text = [logs objectAtIndex:indexPath.row][@"user"];
            cell.deviceLabel.text = nil;
            cell.startLabel.text = [logs objectAtIndex:indexPath.row][@"time_start"];
            
            NSString *time_connected = [logs objectAtIndex:indexPath.row][@"total_mins"];
            if([time_connected isEqualToString:@"--"]){
                cell.totalLabel.text = @"--";
            } else {
                if([time_connected doubleValue] >= 60){
                    double time = [time_connected doubleValue];
                    double hours = time/60;
                    cell.totalLabel.text = [NSString stringWithFormat:@"%0.2f hr", hours];
                } else {
                    double time = [time_connected doubleValue];
                    cell.totalLabel.text = [NSString stringWithFormat:@"%0.2f min", time];
                }
            }


        }
        return cell;
    }

    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField == self.dateTextField){
        accessoryMode = @"date";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DateSelectionController *selectModal = [storyboard instantiateViewControllerWithIdentifier:@"DateSelectionController"];
        selectModal.selectMode = @"date";
        selectModal.myDelegate = self;
        [selectModal setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:selectModal animated:YES completion:nil];

    } else if(textField == self.APListTextField){
        accessoryMode = @"ap";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DateSelectionController *selectModal = [storyboard instantiateViewControllerWithIdentifier:@"DateSelectionController"];
        selectModal.selectMode = @"ap";
        selectModal.myDelegate = self;
        [selectModal setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:selectModal animated:YES completion:nil];
        
    }
    return NO;
}


- (void)modalViewDismissed:(NSString *)value withSelectMode:(NSString *)mode{
    if([mode isEqualToString:@"date"]){
        self.dateTextField.text = value;
        self.tableView.hidden = true;
        self.activityIndicatorContainer.hidden = false;
        requestUtility *reqUtil = [[requestUtility alloc] init];
        [reqUtil getData:@"userlogs" withParams:self.dateTextField.text completion:^(NSDictionary *responseDict){
            [logs removeAllObjects];
            for (id log in responseDict){
                [logs addObject:log];
            }
            if(logs.count == 0){
                self.activityIndicatorContainer.hidden = true;
                self.tableView.hidden = false;
                [self alertEmptyData];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                
               
            }else {
                self.tableView.hidden = false;
                self.activityIndicatorContainer.hidden = true;
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            
        }];
    } else if([mode isEqualToString:@"ap"]){
        [logs removeAllObjects];
        [logs addObjectsFromArray:logsCopy];
        NSLog(@"LOGS COPY: %@", logsCopy);
        [filteredLogs removeAllObjects];
        self.APListTextField.text = value;
        for(id log in logs){
            if([log[@"ap"] isEqualToString:self.APListTextField.text]){
                [filteredLogs addObject:log];
                NSLog(@"HELLO. %@", log);
            }

        }
        [logs removeAllObjects];
        [logs addObjectsFromArray:filteredLogs];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        NSLog(@"HELLO.");

    }
    
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user contains[c] %@", searchText];
    NSPredicate *devicePredicate = [NSPredicate predicateWithFormat:@"device contains[c] %@", searchText];
    NSPredicate *apPredicate = [NSPredicate predicateWithFormat:@"ap contains[c] %@", searchText];
    NSMutableArray *compoundPredicateArray = [ NSMutableArray arrayWithObjects: userPredicate,devicePredicate, apPredicate, nil];
    NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:
                              compoundPredicateArray];

    searchResults = [logs filteredArrayUsingPredicate:predicate];
    
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
