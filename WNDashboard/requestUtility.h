//
//  requestUtility.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/8/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface requestUtility : NSObject

- (NSDictionary*) LoginRequestWithUsername: (NSString *)username andPassword: (NSString *)password;
- (void) GETRequestSender: (NSString *) type completion:(void (^)(NSDictionary *)) completion;



@end
