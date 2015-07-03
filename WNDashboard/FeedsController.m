//
//  FeedsController.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//
//  News Feed View Controller

#import "FeedsController.h"
#import "requestUtility.h"
#import "SWRevealViewController.h"
#import "FrequentUsersCell.h"
#import "OnlineUsersCell.h"
#import "SurveyCell.h"
#import "MessageCell.h"
#import "NewUserCell.h"
#import "Data.h"
#import <Charts/Charts.h>
#import "WNDashboard-Bridging-Header.h"

@interface FeedsController () <ChartViewDelegate>

@end

@implementation FeedsController
{
    
    NSMutableArray *news_array;
    NSMutableArray *updated_news_array;
    NSMutableArray *other;
    NSMutableArray *chartData;
    // variables for checking hash of new feeds
    NSString *oHash;
    NSMutableArray *fHash;
    NSString *sHash;
    NSString *nHash;
    NSString *mHash;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
    self.activityIndicatorContainer.hidden = false;
    self.tableView.hidden = true;
    self.title = @"News Feed";
    chartData = [[NSMutableArray alloc]init];
    fHash = [[NSMutableArray alloc] init];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    news_array = [[NSMutableArray alloc] init];

    requestUtility *reqUtil = [[requestUtility alloc] init];
        
    [reqUtil getData:@"feeds" completion:^(NSDictionary *responseDict){
        for(id entry in responseDict){
            [news_array addObject:entry];
        }
        if(news_array.count == 0){
            [self alertEmptyData];
        }
        newsfeedsStore = news_array;
        self.tableView.estimatedRowHeight = 150.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            self.activityIndicatorContainer.hidden = true;
            self.tableView.hidden = false;
        });
            
    }];

    [NSTimer scheduledTimerWithTimeInterval:30.0f
                                     target:self selector:@selector(getTimedLatestFeeds:) userInfo:nil repeats:YES];
    

    
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

}
// different cell height for survey custom cell
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

// table view of the items in the feed
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
            
            // charting the survey results
            
            [chartData addObject:[NSString stringWithFormat:@"%d", other_total]];

            cell.pieChartView.delegate = self;
            cell.pieChartView.highlightEnabled = NO;
            cell.pieChartView.usePercentValuesEnabled = YES;
            cell.pieChartView.holeTransparent = YES;
            cell.pieChartView.centerTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:6.f];
            cell.pieChartView.holeRadiusPercent = 0.50;
            cell.pieChartView.transparentCircleRadiusPercent = 0.61;
            cell.pieChartView.descriptionText = @"";
            cell.pieChartView.drawCenterTextEnabled = NO;
            cell.pieChartView.drawHoleEnabled = YES;
            cell.pieChartView.rotationAngle = 0.0;
            cell.pieChartView.rotationEnabled = YES;
            cell.pieChartView.centerText = @"";
            
            ChartLegend *l = cell.pieChartView.legend;
            l.position = ChartLegendPositionBelowChartCenter;
            l.xEntrySpace = 7.0;
            l.yEntrySpace = 0.0;
            l.yOffset = 0.0;
            
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
            [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
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
            cell.nameLabel.text = name;
            cell.testimonialLabel.text = message;
            cell.timeLabel.text = time;
            cell.estabLabel.text = @"";
            return cell;
        } else {
            identifier = @"NewUserCell";
            nHash = [news_array objectAtIndex:indexPath.row][@"hash"];
            NSString *count = [news_array objectAtIndex:indexPath.row][@"count"];
            NSString *time = [news_array objectAtIndex:indexPath.row][@"time"];
            NSMutableArray *uids = [news_array objectAtIndex:indexPath.row][@"uids"];
            NewUserCell *cell = (NewUserCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewUserCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            if(uids.count == 1){
                FBSDKProfilePictureView *profilePicture1 = [[FBSDKProfilePictureView alloc] initWithFrame:cell.minorImage1.frame];
                
                [profilePicture1 setProfileID:uids[0]];
                profilePicture1.layer.borderWidth = 0;
                [cell addSubview:profilePicture1];
            } else if(uids.count == 2){
                FBSDKProfilePictureView *profilePicture1 = [[FBSDKProfilePictureView alloc] initWithFrame:cell.minorImage1.frame];
                
                [profilePicture1 setProfileID:uids[0]];
                profilePicture1.layer.borderWidth = 0;
                [cell addSubview:profilePicture1];
                
                FBSDKProfilePictureView *profilePicture2 = [[FBSDKProfilePictureView alloc] initWithFrame:cell.minorImage2.frame];
                
                [profilePicture2 setProfileID:uids[1]];
                profilePicture2.layer.borderWidth = 0;
                [cell addSubview:profilePicture2];
            } else if(uids.count == 3){
                FBSDKProfilePictureView *profilePicture1 = [[FBSDKProfilePictureView alloc] initWithFrame:cell.minorImage1.frame];
                
                [profilePicture1 setProfileID:uids[0]];
                profilePicture1.layer.borderWidth = 0;
                [cell addSubview:profilePicture1];
                
                FBSDKProfilePictureView *profilePicture2 = [[FBSDKProfilePictureView alloc] initWithFrame:cell.minorImage2.frame];
                
                [profilePicture2 setProfileID:uids[1]];
                profilePicture2.layer.borderWidth = 0;
                [cell addSubview:profilePicture2];
                
                FBSDKProfilePictureView *profilePicture3 = [[FBSDKProfilePictureView alloc] initWithFrame:cell.minorImage3.frame];
                
                [profilePicture3 setProfileID:uids[2]];
                profilePicture3.layer.borderWidth = 0;
                [cell addSubview:profilePicture3];
            } else if (uids.count >= 4) {
                FBSDKProfilePictureView *profilePicture1 = [[FBSDKProfilePictureView alloc] initWithFrame:cell.minorImage1.frame];
                
                [profilePicture1 setProfileID:uids[0]];
                profilePicture1.layer.borderWidth = 0;
                [cell addSubview:profilePicture1];
                
                FBSDKProfilePictureView *profilePicture2 = [[FBSDKProfilePictureView alloc] initWithFrame:cell.minorImage2.frame];
                
                [profilePicture2 setProfileID:uids[1]];
                profilePicture2.layer.borderWidth = 0;
                [cell addSubview:profilePicture2];
                
                FBSDKProfilePictureView *profilePicture3 = [[FBSDKProfilePictureView alloc] initWithFrame:cell.minorImage3.frame];
                
                [profilePicture3 setProfileID:uids[2]];
                profilePicture3.layer.borderWidth = 0;
                [cell addSubview:profilePicture3];
                
                
                FBSDKProfilePictureView *profilePicture4 = [[FBSDKProfilePictureView alloc] initWithFrame:cell.minorImage4.frame];
                
                [profilePicture4 setProfileID:uids[3]];
                profilePicture4.layer.borderWidth = 0;
                [cell addSubview:profilePicture4];
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
    /*
    NSURL *notifURL = [NSURL URLWithString:@"http://dev.wifination.ph:3000/mobile/feed/?feed="];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"feeds"];
    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [backgroundSession dataTaskWithURL:notifURL];
     */
    
   
    
    //[dataTask resume];
    [self fetchNewFeeds];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotif.alertBody = @"Notif!";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

- (void)fetchNewFeeds{
    NSURL *notifURL = [NSURL URLWithString:@"http://dev.wifination.ph:3000/mobile/feed/?feed="];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"feeds"];
    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [backgroundSession dataTaskWithURL:notifURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

    }];
    
    [dataTask resume];
}

- (void)getLatestFeeds:(UIRefreshControl*)refresh{
    
    [refresh endRefreshing];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil getData:@"feeds" completion:^(NSDictionary *responseDict){
        for(id entry in responseDict){
            if([entry[@"type"] isEqualToString:@"on_users"]){
                if(![entry[@"hash"] isEqualToString:oHash]){
                    [news_array insertObject:entry atIndex:0];

                }
            } else if([entry[@"type"] isEqualToString:@"frequent_users"]){


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

- (void)getTimedLatestFeeds: (id)update{
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil getData:@"feeds" completion:^(NSDictionary *responseDict){
        for(id entry in responseDict){
            if([entry[@"type"] isEqualToString:@"on_users"]){
                if(![entry[@"hash"] isEqualToString:oHash]){
                    [news_array insertObject:entry atIndex:0];
                    
                }
            } else if([entry[@"type"] isEqualToString:@"frequent_users"]){
                
                
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

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}


- (IBAction)frontViewTap:(id)sender {
}
@end
