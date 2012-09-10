//
//  ReturnStatusCode.m
//  LianLuoQuan
//
//  Created by 文 博 on 11-4-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReturnStatusCode.h"


@implementation ReturnStatusCode

@synthesize	isSucceed;
@synthesize	failReason;
@synthesize	failReasonCode;
@synthesize businessErrorCode;
@synthesize isCancel;
@synthesize remindEntity; 
@synthesize rateOfFlow;


//tank:2011.10.24从服务器错误码，转换为应用需要的错误码 枚举
+ (BusinessErrorCode)getBusinessErrorCode : (NSString*)serverFailCode
{
    BusinessErrorCode retErrorCodeType = BusinessErrorCode_None;
    if ([serverFailCode.lowercaseString isEqualToString:@"err:00"]) 
    {
        retErrorCodeType = BusinessErrorCode_LLQ_ServerError00;
    }
    else if([serverFailCode.lowercaseString isEqualToString:@"err:05"])
    {
        retErrorCodeType = BusinessErrorCode_LLQ_ServerError05;
    }
    else if([serverFailCode.lowercaseString isEqualToString:@"err:25"])
    {
        retErrorCodeType = BusinessErrorCode_LLQ_ServerError25;
    }
    else if([serverFailCode.lowercaseString isEqualToString:@"err:26"])
    {
        retErrorCodeType = BusinessErrorCode_LLQ_ServerError26;
    }
    
    return retErrorCodeType;
}

-(id) init
{
	self= [super init];
	if (self) 
	{		
        isCancel=NO;
		isSucceed = NO;		
		failReason = nil;
        failReasonCode = nil;
        remindEntity = nil;
        businessErrorCode = BusinessErrorCode_None;
        rateOfFlow = nil;
	}
    
    RemindEntity * tmpEntity = [[RemindEntity alloc] init];
    self.remindEntity = tmpEntity;
    [tmpEntity release];
    
	return self;
}

-(void) dealloc
{
	self.failReason = nil;
    self.failReasonCode = nil;	
    self.remindEntity = nil;
    self.rateOfFlow = nil;
	[super dealloc];
}

@end
