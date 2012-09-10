//
//  RemindEntity.h
//  LianLuoQuan
//
//  Created by Tank on 11-10-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//tank:通知实体，每次网路请求都会获取到 未读动态数，圈子个数，未读私信总数，未读心跳数 
@interface RemindEntity : NSObject {
	NSString * unreadDynamicCnt;      //未读动态数
    NSString * unreadMessageCnt;      //未读通知数
	NSString * quanCnt;               //圈子个数
	NSString * unreadPrivateLetterCnt;   //未读私信数
}

@property (nonatomic, retain) NSString * unreadDynamicCnt;
@property (nonatomic, retain) NSString * unreadMessageCnt;
@property (nonatomic, retain) NSString * quanCnt;
@property (nonatomic, retain) NSString * unreadPrivateLetterCnt;

-(RemindEntity *)entityDeepCopy;

@end
