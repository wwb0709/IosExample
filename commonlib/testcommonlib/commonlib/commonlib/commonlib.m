//
//  commonlib.m
//  commonlib
//
//  Created by wangwb on 13-6-28.
//  Copyright (c) 2013年 wangwb. All rights reserved.
//

#import "commonlib.h"


@implementation commonlib

- (NSInteger) add:(NSInteger)a and:(NSInteger)b {
    NSLog(@"add %d+%d=%d",a,b,a+b);
    return a + b;
}

+ (NSString*) connect:(NSString *)str1 and:(NSString *)str2 {
    return [NSString stringWithFormat:@"%@ %@", str1, str2];
}
@end