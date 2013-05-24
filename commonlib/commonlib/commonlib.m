//
//  commonlib.m
//  commonlib
//
//  Created by wangwb on 13-5-17.
//  Copyright (c) 2013年 wangwb. All rights reserved.
//

#import "commonlib.h"

@implementation commonlib
- (NSInteger) add:(NSInteger)a and:(NSInteger)b {
    return a + b;
}

+ (NSString*) connect:(NSString *)str1 and:(NSString *)str2 {
    return [NSString stringWithFormat:@"%@ %@", str1, str2];
}
@end
