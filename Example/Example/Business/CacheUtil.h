//
//  CacheUtil.h
//  ColorsTrip
//
//  Created by Steve Jobs on 12-3-1.
//  Copyright 2012年 Apple inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CacheUtil : NSObject {
    
}

+(id)cachedItemsFor:(NSString*)key;
+(void)cacheItems:(id)item for:(NSString*)key;
+(void)removeCacheItem:(NSString*)key;

@end
