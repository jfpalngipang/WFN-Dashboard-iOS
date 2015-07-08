//
//  requestUtility.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface requestUtility : NSObject <NSURLSessionDelegate>

- (void) logIn:(NSString *)username password:(NSString *)password completion:(void (^)(NSString *)) completion;
- (void) getData:(NSString *)type completion:(void (^)(NSDictionary *)) completion;
- (void) getData:(NSString *)type withParams:(NSString *)param completion:(void (^)(NSDictionary *))completion;
- (void) postControlPanelUpdate:(NSDictionary *)settingsDict completion:(void (^)(NSString *))completion;
- (void) postDeviceToken:(NSString *)deviceToken forDevice:(NSString *)device withTag:(NSString *)tag;
- (void) getAnalyticsFor: (NSString *)ap withRange:(NSString *)range completion:(void(^)(NSDictionary *))completion;

@end
