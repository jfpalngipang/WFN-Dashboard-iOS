//
//  fbGraphUtility.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/17/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fbGraphUtility : NSObject

- (void)getFBPhoto:(NSString *)fbId completion:(void (^)(NSDictionary *)) completion;
@end
