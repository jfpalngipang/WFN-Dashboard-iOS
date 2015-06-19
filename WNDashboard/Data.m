//
//  Data.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/19/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import "Data.h"
#import "requestUtility.h"

@implementation Data
{
   
}

- (void) fillAPArrays{
    self.apNames = [[NSMutableArray alloc] init];
    self.apIds = [[NSMutableArray alloc] init];
    requestUtility *reqUtil = [[requestUtility alloc] init];
    
    [reqUtil GETRequestSender:@"getAPList" completion:^(NSDictionary *responseDict){
        for (id ap in responseDict){
            [self.apNames addObject:ap[1]];
            [self.apIds addObject:ap[0]];
        }
        NSLog(@"AP: %@", self.apNames);
        NSLog(@"AP: %@", self.apIds);
    }];
}

- (NSString *) getIdForAPAtIndex: (NSUInteger)index{
    NSString *apId = [[NSString alloc] init];
    apId = [self.apIds objectAtIndex:index];
    
    return apId;
}

@end
