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
#import <Charts/Charts.h>
#import "WNDashboard-Bridging-Header.h"

@interface FeedsController () <ChartViewDelegate>

@end

@implementation FeedsController
{
    
    NSMutableArray *news_array;
    NSMutableArray *updated_news_array;
    fbGraphUtility *fbUtil;
    NSMutableArray *other;
    NSMutableArray *chartData;
    NSString *oHash;
    NSMutableArray *fHash;
    NSString *sHash;
    NSString *nHash;
    NSString *mHash;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"News Feed";
    chartData = [[NSMutableArray alloc]init];
    fHash = [[NSMutableArray alloc] init];
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
            oHash = [news_array objectAtIndex:indexPath.row][@"hash"];
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
            
            [fHash  addObject:[news_array objectAtIndex:indexPath.row][@"hash"]];
            NSString *fbId = [news_array objectAtIndex:indexPath.row][@"main_uid"];
            NSString *count = [news_array objectAtIndex:indexPath.row][@"count"];
            NSString *time = [news_array objectAtIndex:indexPath.row][@"time"];
            FrequentUsersCell *cell = (FrequentUsersCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            cell.profilePicture.image = nil;
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
            [chartData removeAllObjects];
            identifier = @"SurveyUsersCell";
            sHash = [news_array objectAtIndex:indexPath.row][@"hash"];
            NSString *count = [news_array objectAtIndex:indexPath.row][@"count"];
            [chartData addObject:count];
            NSString *answer = [news_array objectAtIndex:indexPath.row][@"answer"];
            NSString *question = [news_array objectAtIndex:indexPath.row][@"question"];
            other = [news_array objectAtIndex:indexPath.row][@"other"];
            //[self configurePieChart];
         
            SurveyCell *cell = (SurveyCell *)[tableView dequeueReusableCellWithIdentifier:identifier];

            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SurveyCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            /*********************/
            NSInteger other_total;
            other_total = 0;
            for(id ans in other){
                other_total+=[ans[1] integerValue];
            }
            //NSLog(@"************ %d", other_total);
            [chartData addObject:[NSString stringWithFormat:@"%d", other_total]];

            cell.pieChartView.delegate = self;
            
            cell.pieChartView.usePercentValuesEnabled = YES;
            cell.pieChartView.holeTransparent = YES;
            cell.pieChartView.centerTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:6.f];
            cell.pieChartView.holeRadiusPercent = 0.58;
            cell.pieChartView.transparentCircleRadiusPercent = 0.61;
            cell.pieChartView.descriptionText = @"";
            cell.pieChartView.drawCenterTextEnabled = YES;
            cell.pieChartView.drawHoleEnabled = YES;
            cell.pieChartView.rotationAngle = 0.0;
            cell.pieChartView.rotationEnabled = YES;
            cell.pieChartView.centerText = @"Survey Details Chart";
            
            ChartLegend *l = cell.pieChartView.legend;
            l.position = ChartLegendPositionBelowChartLeft;
            l.xEntrySpace = 7.0;
            l.yEntrySpace = 0.0;
            l.yOffset = 0.0;
            
            [cell.pieChartView animateWithXAxisDuration:1.5 yAxisDuration:1.5 easingOption:ChartEasingOptionEaseOutBack];
            
            NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
            NSMutableArray *xVals = [[NSMutableArray alloc] init];
            for (int i = 0; i < 2; i++)
            {
                int val = (double)[chartData[i] doubleValue];
                [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i]];
            }
            for (int i = 0; i < 2; i++)
            {
                if(i == 0){
                    [xVals addObject:answer];
                } else {
                    [xVals addObject:@"Others"];
                }
                
            }
            PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@""];
            dataSet.sliceSpace = 3.0;
            NSMutableArray *colors = [[NSMutableArray alloc] init];
            [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
            [colors addObjectsFromArray:ChartColorTemplates.joyful];
            [colors addObjectsFromArray:ChartColorTemplates.colorful];
            [colors addObjectsFromArray:ChartColorTemplates.liberty];
            [colors addObjectsFromArray:ChartColorTemplates.pastel];
            [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
            
            dataSet.colors = colors;
            
            PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
            
            NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
            pFormatter.numberStyle = NSNumberFormatterPercentStyle;
            pFormatter.maximumFractionDigits = 1;
            pFormatter.multiplier = @1.f;
            pFormatter.percentSymbol = @" %";
            [data setValueFormatter:pFormatter];
            [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:6.f]];
            [data setValueTextColor:UIColor.blackColor];
            
            cell.pieChartView.data = data;
            [cell.pieChartView highlightValues:nil];

            /*********************/
            cell.surveyImage.image = [UIImage imageNamed:@"newsfeed_survey"];
            cell.surveyResultsLabel.text = [NSString stringWithFormat:@"%@ answered %@ to your question: %@", count, answer, question];
            cell.timeDateLabel.text = [news_array objectAtIndex:indexPath.row][@"time"];
            return cell;
        } else if ([[news_array objectAtIndex:indexPath.row][@"type"] isEqualToString:@"testimonial"]){
            identifier = @"MessageCell";
            mHash = [news_array objectAtIndex:indexPath.row][@"hash"];
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
            nHash = [news_array objectAtIndex:indexPath.row][@"hash"];
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
    //NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ %@", fHash);
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil GETRequestSender:@"getFeeds" completion:^(NSDictionary *responseDict){
        for(id entry in responseDict){
            if([entry[@"type"] isEqualToString:@"on_users"]){
                if(![entry[@"hash"] isEqualToString:oHash]){
                    [news_array insertObject:entry atIndex:0];
                    //NSLog(@"****************************************************");
                }
            } else if([entry[@"type"] isEqualToString:@"frequent_users"]){
                    //[news_array addObject:entry];

            } else if([entry[@"type"] isEqualToString:@"new_users"]){
                if(![entry[@"hash"] isEqualToString:nHash]){
                    [news_array insertObject:entry atIndex:0];
                }
            } else if([entry[@"type"] isEqualToString:@"survey"]){
                if(![entry[@"hash"] isEqualToString:sHash]){
                    [news_array insertObject:entry atIndex:0];
                }
            } else if([entry[@"type"] isEqualToString:@"testimonial"]){
                if(![entry[@"hash"] isEqualToString:mHash]){
                    [news_array insertObject:entry atIndex:0];
                }
            }
            
        }
        NSLog(@"%@", news_array);
        self.tableView.rowHeight = 100;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }];
}

-(void)configurePieChart{

    NSLog(@"TOTAL: %@", chartData);

}


@end
