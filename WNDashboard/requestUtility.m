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
        NSLog(@"Success: %@", responseObject);
        status = [responseObject valueForKeyPath:@"status"];
        completion(status);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
        NSLog(@"JSON: %@", responseObject);
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
        NSLog(@"JSON: %@", responseObject);
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
        NSLog(@"Success: %@", responseObject);
        NSString *statusCode = [NSString stringWithFormat:@"%d", [operation.response statusCode]];
        completion(statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
        NSLog(@"RESPONSE OF DEVICE TOKEN POST: %@", status);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR POSTING DEVICE TOKEN: %@", error);
    }];
}


- (void) requestSender: (NSMutableURLRequest *) request withType: (NSString *) type withOption: (NSString *) option completion:(void (^)(NSDictionary *)) completion{
    __block NSDictionary *result;
    
  
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    if([type  isEqual: @"login"]){
        sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", option],@"Accept" : @"application/json"};
        
    }
    if([type isEqualToString:@"resetPassword"]){
        NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue: nil];
        
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            //completion(result);
            NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
            NSDictionary *fields = [resp allHeaderFields];
            NSString *cookie = [fields valueForKey:@"Set-Cookie"];
            NSArray *responseStrings = [cookie componentsSeparatedByString:@";"];
            NSArray *cookieParts = [responseStrings[0] componentsSeparatedByString:@"="];
            NSLog(@"RESET RESPONSE: %@", cookieParts[1]);
            //NSDictionary *cookieDict = [[NSDictionary alloc] init];
            //[cookieDict setValue:cookieParts[1] forKey:@"cookie"];
            //[result setValue:[NSString stringWithFormat:@"%@", cookieParts[1]] forKey:@"cookie"];
            completion(cookieParts[1]);
            //NSLog(@"COOKIE: %@", result);
        }];
        [dataTask resume];
    }else {
        NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue: nil];
        
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            completion(result);
        }];
        NSLog(@"HELLLLO!");
        
        [dataTask resume];
    }


   
    
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

- (void) resetPasswordWithToken:(NSString*)token andEmail:(NSString*)email completion:(void (^)(NSDictionary *)) completion{
     __block NSDictionary *result;
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"WebKitFormBoundary";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"email"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", token] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"csrfmiddlewaretoken"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", email] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://dev.wifination.ph:3000/password_reset/"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = body;
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary],@"Accept" : @"application/json"};
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue: nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        //NSDictionary *fields = [resp allHeaderFields];
        NSString *status = [NSString stringWithFormat:@"%ld",(long)resp.statusCode];
        NSLog(@"STATUS CODE: %@", status);
        completion(status);
        //NSString *status = [fields valueForKey:@"Set-Cookie"];
        /*
        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[resp allHeaderFields] forURL:[response URL]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:[response URL] mainDocumentURL:nil];
        */
        //NSArray *responseStrings = [cookie componentsSeparatedByString:@";"];
        //NSArray *cookieParts = [responseStrings[0] componentsSeparatedByString:@"="];
        //NSLog(@"RESET RESPONSE: %@", cookieParts[1]);
        //NSDictionary *cookieDict = [[NSDictionary alloc] init];
        //[cookieDict setValue:cookieParts[1] forKey:@"cookie"];
        //[result setValue:[NSString stringWithFormat:@"%@", cookieParts[1]] forKey:@"cookie"];
        //completion(cookieParts[1]);
    }];

    
    [dataTask resume];
}

- (void) GETRequestSender: (NSString *) type completion:(void (^)(NSDictionary *)) completion{
   
    NSURL *url;
    if([type  isEqual: @"getFeeds"]) {
        url = [NSURL URLWithString:@"https://wifination.ph/mobile/feed/"];
    } else if([type  isEqual: @"getUserLogs"]){
        url = [NSURL URLWithString:@"https://wifination.ph/mobile/userlogs/"];
    } else if([type isEqual:@"getAPSettings"]){
        url = [NSURL URLWithString:@"https://wifination.ph/mobile/apsettings/"];
    } else if([type isEqual:@"getSurveys"]){
        url = [NSURL URLWithString:@"https://wifination.ph/mobile/survey/"];
    } else if([type isEqual:@"getAnalytics"]){
        url = [NSURL URLWithString:@"https://wifination.ph/mobile/analytics/"];
    } else if([type isEqual:@"getAPList"]){
        url = [NSURL URLWithString:@"https://wifination.ph/mobile/accesspoints/"];
    } else if([type isEqual:@"getMessages"]){
        url = [NSURL URLWithString:@"https://wifination.ph/mobile/testimonials/"];
    } else if([type isEqual:@"getTerms"]){
        url = [NSURL URLWithString:@"https://wifination.ph/mobile/terms/"];
    } else if ([type isEqual:@"getTerms"]){
        url = [NSURL URLWithString:@"https://wifination.ph/mobile/user_profile/"];
    } else if([type isEqualToString:@"resetPassword"]){
        url = [NSURL URLWithString:@"https://wifination.ph/password_reset/"];
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
- (void) GETAnalyticsFor: (NSString *)ap withRange:(NSString *)range completion:(void(^)(NSDictionary *))completion{
    NSString *urlStr = [NSString stringWithFormat:@"http://dev.wifination.ph:3000/mobile/analytics/?date=%@&id=%@", range, ap];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


@end
