//
//  CacheUtil.m
//  ColorsTrip
//
//  Created by Steve Jobs on 12-3-1.
//  Copyright 2012年 Apple inc. All rights reserved.
//

#import "CacheUtil.h"


@implementation CacheUtil

+(id)cachedItemsFor:(NSString*)key {
	NSUserDefaults* defaults= [NSUserDefaults standardUserDefaults];
	NSString* item = [defaults objectForKey:key];
	return item;
}

+(void)cacheItems:(id)item for:(NSString*)key {
	NSUserDefaults* defaults= [NSUserDefaults standardUserDefaults];
	[defaults setObject:item forKey:key];
    [defaults synchronize];
}

+(void)removeCacheItem:(NSString*)key {
	NSUserDefaults* defaults= [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:key];
}


@end
