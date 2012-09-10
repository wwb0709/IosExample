//
//  RemindEntity.m
//  LianLuoQuan
//
//  Created by Tank on 11-10-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RemindEntity.h"

@implementation RemindEntity

@synthesize unreadDynamicCnt;
@synthesize unreadMessageCnt;
@synthesize quanCnt;
@synthesize unreadPrivateLetterCnt;


-(RemindEntity *)entityDeepCopy
{
	RemindEntity * retEntity = [[RemindEntity alloc]init];
	
	//0
	retEntity.unreadDynamicCnt = self.unreadDynamicCnt;
    retEntity.unreadMessageCnt = self.unreadMessageCnt;
	retEntity.quanCnt = self.quanCnt;
	retEntity.unreadPrivateLetterCnt = self.unreadPrivateLetterCnt;
    
	
	return retEntity;	
}


-(id)	init
{
	if (self= [super init])
	{
		unreadDynamicCnt = nil;
        unreadMessageCnt = nil;
		quanCnt = nil;
		unreadPrivateLetterCnt = nil;
	}
	
	return self;
}

-(void)	dealloc
{
    self.unreadDynamicCnt = nil;
    
    self.unreadMessageCnt = nil;

    self.quanCnt = nil;

    self.unreadPrivateLetterCnt = nil;
    
	[super dealloc];
}

@end
