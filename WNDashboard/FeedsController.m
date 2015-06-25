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
#import "NewUserCell.h"
#import "fbGraphUtility.h"
#import "Data.h"

@interface FeedsController ()

@end

@implementation FeedsController
{
    
    NSMutableArray *news_array;
    fbGraphUtility *fbUtil;
    NSMutableArray *other;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    news_array = [[NSMutableArray alloc] init];
    fbUtil = [[fbGraphUtility alloc] init];
    
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    
    [reqUtil GETRequestSender:@"getFeeds" completion:^(NSDictionary *responseDict){
        for(id entry in responseDict){
            [news_array addObject:entry];
        }
        feeds = news_array;
        
        NSLog(@"%@", news_array);
        self.tableView.estimatedRowHeight = 150.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }];
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    refresh = [[UIRefreshControl alloc] init];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh" attributes:attrsDictionary];
    refresh.backgroundColor = [UIColor orangeColor];
    refresh.tintColor = [UIColor whiteColor];
    [refresh addTarget:self
                            action:@selector(getLatestFeeds:)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[news_array objectAtIndex:indexPath.row][@"type"] isEqualToString:@"survey"]){
        return 260;
    } else {
        return 100;
    }
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

            cell.onlineImage.image = [UIImage imageNamed:@"newsfeed_activeusers"];
            cell.countLabel.text = [NSString stringWithFormat:@"%@", count];
            cell.timeLabel.text = [news_array objectAtIndex:indexPath.row][@"time"];
            return cell;
        } else if ([[news_array objectAtIndex:indexPath.row][@"type"] isEqualToString:@"frequent_users"]) {
            identifier = @"FrequentUsersCell";
            NSString *fbId = [news_array objectAtIndex:indexPath.row][@"main_uid"];
            NSString *count = [news_array objectAtIndex:indexPath.row][@"count"];
            NSString *time = [news_array objectAtIndex:indexPath.row][@"time"];
            FrequentUsersCell *cell = (FrequentUsersCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FrequentUsersCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            FBSDKProfilePictureView *profilePicture = [[FBSDKProfilePictureView alloc] initWithFrame:cell.profilePicture.frame];
            
            [profilePicture setProfileID:fbId];
            profilePicture.layer.borderWidth = 0;
            [cell addSubview:profilePicture];
            cell.nameLabel.text = [news_array objectAtIndex:indexPath.row][@"user"];
            cell.usageLabel.text = [NSString stringWithFormat:@"is one of your %@ users for the last 30 days", count];
            cell.timeDateLabel.text = time;
            return cell;
        } else if ([[news_array objectAtIndex:indexPath.row][@"type"] isEqualToString:@"survey"]) {
            //NSDictionary *questions = [news_array objectAtIndex:indexPath.row];
            identifier = @"SurveyUsersCell";
            NSString *count = [news_array objectAtIndex:indexPath.row][@"count"];
            NSString *answer = [news_array objectAtIndex:indexPath.row][@"answer"];
            NSString *question = [news_array objectAtIndex:indexPath.row][@"question"];
            other = [news_array objectAtIndex:indexPath.row][@"other"];
            SurveyCell *cell = (SurveyCell *)[tableView dequeueReusableCellWithIdentifier:identifier];

            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SurveyCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.surveyImage.image = [UIImage imageNamed:@"newsfeed_survey"];
            cell.surveyResultsLabel.text = [NSString stringWithFormat:@"%@ answered %@ to your question: %@", count, answer, question];
            cell.timeDateLabel.text = [news_array objectAtIndex:indexPath.row][@"time"];
            return cell;
        } else if ([[news_array objectAtIndex:indexPath.row][@"type"] isEqualToString:@"testimonial"]){
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
            [fbUtil getFBPhoto:fbId completion:^(NSDictionary *imageData){
                //NSLog(@"RESP: %@", imageData);
                //cell.userImage.image = [UIImage imageWithData:imageData];
            }];
            
            /**************/
            cell.nameLabel.text = name;
            cell.testimonialLabel.text = message;
            cell.timeLabel.text = time;
            cell.estabLabel.text = @"";
            return cell;
        } else {
            identifier = @"NewUserCell";
            NSString *fbId = [news_array objectAtIndex:indexPath.row][@"main_uid"];
            NSString *count = [news_array objectAtIndex:indexPath.row][@"count"];
            NSString *time = [news_array objectAtIndex:indexPath.row][@"time"];
            NewUserCell *cell = (NewUserCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewUserCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.newuserImage.image = [UIImage imageNamed:@"newsfeed_newuser"];
            cell.countLabel.text = count;
            cell.timeLabel.text = time;
            return cell;

        }
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
    
    NSURLSessionDataTask *dataTask = [backgroundSession dataTaskWithURL:notifURL];
        /*
        NSMutableArray *notifs;
        for(id items in result){
            [notifs addObject:items];
        }
        if(result){
            completionHandler(UIBackgroundFetchResultNewData);
            NSLog(@"new data!");
        }

         */
   
    
    [dataTask resume];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotif.alertBody = @"Notif!";
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

-(void)getLatestFeeds:(UIRefreshControl*)refresh{
    
    [refresh endRefreshing];
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

-(void)configurePieChart{
    NSInteger other_total;
    other_total = 0;
    for(id ans in other){
        other_total+=[ans[1] integerValue];
    }
    
}


@end
