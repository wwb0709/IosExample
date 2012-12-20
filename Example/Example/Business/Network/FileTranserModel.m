//
//  FileTranserModel.m
//  IphoneReader
//
//  Created by TGBUS on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FileTranserModel.h"

@implementation FileTranserModel

@synthesize fileID;
@synthesize fileName;
@synthesize imgUrl;
@synthesize downoadUrl;
@synthesize speed;
@synthesize fileTmpSize;
@synthesize fileTrueSize;
@synthesize remainTime;
@synthesize progress;
@synthesize destationPath;
@synthesize tmpPath;
@synthesize fileTranserState;
@synthesize errorCode;
@synthesize userInfo;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:fileID forKey:@"fileID"];
    [aCoder encodeObject:fileName forKey:@"fileName"];
    [aCoder encodeObject:imgUrl forKey:@"imgUrl"];
    [aCoder encodeObject:downoadUrl forKey:@"downloadUrl"];
    [aCoder encodeObject:remainTime forKey:@"remainTime"];
    [aCoder encodeObject:userInfo forKey:@"userInfo"];
    [aCoder encodeObject:[NSNumber numberWithLongLong:fileTrueSize] forKey:@"fileTrueSize"];
    [aCoder encodeObject:[NSNumber numberWithLongLong:fileTmpSize] forKey:@"fileTmpSize"];
    [aCoder encodeDouble:progress forKey:@"progress"];
    [aCoder encodeObject:destationPath forKey:@"destationPath"];
    [aCoder encodeObject:tmpPath forKey:@"tmpPath"];
    [aCoder encodeInt:fileTranserState forKey:@"fileTranserState"];
    [aCoder encodeInt:errorCode forKey:@"errorCode"];
    [aCoder encodeObject:[NSNumber numberWithLongLong:speed] forKey:@"speed"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if(self)
    {
        self.fileID=[aDecoder decodeIntForKey:@"fileID"];
        self.fileName=[aDecoder decodeObjectForKey:@"fileName"];
        self.imgUrl=[aDecoder decodeObjectForKey:@"imgUrl"];
        self.downoadUrl=[aDecoder decodeObjectForKey:@"downloadUrl"];
        self.remainTime=[aDecoder decodeObjectForKey:@"remainTime"];
        self.userInfo=[aDecoder decodeObjectForKey:@"userInfo"];
        self.fileTrueSize=[[aDecoder decodeObjectForKey:@"fileTrueSize"] longLongValue];
        self.fileTmpSize=[[aDecoder decodeObjectForKey:@"fileTmpSize"] longLongValue];
        self.progress=[aDecoder decodeDoubleForKey:@"progress"];
        self.destationPath=[aDecoder decodeObjectForKey:@"destationPath"];
        self.tmpPath=[aDecoder decodeObjectForKey:@"tmpPath"];
        self.errorCode=[aDecoder decodeIntForKey:@"errorCode"];
        self.fileTranserState=[aDecoder decodeIntForKey:@"fileTranserState"];
        self.speed=[[aDecoder decodeObjectForKey:@"speed"] longLongValue];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    FileTranserModel *copy=[[[self class] copyWithZone:zone] init];
    copy.fileID=self.fileID;
    copy.fileName=[[self.fileName copyWithZone:zone] autorelease];
    copy.fileTmpSize=self.fileTmpSize;
    copy.fileTrueSize=self.fileTrueSize;
    copy.progress=self.progress;
    copy.speed=self.speed;
    copy.imgUrl=[[self.imgUrl copyWithZone:zone] autorelease];
    copy.downoadUrl=[[self.downoadUrl copyWithZone:zone] autorelease];
    copy.remainTime=[[self.remainTime copyWithZone:zone] autorelease];
    copy.destationPath=[[self.destationPath copyWithZone:zone] autorelease];
    copy.tmpPath=[[self.tmpPath copyWithZone:zone] autorelease];
    copy.errorCode=self.errorCode;
    copy.fileTranserState=self.fileTranserState;
    copy.userInfo=[[self.userInfo copyWithZone:zone] autorelease];
    return copy;
}

-(void)dealloc
{
    self.userInfo=nil;
    self.fileName=nil;
    self.imgUrl=nil;
    self.downoadUrl=nil;
    self.remainTime=nil;
    [super dealloc];
}


@end
