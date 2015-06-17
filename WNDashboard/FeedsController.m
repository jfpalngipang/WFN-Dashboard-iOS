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
#import "MessageCell.h"
#import "fbGraphUtility.h"

@interface FeedsController ()

@end

@implementation FeedsController
{
    
    NSMutableArray *news_array;
    fbGraphUtility *fbUtil;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
    
    news_array = [[NSMutableArray alloc] init];
    fbUtil = [[fbGraphUtility alloc] init];
    
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    
    [reqUtil GETRequestSender:@"getFeeds" completion:^(NSDictionary *responseDict){
        for(id entry in responseDict){
            [news_array addObject:entry];
        }
        NSLog(@"%@", news_array);
        self.tableView.rowHeight = 100;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }];

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return news_array.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    static NSString *identifier;
        if([[news_array objectAtIndex:indexPath.row][@"type"] isEqualToString:@"on_users"]){
            identifier = @"OnlineUsersCell";
            NSString *count = [news_array objectAtIndex:indexPath.row][@"count"];
            OnlineUsersCell *cell = (OnlineUsersCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OnlineUsersCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }

            
            cell.onlineImage.image = [UIImage imageNamed:@"icon_user"];
            cell.countLabel.text = [NSString stringWithFormat:@"%@", count];
            cell.timeLabel.text = [news_array objectAtIndex:indexPath.row][@"time"];
            return cell;
        } else if ([[news_array objectAtIndex:indexPath.row][@"type"] isEqualToString:@"frequent_users"]) {
            identifier = @"FrequentUsersCell";
            NSString *count = [news_array objectAtIndex:indexPath.row][@"count"];
            NSString *time = [news_array objectAtIndex:indexPath.row][@"time"];
            FrequentUsersCell *cell = (FrequentUsersCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FrequentUsersCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.nameLabel.text = [news_array objectAtIndex:indexPath.row][@"user"];
            cell.usageLabel.text = [NSString stringWithFormat:@"has used your hotspot %@ times for the last 30 days", count];
            cell.timeDateLabel.text = time;
            return cell;
        } else if ([[news_array objectAtIndex:indexPath.row][@"type"] isEqualToString:@"survey"]) {
            identifier = @"SurveyUsersCell";
            NSString *count = [news_array objectAtIndex:indexPath.row][@"count"];
            NSString *answer = [news_array objectAtIndex:indexPath.row][@"answer"];
            NSString *question = [news_array objectAtIndex:indexPath.row][@"question"];
            SurveyCell *cell = (SurveyCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SurveyCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.surveyImage.image = [UIImage imageNamed:@"icon_survey"];
            cell.surveyResultsLabel.text = [NSString stringWithFormat:@"%@ answered %@ to your question: %@", count, answer, question];
            cell.timeDateLabel.text = [news_array objectAtIndex:indexPath.row][@"time"];
            return cell;
        } else {
            identifier = @"MessageCell";
            NSString *name = [news_array objectAtIndex:indexPath.row][@"user"];
            NSString *message = [news_array objectAtIndex:indexPath.row][@"msg"];
            NSString *time = [news_array objectAtIndex:indexPath.row][@"time"];
            NSString *fbId = [news_array objectAtIndex:indexPath.row][@"main_uid"];
            MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            /**************/
            [fbUtil getFBPhoto:fbId completion:^(NSData *imageData){
                //NSLog(@"RESP: %@", imageData);
                cell.userImage.image = [UIImage imageWithData:imageData];
            }];
            
            /**************/
            cell.nameLabel.text = name;
            cell.testimonialLabel.text = message;
            cell.timeLabel.text = time;
            cell.estabLabel.text = @"";
            return cell;
        }
    //}
     

 /*
    static NSString *identifier = @"Cell";
    OnlineUsersCell *cell = (OnlineUsersCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"OnlineUsersCell" owner:self options:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
  */
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)fetchFeedUpdateWithCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler{
    NSURL *notifURL = [NSURL URLWithString:@"http://dev.wifination.ph:3000/mobile/feed/?feed="];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"feeds"];
    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [backgroundSession dataTaskWithURL:notifURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *notifs;
        for(id items in result){
            [notifs addObject:items];
        }

        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.alertBody = @"Notif!";
    }];
    
    [dataTask resume];
}


@end
