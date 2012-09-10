//
//  ReturnStatusCode.h
//  LianLuoQuan
//
//  Created by 文 博 on 11-4-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DATypeDefine.h"
#import "RemindEntity.h"
@interface ReturnStatusCode : NSObject {
	BOOL isSucceed;//客户端请求是否发送成功
    BOOL isCancel;//客户端请求是否发送成功
	NSString* failReason;//失败原因
    NSString* failReasonCode;
    BusinessErrorCode businessErrorCode;  //tank：2011.8.31业务层错误代码
    RemindEntity * remindEntity;          //tank:2011.10.19增加提醒字段，新原子封装放回值，提供这些字段了
    NSString* rateOfFlow;//wwb:2012-02-16 流量
}

@property BOOL isSucceed;
@property BOOL isCancel;
@property (nonatomic,retain) NSString* failReason;
@property (nonatomic,retain) NSString* failReasonCode;
@property BusinessErrorCode businessErrorCode;
@property (nonatomic,retain) RemindEntity * remindEntity; 
@property (nonatomic,retain) NSString* rateOfFlow;

//tank:2011.10.24从服务器错误码，转换为应用需要的错误码 枚举
+ (BusinessErrorCode)getBusinessErrorCode : (NSString*)serverFailCode;


@end
