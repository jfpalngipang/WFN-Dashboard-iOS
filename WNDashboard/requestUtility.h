//
//  requestUtility.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface requestUtility : NSObject <NSURLSessionDelegate>

- (void) LoginRequestWithUsername: (NSString *)username andPassword: (NSString *)password completion:(void (^)(NSString *)) completion;
- (void) GETRequestSender: (NSString *) type completion:(void (^)(NSDictionary *)) completion;
- (void) GETRequestSender: (NSString *)type withParams: (NSString *)param completion:(void(^)(NSDictionary *))completion;
- (void) resetPasswordWithToken:(NSString*)token andEmail:(NSString*)email completion:(void (^)(NSDictionary *)) completion;
- (void) GETAnalyticsFor: (NSString *)ap withRange:(NSString *)range completion:(void(^)(NSDictionary *))completion;
- (void) logIn:(NSString *)username password:(NSString *)password completion:(void (^)(NSString *)) completion;
- (void) getData:(NSString *)type completion:(void (^)(NSDictionary *)) completion;
- (void) getData:(NSString *)type withParams:(NSString *)param completion:(void (^)(NSDictionary *))completion;



@end
