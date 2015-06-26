//
//  Data.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/19/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "Data.h"
#import "requestUtility.h"

@implementation Data
NSMutableArray *apNames = nil;
NSMutableArray *apIds = nil;
NSMutableArray *active = nil;
NSMutableArray *females = nil;
NSMutableArray *males = nil;
NSMutableArray *others = nil;
NSMutableArray *heartbeats = nil;
NSMutableArray *speed = nil;
NSMutableArray *feeds = nil;
NSMutableArray *userInfo = nil;
NSString *user = nil;
NSString *url_str = @"http://dev.wifination.ph:3000";

+ (void) fillAPArrays{
    apNames = [[NSMutableArray alloc] init];
    apIds = [[NSMutableArray alloc] init];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil GETRequestSender:@"getAPList" completion:^(NSDictionary *responseDict){
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
    [reqUtil GETRequestSender:@"getAnalytics" completion:^(NSDictionary *responseDict){
        males = responseDict[@"agegender"][@"m"];
        females = responseDict[@"agegender"][@"f"];
        others = responseDict[@"agegender"][@"o"];
        active = responseDict[@"active"];
    }];
}

+ (void) getRPMData {
    NSString *apId = [Data getIdForAPAtIndex:0];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    [reqUtil GETRequestSender:@"getRPM" withParams:apId completion:^(NSDictionary *responseDict){
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
    [reqUtil GETRequestSender:@"getAccountSettings" completion:^(NSDictionary *responseDict){
        for (id info in responseDict){
            userInfo = info;
        }
    }];
}

@end
