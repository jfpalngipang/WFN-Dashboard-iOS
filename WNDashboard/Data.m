//
//  Data.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/19/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//
//  Singleton for the various data utilized by the app

#import "Data.h"
#import "requestUtility.h"

@implementation Data
NSMutableArray *apNames = nil;
NSMutableArray *apIds = nil;
NSMutableArray *active;
NSMutableArray *females;
NSMutableArray *males;
NSMutableArray *others;
NSMutableArray *heartbeats = nil;
NSMutableArray *speed = nil;
NSMutableArray *feeds = nil;
NSMutableArray *userInfo = nil;
NSString *user = nil;
BOOL surveyClicked = NO;
NSString *url_str = @"https://wifination.ph";
NSString *today = nil;
NSMutableArray *newsfeedsStore;

+ (void) fillAPArrays{
    apNames = [[NSMutableArray alloc] init];
    apIds = [[NSMutableArray alloc] init];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil getData:@"aplist" completion:^(NSDictionary *responseDict){
        for (id ap in responseDict){
            [apNames addObject:ap[1]];
            [apIds addObject:ap[0]];
        }
        [Data getRPMData];
        
    }];
}

+ (NSString *) getIdForAPAtIndex: (NSUInteger)index{
    NSString *apId = [[NSString alloc] init];
    apId = [apIds objectAtIndex:index];
    
    return apId;
}

+ (void) setUser: (NSString *)name{
    user = [NSString stringWithFormat:@"%@", name];
}

+ (void)getAgeGenderData{
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil getData:@"analytics" completion:^(NSDictionary *responseDict){
        males = responseDict[@"agegender"][@"m"];
        females = responseDict[@"agegender"][@"f"];
        others = responseDict[@"agegender"][@"o"];
        active = responseDict[@"active"];
    }];
}

+ (void) getRPMData {
    NSString *apId = [Data getIdForAPAtIndex:0];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil getData:@"rpm" withParams:apId completion:^(NSDictionary *responseDict){
        heartbeats = responseDict[@"heartbeats"];
        speed = responseDict[@"speed"];
    }];
}

+ (void)clearRPM{
    [speed removeAllObjects];
    [heartbeats removeAllObjects];
}

+ (void)setRPM:(NSMutableArray *)sp andHeartbeats:(NSMutableArray *)hb{
    speed = sp;
    heartbeats = hb;
}

+ (void)getUserInfo{
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil getData:@"userprofile" completion:^(NSDictionary* responseDict){
        for (id info in responseDict){
            [userInfo addObject:info];
        }
        //NSLog(@"USER ACCOUNT: %@", userInfo);
    }];
}

+ (void) getDateToday {
    NSDate *dateToday = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    today = [dateFormatter stringFromDate:dateToday];
}

+ (void) storeLatestFeeds:(NSMutableArray *)feeds {
    [newsfeedsStore removeAllObjects];
    newsfeedsStore = feeds;
}

@end
