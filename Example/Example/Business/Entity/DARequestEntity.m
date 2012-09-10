//
//  DARequestEntity.m
//  DigitAlbum
//
//  Created by  on 11-10-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DARequestEntity.h"

@implementation DARequestEntity
@synthesize RRequestID;//请求编号，用于取消请求
@synthesize RRequestDesc;//请求描述，用于日志跟踪输出
@synthesize RRequestState;//请求状态
@synthesize RError;//错误信息，在state为error时包含的错误信息
@synthesize RRequestObj;//请求的数据实体
@synthesize RReturnObj;//返回的数据
@synthesize RRequestType;//请求类型
@synthesize RProgressView;
@synthesize RServerCode;
@synthesize RServerDesc;
@synthesize RData;
@synthesize RSavePath;
@synthesize progress;
@synthesize progressTitle;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}
@end
