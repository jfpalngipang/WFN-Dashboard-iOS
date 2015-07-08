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
#import "AFNetworking.h"

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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertEmptyData];
            });
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

    [NSTimer scheduledTimerWithTimeInterval:60.0f
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
        return 150;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return news_array.count;
}
- (void)alertEmptyData{

    if ([UIAlertController class]) {
        // use UIAlertController
        
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
        
    } else {
        // use UIAlertView
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Empty Data"
                                                          message:@"No data available."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }
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
            //cell.profilePicture.image = nil;
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FrequentUsersCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            //FBSDKProfilePictureView *profilePicture = [[FBSDKProfilePictureView alloc] initWithFrame:cell.profilePicture.frame];
            
            cell.profilePicture.profileID = fbId;
            cell.profilePicture.layer.borderWidth = 0;
            cell.profilePicture.layer.cornerRadius = 10;
            cell.profilePicture.clipsToBounds = YES;
            cell.profilePicture.layer.borderWidth = 2;
            cell.profilePicture.layer.borderColor = [[UIColor orangeColor] CGColor];
            //[cell addSubview:profilePicture];
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
                cell.minorImage1.profileID = uids[0];
                cell.minorImage1.layer.borderWidth = 1;
 
            } else if(uids.count == 2){
                cell.minorImage1.profileID = uids[0];
                cell.minorImage1.layer.borderWidth = 1;
                cell.minorImage1.layer.cornerRadius = 10;
                cell.minorImage1.clipsToBounds = YES;
                cell.minorImage1.layer.borderColor = [[UIColor orangeColor] CGColor];
                
                cell.minorImage2.profileID = uids[1];
                cell.minorImage2.layer.borderWidth = 1;
                cell.minorImage2.layer.cornerRadius = 10;
                cell.minorImage2.clipsToBounds = YES;
                cell.minorImage2.layer.borderColor = [[UIColor orangeColor] CGColor];
            } else if(uids.count == 3){
                cell.minorImage1.profileID = uids[0];
                cell.minorImage1.layer.borderWidth = 1;
                cell.minorImage2.profileID = uids[1];
                cell.minorImage2.layer.borderWidth = 1;
                cell.minorImage3.profileID = uids[2];
                cell.minorImage3.layer.borderWidth = 1;
                
                cell.minorImage1.layer.cornerRadius = 10;
                cell.minorImage1.clipsToBounds = YES;
                cell.minorImage1.layer.borderColor = [[UIColor orangeColor] CGColor];
                
  
                cell.minorImage2.layer.cornerRadius = 10;
                cell.minorImage2.clipsToBounds = YES;
                cell.minorImage2.layer.borderColor = [[UIColor orangeColor] CGColor];
                
                cell.minorImage3.layer.cornerRadius = 10;
                cell.minorImage3.clipsToBounds = YES;
                cell.minorImage3.layer.borderColor = [[UIColor orangeColor] CGColor];
                
            } else if (uids.count == 4) {
                cell.minorImage1.profileID = uids[0];
                cell.minorImage1.layer.borderWidth = 1;
                cell.minorImage2.profileID = uids[1];
                cell.minorImage2.layer.borderWidth = 1;
                cell.minorImage3.profileID = uids[2];
                cell.minorImage3.layer.borderWidth = 1;
                cell.minorImage4.profileID = uids[3];
                cell.minorImage4.layer.borderWidth = 1;
                
                cell.minorImage1.layer.cornerRadius = 10;
                cell.minorImage1.clipsToBounds = YES;
                cell.minorImage1.layer.borderColor = [[UIColor orangeColor] CGColor];
                
                
                cell.minorImage2.layer.cornerRadius = 10;
                cell.minorImage2.clipsToBounds = YES;
                cell.minorImage2.layer.borderColor = [[UIColor orangeColor] CGColor];
                
                cell.minorImage3.layer.cornerRadius = 10;
                cell.minorImage3.clipsToBounds = YES;
                cell.minorImage3.layer.borderColor = [[UIColor orangeColor] CGColor];
                
                cell.minorImage4.layer.cornerRadius = 10;
                cell.minorImage4.clipsToBounds = YES;
                cell.minorImage4.layer.borderColor = [[UIColor orangeColor] CGColor];

            } else if (uids.count >= 5) {
                cell.minorImage1.profileID = uids[0];
                cell.minorImage1.layer.borderWidth = 1;
                cell.minorImage2.profileID = uids[1];
                cell.minorImage2.layer.borderWidth = 1;
                cell.minorImage3.profileID = uids[2];
                cell.minorImage3.layer.borderWidth = 1;
                cell.minorImage4.profileID = uids[3];
                cell.minorImage4.layer.borderWidth = 1;
                cell.minorImage5.profileID = uids[4];
                cell.minorImage5.layer.borderWidth = 1;
                
                cell.minorImage1.layer.cornerRadius = 10;
                cell.minorImage1.clipsToBounds = YES;
                cell.minorImage1.layer.borderColor = [[UIColor orangeColor] CGColor];
                
                
                cell.minorImage2.layer.cornerRadius = 10;
                cell.minorImage2.clipsToBounds = YES;
                cell.minorImage2.layer.borderColor = [[UIColor orangeColor] CGColor];
                
                cell.minorImage3.layer.cornerRadius = 10;
                cell.minorImage3.clipsToBounds = YES;
                cell.minorImage3.layer.borderColor = [[UIColor orangeColor] CGColor];
                
                cell.minorImage4.layer.cornerRadius = 10;
                cell.minorImage4.clipsToBounds = YES;
                cell.minorImage4.layer.borderColor = [[UIColor orangeColor] CGColor];
                
                cell.minorImage5.layer.cornerRadius = 10;
                cell.minorImage5.clipsToBounds = YES;
                cell.minorImage5.layer.borderColor = [[UIColor orangeColor] CGColor];

            }
            
            cell.newuserImage.image = [UIImage imageNamed:@"newsfeed_newuser"];
            cell.countLabel.text = [NSString stringWithFormat:@"You have %@ new users.", count];
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
    __block BOOL newFeedFetched = NO;
    NSString *notifURLStr = @"https://wifination.ph/mobile/feed/?feed=";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:notifURLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"FETCH RESULT**********: %@", responseObject);
        for(id entry in responseObject){
            if([entry[@"type"] isEqualToString:@"new_users"]){
                if(![entry[@"hash"] isEqualToString:nHash]){
                    newFeedFetched = YES;
                    [news_array insertObject:entry atIndex:0];
                    NSString* message = [NSString stringWithFormat:@"You have %@ new users!", entry[@"count"]];
                    [self notify:message];
                }
            } else if([entry[@"type"] isEqualToString:@"survey"]){
                if(![entry[@"hash"] isEqualToString:sHash]){
                    newFeedFetched = YES;
                    [news_array insertObject:entry atIndex:0];
                    NSString* message = [NSString stringWithFormat:@"%@ answered \'%@\' to your question: %@", entry[@"count"], entry[@"answer"], entry[@"question"]];
                    [self notify:message];
                    
                }
            } else if([entry[@"type"] isEqualToString:@"testimonial"]){
                if(![entry[@"hash"] isEqualToString:mHash]){
                    newFeedFetched = YES;
                    [news_array insertObject:entry atIndex:0];
                    NSString* message = [NSString stringWithFormat:@"You have a new message."];
                    [self notify:message];
                }
            }
            if(newFeedFetched == YES){
                completionHandler(UIBackgroundFetchResultNewData);
            }else {
                completionHandler(UIBackgroundFetchResultNoData);
            }
            

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
    }];

}

- (void)notify:(NSString *)message{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotif.alertBody = message;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
}

- (void)fetchNewFeeds{
    NSURL *notifURL = [NSURL URLWithString:@"http://dev.wifination.ph:3000/mobile/feed/?feed="];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"feeds"];
    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
   
    NSURLSessionDataTask *dataTask = [backgroundSession dataTaskWithURL:notifURL];
    
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
        //NSLog(@"%@", news_array);
        self.tableView.rowHeight = 100;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }];

}

-(void)configurePieChart{

    //NSLog(@"TOTAL: %@", chartData);

}

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    //NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    //NSLog(@"chartValueNothingSelected");
}


- (IBAction)frontViewTap:(id)sender {
}
@end
