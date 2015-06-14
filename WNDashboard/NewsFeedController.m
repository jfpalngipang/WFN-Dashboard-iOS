//
//  NewsFeedController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/15/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "NewsFeedController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"
#import "FrequentUsersCell.h"
#import "OnlineUsersCell.h"
#import "SurveyCell.h"

@interface NewsFeedController ()

@end

@implementation NewsFeedController
{
    
    NSMutableArray *news_array;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *result;
    news_array = [[NSMutableArray alloc] init];
    
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    
    [reqUtil GETRequestSender:@"getFeeds" completion:^(NSDictionary *responseDict){
        NSLog(@"GOT : %@", responseDict);
        for(id entry in responseDict){
            [news_array addObject:entry];
            NSLog(@"%@", news_array);
            /*
             if([entry[@"type"] isEqualToString:@"on_users"]){
             NSLog(@"%@", entry[@"count"]);
             
             } else if([entry[@"type"] isEqualToString:@"frequent_users"]){
             NSLog(@"%@", entry[@"count"]);
             } else if([entry[@"type"] isEqualToString:@"survey"]){
             NSLog(@"%@", entry[@"count"]);
             } else if([entry[@"type"] isEqualToString:@"testimonial"]){
             NSLog(@"%@", entry[@"user"]);
             }
             */
        }
        [self.tableView reloadData];
        
    }];
    //result = reqUtil.result;
    //result_array = [result allValues];
    //NSLog(@"FEEDS: %@", result);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return news_array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([news_array[indexPath.row][@"type"] isEqualToString:@"on_users"]){
        static NSString *identifier = @"OnlineUsersCell";
        OnlineUsersCell *cell = (OnlineUsersCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OnlineUsersCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    } else if ([news_array[indexPath.row][@"type"] isEqualToString:@"frequent_users"]) {
        static NSString *identifier = @"FrequentUsersCell";
        FrequentUsersCell *cell = (FrequentUsersCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FrequentUsersCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    } else if ([news_array[indexPath.row][@"type"] isEqualToString:@"survey"]) {
        static NSString *identifier = @"SurveyUsersCell";
        SurveyCell *cell = (SurveyCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SurveyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    } else {
        static NSString *identifier = @"SurveyUsersCell";
        SurveyCell *cell = (SurveyCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SurveyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
