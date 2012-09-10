//
//  DARequestEntity.h
//  DigitAlbum
//
//  Created by  on 11-10-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DATypeDefine.h"
#import "ASIHTTPRequest.h"

@interface DARequestEntity : NSObject
{
    NSString *RRequestID;//请求编号，用于取消请求
    NSString *RRequestDesc;//请求描述，用于日志跟踪输出
    DARequestStateEnum RRequestState;//请求状态
    NSError *RError;//错误信息，在state为error时包含的错误信息
    NSObject *RRequestObj;//请求的数据实体
    NSObject *RReturnObj;//返回的数据
    DARequestTypeEnum RRequestType;//请求类型
    UIProgressView *RProgressView;//请求进度
    NSString *RServerCode;//服务器端返回代码
    NSString *RServerDesc;//服务器端返回描述
    NSIndexPath *RData;
    NSString *RSavePath;//下载文件时使用，文件保存路径
    float progress;//进度
    NSString *progressTitle;//进度标题
}
@property(nonatomic,retain)NSIndexPath *RData;
@property(nonatomic,retain) NSString *RRequestID;//请求编号，用于取消请求
@property(nonatomic,retain) NSString *RRequestDesc;//请求描述，用于日志跟踪输出
@property DARequestStateEnum RRequestState;//请求状态
@property(nonatomic,retain) NSError *RError;//错误信息，在state为error时包含的错误信息
@property(nonatomic,retain) NSObject *RRequestObj;//请求的数据实体
@property(nonatomic,retain) NSObject *RReturnObj;//返回的数据
@property DARequestTypeEnum RRequestType;//请求类型
@property(nonatomic,retain) UIProgressView *RProgressView;
@property(nonatomic,retain) NSString *RServerCode;
@property(nonatomic,retain) NSString *RServerDesc;
@property(nonatomic,retain) NSString *RSavePath;
@property float progress;//进度
@property(nonatomic,retain) NSString *progressTitle;
@end
