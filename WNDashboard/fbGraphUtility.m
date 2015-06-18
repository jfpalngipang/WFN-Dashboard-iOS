//
//  fbGraphUtility.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/17/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "fbGraphUtility.h"
#import <FBSDKCoreKit/FBSDKGraphRequestConnection.h>

@implementation fbGraphUtility

- (void)getFBPhoto:(NSString *)fbId completion:(void (^)(NSDictionary *)) completion{
  
    NSString * URLStr = [NSString stringWithFormat: @"https://graph.facebook.com/v2.3/%@/picture?redirect=false", fbId];
    NSURL *fbURL = [NSURL URLWithString:URLStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:fbURL
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:2];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //NSLog(@"RESP: %@", result);
        completion(result);
    }];
    
    [task resume];
   
    /*
    NSString *path = [NSString stringWithFormat:@"/%@/picture", fbId];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:path
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        NSLog(@"%@", result);
        completion(result);
    }];
     */
}

@end
