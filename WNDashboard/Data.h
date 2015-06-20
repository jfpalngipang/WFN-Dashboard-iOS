//
//  Data.h
//  WNDashboard
//
//  Created by Jan Franz Palngipang on 6/19/15.
//  Copyright (c) 2015 Jan Franz Palngipang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject
{
    NSString *feedsURL;
    
}

@property NSMutableArray *apNames;
@property NSMutableArray *apIds;



- (void) fillAPArrays;
- (NSString *) getIdForAPAtIndex: (NSUInteger)index;

@end
