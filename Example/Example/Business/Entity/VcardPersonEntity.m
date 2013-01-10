//
//  VcardPersonEntity.m
//  Example
//
//  Created by wangwb on 13-1-6.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import "VcardPersonEntity.h"


@implementation VcardPersonEntity
@synthesize NameArr;
@synthesize PhoneArr;
@synthesize EmailArr;
@synthesize AddrArr;
@synthesize SocialArr;
@synthesize URLArr;
@synthesize AIMArr;

@synthesize remark;
@synthesize date;
@synthesize depart;
@synthesize company;
@synthesize zhiwei;
@synthesize ID;

-(id)	init
{
	if(self=[super init])
	{
        NameArr = [[NSMutableDictionary alloc] init];
        PhoneArr = [[NSMutableDictionary alloc] init];
        EmailArr = [[NSMutableDictionary alloc] init];
        AddrArr = [[NSMutableDictionary alloc] init];
        SocialArr = [[NSMutableDictionary alloc] init];
        URLArr = [[NSMutableDictionary alloc] init];
        AIMArr = [[NSMutableDictionary alloc] init];
        remark = nil;
        date = nil;
        depart = nil;
        company = nil;
        zhiwei = nil;
        ID = nil;

	}
	
	return self;
}
-(void)	dealloc
{
	[self clear];
	[super dealloc];
}

-(void) clear
{
    
    [NameArr release];
    NameArr = nil;
    [PhoneArr release];
    PhoneArr = nil;
    [EmailArr release];
    EmailArr = nil;
    [AddrArr release];
    AddrArr = nil;
    [SocialArr release];
    SocialArr = nil;
    [URLArr release];
    URLArr = nil;
    [AIMArr release];
    AIMArr = nil;
    
    [remark release];
    remark = nil;
    [date release];
    date = nil;
    [depart release];
    depart = nil;
    [company release];
    company = nil;
    [zhiwei release];
    zhiwei = nil;
    [ID release];
    ID = nil;
}




@end
