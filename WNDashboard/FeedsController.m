//
//  FeedsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "FeedsController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"
#import "FrequentUsersCell.h"
#import "OnlineUsersCell.h"
#import "SurveyCell.h"

@interface FeedsController ()

@end

@implementation FeedsController
{
    
    NSMutableArray *result_array;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"fetching feeds");
    NSDictionary *result;
    
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil GETRequestSender:@"getFeeds" completion:^(NSDictionary *responseDict){
        NSLog(@"GOT : %@", responseDict);
        for(id entry in responseDict){
            if([entry[@"type"] isEqualToString:@"on_users"]){
                NSLog(@"%@", entry[@"count"]);
                
            } else if([entry[@"type"] isEqualToString:@"frequent_users"]){
                NSLog(@"%@", entry[@"count"]);
            } else if([entry[@"type"] isEqualToString:@"survey"]){
                NSLog(@"%@", entry[@"count"]);
            } else if([entry[@"type"] isEqualToString:@"testimonial"]){
                NSLog(@"%@", entry[@"user"]);
            }
        }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *identifier = @"FrequentUsersCell";
    
    FrequentUsersCell *cell = (FrequentUsersCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FrequentUsersCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
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
