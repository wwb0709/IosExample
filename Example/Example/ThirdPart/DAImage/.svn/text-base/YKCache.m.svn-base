//
//  YKCache.m
//  VANCL
//
//  Created by yek on 10-12-22.
//  Copyright 2010 yek. All rights reserved.
//

#import "YKCache.h"


@implementation YKCacheItem
@synthesize object;
@synthesize key;
@synthesize expireDate;

-(void) encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeObject:key forKey:@"key"];
	[aCoder encodeObject:expireDate forKey:@"expireDate"];
	[aCoder encodeObject:object forKey:@"object"];
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
	if(self){
		self.key=[aDecoder decodeObjectForKey:@"key"];
		self.expireDate=[aDecoder decodeObjectForKey:@"expireDate"];
		self.object=[aDecoder decodeObjectForKey:@"object"];
	}
	return self;
}
-(void) dealloc{
	[key release];
	[object release];
	[expireDate release];
	[super dealloc];
}

@end



@implementation YKMemoryCache

-(id) init{
    self=[super init];
	if(self){
		//fileBasePath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"FileCache"];
		dic=[[NSMutableDictionary alloc] init];
	}
	return self;
}
-(void) dealloc{
	[dic release];
	[super dealloc];
}

-(void) setObject:(id <NSCoding>)object forKey:(id)key{
	[self setObject:object forKey:key expireDate:[NSDate distantFuture]];
}
-(void) setObject:(id <NSCoding>)object forKey:(id)key expireDate:(NSDate *)expireDate{
	assert(key!=nil);
	if(object==nil){
		[self removeObjectForKey:key];
	}else{
		YKCacheItem* item=[[YKCacheItem alloc] init];
		item.key=key;
		item.object=object;
		item.expireDate=expireDate;
		@synchronized(dic){
			[dic setObject:item forKey:key];
		}
		[item autorelease];
	}
}

-(void) removeObjectForKey:(id)key{
	assert(key!=nil);
	@synchronized(dic){
		[dic removeObjectForKey:key];
	}
}

-(id) objectForKey:(id)key{
	assert(key!=nil);
	id ret=nil;
	YKCacheItem* item=[dic objectForKey:key];
	if(item!=nil){
		NSDate* nowDate=[NSDate date];
		if([nowDate compare:item.expireDate]==NSOrderedAscending){
			ret=item.object;
		}else{
			[self removeObjectForKey:key];
		}
	}
	return ret;
}

-(int) count{
	return [dic count];
}
@end

@implementation YKFileCache
NSString* const YKFileCacheFileName=@"FileCache_default2.dat";

-(void) internalInit{
	if(autoSaveInterval<=0){
		autoSaveInterval=10;
	}
	if([[NSFileManager defaultManager] fileExistsAtPath:dicFilePath]){
		//dic=[[NSMutableDictionary dictionaryWithContentsOfFile:dicFilePath] retain];
		dic=[[NSKeyedUnarchiver unarchiveObjectWithFile:dicFilePath] retain];
	}
	
	if(nil==dic || ![dic isKindOfClass:[NSMutableDictionary class]]){
		if(dic!=nil){[dic release];}
		dic=[[NSMutableDictionary alloc] init];
	}
	assert(dic!=nil);
	//NSLog(@"YKFileCache::internalInit dic=%@",dic);
	needSave=NO;
	saveTimer=[NSTimer scheduledTimerWithTimeInterval:autoSaveInterval target:self selector:@selector(save:) userInfo:nil repeats:YES];
}

-(void) save{
	assert(dicFilePath!=nil);
	NSMutableDictionary* tempDic=[[NSMutableDictionary alloc] init];
	@synchronized(dic){
		[tempDic addEntriesFromDictionary:dic];
	}
	NSArray* keyArray=[tempDic allKeys];
	NSMutableArray* toRemoveKeyArray=[[NSMutableArray alloc] init];
	for(id key in keyArray){
		if([tempDic objectForKey:key]==nil){
			[toRemoveKeyArray addObject:key];
		}
	}
	[tempDic removeObjectsForKeys:toRemoveKeyArray];
	[toRemoveKeyArray release];
	
	BOOL success=[NSKeyedArchiver archiveRootObject:tempDic toFile:dicFilePath];
	[tempDic release];
	assert(success);
}

-(void) save:(NSTimer*) timer{
	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
	if(needSave){
		[self save];
	}
	needSave=NO;
	[pool release];
}

-(id) init{
    self=[super init];
	if(self){
		dicFilePath=[documentFilePath(YKFileCacheFileName) copy];
		autoSaveInterval=10;
		[self internalInit];
	}
	return self;
}

-(id) initWithFileName:(NSString*) fileName{
    self=[super init];
	if(self){
		dicFilePath=[documentFilePath(fileName) copy];
		autoSaveInterval=10;
		[self internalInit];
	}
	return self;
}
-(id) initWithFilePath:(NSString*) filePath{
    self=[super init];
	if(self){
		dicFilePath=[filePath copy];
		autoSaveInterval=10;
		[self internalInit];
	}
	return self;
}
-(id) initWithFileName:(NSString*) fileName autoSaveInterval:(NSTimeInterval) interval{
    self=[super init];
	if(self){
		dicFilePath=[documentFilePath(fileName) copy];
		autoSaveInterval=interval;
		[self internalInit];
	}
	return self;
}
-(id) initWithFilePath:(NSString*) filePath autoSaveInterval:(NSTimeInterval) interval{
    self=[super init];
	if(self){
		dicFilePath=[filePath copy];
		autoSaveInterval=interval;
		[self internalInit];
	}
	return self;
}

-(void) dealloc{
	[saveTimer invalidate];
	[self save];
	[dic release];
	[dicFilePath release];
	[super dealloc];
}
/*
 return $(tempdir)/[yyyy]/[MM]/[dd]/[HH]/[mm]
 */
-(NSString*) getPath:(YKCacheItem*)item{
	NSDate* nowDate=[NSDate date];
	
	NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
	NSArray* formatterArray=[NSArray arrayWithObjects:@"yyyy",@"MM",@"dd",@"HH",@"mm",nil];
	NSString* ret=NSTemporaryDirectory();
	for(NSString* formatter in formatterArray){
		[dateFormatter setDateFormat:formatter];
		ret=[ret stringByAppendingPathComponent:[dateFormatter stringFromDate:nowDate]];
	}
	NSFileManager* fm=[NSFileManager defaultManager];
	if(![fm fileExistsAtPath:ret]){
		[fm createDirectoryAtPath:ret withIntermediateDirectories:YES attributes:nil error:nil];
	}
	ret=[ret stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.dat",[nowDate timeIntervalSince1970] ]];
	//NSLog(@"YKFileCache::getPath return %@",ret);
	[dateFormatter release];
	assert(ret!=nil);
	return ret;
}
-(void) setObject:(id <NSCoding>)object forKey:(id)key{
	[self setObject:object forKey:key expireDate:[NSDate distantFuture]];
}

-(void) setObject:(id <NSCoding>)object forKey:(id)key expireDate:(NSDate *)expireDate{
	//NSLog(@"object is %@ , key is %@ expireData is %@",[object class], [key class], [expireDate class]);
	assert(key!=nil);
	if(object==nil){
		[self removeObjectForKey:key];
	}else{	
        YKCacheItem* item=[dic objectForKey:key];
        if(nil==item){
            item=[[YKCacheItem alloc] init];
            item.key=key;
            item.object=[self getPath:key];
            item.expireDate=expireDate;
            @synchronized(dic){
                [dic setObject:item forKey:key];
            }
            [item release];
        }
        NSString* objectFilePath=(NSString*)item.object;
        assert(objectFilePath!=nil);
        [NSKeyedArchiver archiveRootObject:object toFile:objectFilePath];
        //BOOL saveok=[NSKeyedArchiver archiveRootObject:object toFile:objectFilePath];
        //todo:fixme assert(saveok);
    }
	needSave=YES;
}

-(id) objectForKey:(id)key{
	assert(key!=nil);
	id ret=nil;
	YKCacheItem* item=[dic objectForKey:key];
	if(item!=nil){
		NSDate* nowDate=[NSDate date];
		if([nowDate compare:item.expireDate]==NSOrderedDescending){
			//过期
			[self removeObjectForKey:key];
		}else{
			NSString* objectFilePath=(NSString*)item.object;
			assert(objectFilePath!=nil);
			if([[NSFileManager defaultManager] fileExistsAtPath:objectFilePath]){
				ret=[NSKeyedUnarchiver unarchiveObjectWithFile:objectFilePath];
			}
		}
	}
	return ret;
}

-(void) removeObjectForKey:(id)key{
	assert(key!=nil);
	YKCacheItem* item=[dic objectForKey:key];
	if(item!=nil){
		NSString* objectFilePath=(NSString*)item.object;
		[[NSFileManager defaultManager] removeItemAtPath:objectFilePath error:nil];		
		@synchronized(dic){
			[dic removeObjectForKey:key];
		}
	}
	needSave=YES;
}
-(int) count{
	return [dic count];
}

//清除缓存
-(void)clearCache{
	YKCacheItem* item = nil;
	NSDate *nowDate = [NSDate date]; //取得当前日期
	//遍历字典 dic 依次判断文件是否过期，若过期则删除，若没有过期，则跳过
	NSMutableArray *keysOfDel = nil;  //记录被删除的KEY
	BOOL isDelAllSucce = YES;
    NSError *error;

	for (id key in dic) 
	{
		item = [dic objectForKey:key];
		//判断文件是否过期
		if ([nowDate compare:item.expireDate] == NSOrderedDescending){
		
			NSString *filePath = (NSString *)item.object;

		    if([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]){
			   [keysOfDel addObject:key]; 
		    }
	        else {
			   isDelAllSucce = NO;
		    }
		}	
	}
	
	@synchronized(dic){
		if (isDelAllSucce && keysOfDel!= nil) {
			[dic removeAllObjects];
		}
		else{
			[dic removeObjectsForKeys:keysOfDel];
		}
		
	}
	needSave = YES;
}

+(void) test{
	YKFileCache* cache=[[YKFileCache alloc] init];
	NSString* const oriString=@"fdsafdsafdsa fdsjaf dls辅导士大夫的萨芬大师傅d";
	NSString* const key=@"oriString";
	[cache setObject:oriString forKey:key];
	[cache save];
	NSString* newString=[cache objectForKey:key];
	if([oriString compare:newString]!=NSOrderedSame){
		NSLog(@"!!!error cache 可能工作不正常");		
	}
	NSLog(@"oriString=%@\n newString=%@",oriString,newString);
	[cache release];
}



@end



NSString* documentFilePath(NSString* fileName){
	assert(fileName!=nil);
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* ret=[documentsDirectory stringByAppendingPathComponent:fileName];
	assert(ret!=nil);
//	NSLog(@"documentFilePath(%@) return %@",fileName,ret);
	return ret;
}

