//
//  requestUtility.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "requestUtility.h"

@implementation requestUtility
{
    NSURL *loginURL;
    NSURL *userLogsURL;

}



- (void) requestSender: (NSMutableURLRequest *) request withType: (NSString *) type withOption: (NSString *) option completion:(void (^)(NSDictionary *)) completion{
    __block NSDictionary *result;
    
  
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    if([type  isEqual: @"login"]){
        sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", option],@"Accept" : @"application/json"};
        
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue: nil];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        completion(result);
    }];
    
    [dataTask resume];

   
    
}
- (NSDictionary*) LoginRequestWithUsername: (NSString *)username andPassword: (NSString *)password {
    NSURL *loginURL = [NSURL URLWithString:@"http://dev.wifination.ph:3000/login_app/"];
    NSDictionary *result;
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"WebKitFormBoundary";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"username"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", username] dataUsingEncoding:NSUTF8StringEncoding]];
        
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"password"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", password] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: loginURL];
        
    request.HTTPMethod = @"POST";
    request.HTTPBody = body;
    
    [self requestSender:request withType:@"login" withOption: boundary completion:^(NSDictionary *responseDict){
        NSLog(@"RESPONSE: %@", responseDict);
    }];
    
    return result;
    
}

- (void) GETRequestSender: (NSString *) type completion:(void (^)(NSDictionary *)) completion{
   
    NSURL *url;
    if([type  isEqual: @"getFeeds"]) {
        url = [NSURL URLWithString:@"http://dev.wifination.ph:3000/mobile/feed/"];
    } else if([type  isEqual: @"getUserLogs"]){
        url = [NSURL URLWithString:@"http://dev.wifination.ph:3000/mobile/userlogs/"];
    } else if([type isEqual:@"getAPSettings"]){
        url = [NSURL URLWithString:@"http://dev.wifination.ph:3000/mobile/apsettings/"];
    } else if([type isEqual:@"getSurveys"]){
        url = [NSURL URLWithString:@"http://dev.wifination.ph:3000/mobile/survey/"];
    } else if([type isEqual:@"getAnalytics"]){
        url = [NSURL URLWithString:@"http://dev.wifination.ph:3000/mobile/analytics/"];
    } else if([type isEqual:@"getAPList"]){
        url = [NSURL URLWithString:@"http://dev.wifination.ph:3000/mobile/accesspoints/"];
    } else if([type isEqual:@"getMessages"]){
        url = [NSURL URLWithString:@"http://dev.wifination.ph:3000/mobile/testimonials/"];
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"GET";

    [self requestSender:request withType: type withOption: nil completion:^(NSDictionary *responseDict){
        completion(responseDict);
    }];

}

- (void) GETRequestSender: (NSString *)type withParams: (NSString *)param completion:(void(^)(NSDictionary *))completion{
    NSURL *url;
    NSString *url_str;
    if([type isEqualToString:@"getSurveyDetails"]){
        url_str = [NSString stringWithFormat:@"http://dev.wifination.ph:3000/mobile/detailedsurvey/?id=%@", param];
        url = [NSURL URLWithString:url_str];
    } else if([type isEqualToString:@"getRPM"]){
        url_str = [NSString stringWithFormat:@"http://dev.wifination.ph:3000/mobile/rpm/?id=%@", param];
        url = [NSURL URLWithString:url_str];
    } else if([type  isEqual: @"getUserLogs"]){
        url_str = [NSString stringWithFormat:@"http://dev.wifination.ph:3000/mobile/userlogs/?date=%@", param];
        url = [NSURL URLWithString:url_str];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"GET";
    [self requestSender:request withType: type withOption: nil completion:^(NSDictionary *responseDict){
        completion(responseDict);
    }];
    
}

- (void) ControlPanelPOSTRequestSender{
    
}

@end
