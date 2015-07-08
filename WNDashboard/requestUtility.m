//
//  requestUtility.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//
//  utility class for sending GET and POST requests to server

#import "requestUtility.h"
#import "AFNetworking.h"

@implementation requestUtility
{
    NSURL *loginURL;
    NSURL *userLogsURL;

}

- (void) logIn:(NSString *)username password:(NSString *)password completion:(void (^)(NSString *)) completion{
    __block NSString *status;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters = @{@"username": username, @"password": password};
    
    [manager POST:@"https://wifination.ph/login_app/" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Success: %@", responseObject);
        status = [responseObject valueForKeyPath:@"status"];
        completion(status);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
    }];
    
}
- (void) getData:(NSString *)type completion:(void (^)(NSDictionary *)) completion{
   
    NSString *urlStr;
    if([type  isEqual: @"feeds"]) {
        urlStr = @"https://wifination.ph/mobile/feed/";
    } else if([type  isEqual: @"userlogs"]){
        urlStr = @"https://wifination.ph/mobile/userlogs/";
    } else if([type isEqual:@"apsettings"]){
        urlStr = @"https://wifination.ph/mobile/apsettings/";
    } else if([type isEqual:@"surveys"]){
        urlStr = @"https://wifination.ph/mobile/survey/";
    } else if([type isEqual:@"analytics"]){
        urlStr = @"https://wifination.ph/mobile/analytics/";
    } else if([type isEqual:@"aplist"]){
        urlStr = @"https://wifination.ph/mobile/accesspoints/";
    } else if([type isEqual:@"messages"]){
        urlStr = @"https://wifination.ph/mobile/testimonials/";
    } else if([type isEqual:@"terms"]){
        urlStr = @"https://wifination.ph/mobile/terms/";
    } else if ([type isEqual:@"userprofile"]){
        urlStr = @"https://wifination.ph/mobile/user_profile/";
    } else if([type isEqualToString:@"resetpassword"]){
        urlStr = @"https://wifination.ph/password_reset/";
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
    }];
}

- (void) getData:(NSString *)type withParams:(NSString *)param completion:(void (^)(NSDictionary *))completion{
    NSString *urlStr;
    if([type isEqualToString:@"surveydetails"]){
        urlStr = [NSString stringWithFormat:@"https://wifination.ph/mobile/detailedsurvey/?id=%@", param];
    } else if([type isEqualToString:@"rpm"]){
        urlStr = [NSString stringWithFormat:@"https://wifination.ph/mobile/rpm/?id=%@", param];
    } else if([type  isEqual: @"userlogs"]){
        urlStr = [NSString stringWithFormat:@"https://wifination.ph/mobile/userlogs/?date=%@", param];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
    }];
    

    
}

- (void) postControlPanelUpdate:(NSDictionary *)settingsDict completion:(void (^)(NSString *))completion{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    for (id setting in settingsDict[@"settings"]){
        [parameters setValue:setting[@"value"] forKey:setting[@"name"]];
    }
    NSString *urlStr = [NSString stringWithFormat:@"https://wifination.ph/mobile/controlpanel/update/?id=%@", settingsDict[@"id"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *statusCode = [NSString stringWithFormat:@"%d", [operation.response statusCode]];
        completion(statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
    }];

   
}

- (void) postDeviceToken:(NSString *)deviceToken forDevice:(NSString *)device withTag:(NSString *)tag{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *parameters = @{@"device": device, @"deviceID": @"", @"token": deviceToken, @"tag": tag};
    [manager POST:@"http://dev.wifination.ph:3000/mobile/oauth" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [responseObject valueForKeyPath:@"status"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}


- (void) getAnalyticsFor: (NSString *)ap withRange:(NSString *)range completion:(void(^)(NSDictionary *))completion{
    NSString *urlStr = [NSString stringWithFormat:@"https://wifination.ph/mobile/analytics/?date=%@&id=%@", range, ap];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
    }];
    
}


@end
