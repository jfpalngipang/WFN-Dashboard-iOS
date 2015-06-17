//
//  fbGraphUtility.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/17/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "fbGraphUtility.h"

@implementation fbGraphUtility

- (void)getFBPhoto:(NSString *)fbId completion:(void (^)(NSData *)) completion{
    NSString * URLStr = [NSString stringWithFormat: @"https://graph.facebook.com/v2.3/%@/picture?", fbId];
    NSURL *fbURL = [NSURL URLWithString:URLStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:fbURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        completion(data);
        //NSLog(@"RESP: %@", data);
    }];
    
    [task resume];
    
}

@end
