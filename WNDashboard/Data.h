//
//  Data.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/19/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSMutableArray *apNames;
extern NSMutableArray *apIds;
extern NSString *feedsURL;
extern NSString *user;
extern NSString *url_str;
extern NSMutableArray *females;
extern NSMutableArray *males;
extern NSMutableArray *others;
extern NSMutableArray *active;
extern NSMutableArray *heartbeats;
extern NSMutableArray *speed;
extern NSMutableArray *feeds;
extern NSMutableArray *userInfo;



@interface Data : NSObject


+ (void) fillAPArrays;
+ (NSString *) getIdForAPAtIndex: (NSUInteger)index;
+ (void) setUser: (NSString *)name;
+ (void) getAgeGenderData;
+ (void) getRPMData;
+ (void)clearRPM;
+ (void)setRPM:(NSMutableArray *)sp andHeartbeats:(NSMutableArray *)hb;
+ (void)getUserInfo;

@end
