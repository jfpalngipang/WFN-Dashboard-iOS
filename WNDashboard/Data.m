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
        for (id ap in responseDict){
            
        }
        
    }];
}

@end
