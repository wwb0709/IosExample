//
//  ArchiverHelper.m
//  CubeBrowser
//
//  Created by 国翔 韩 on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ArchiverHelper.h"

static ArchiverHelper *instance;

@implementation ArchiverHelper

+(ArchiverHelper *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[ArchiverHelper alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [instance release];
    [super dealloc];
}

-(void)archiveObject:(id)object ByPath:(NSString *)archivePath
{
    NSMutableData *writeData=[[NSMutableData alloc] init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:writeData];
    [archiver encodeObject:object forKey:@"Data"];
    [archiver finishEncoding];
    BOOL flag=[writeData writeToFile:archivePath atomically:YES];
    if(!flag)
    {
        NSLog(@"存入归档失败-------------");
    }
    [archiver release];
    [writeData release];
}

-(id)getObjectByPath:(NSString *)archivePath
{
    NSData *readData=[[NSData alloc] initWithContentsOfFile:archivePath];
    NSKeyedUnarchiver *unArchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:readData];
    id object=[unArchiver decodeObjectForKey:@"Data"];
    [unArchiver finishDecoding];
    [unArchiver release];
    [readData release];
    return object;
}
@end
