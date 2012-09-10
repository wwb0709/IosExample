//
//  DANetworkEntity.m
//  DigitAlbum
//
//  Created by  on 11-10-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DANetworkEntity.h"

@implementation DANetworkEntity
@synthesize NRequestEntity;//请求的实体
@synthesize NRequestParamDir;//参数字典
@synthesize NReturnXml;//服务器端返回的xml
@synthesize NRequestUrl;
@synthesize NRequest;
@synthesize NReturnData;
@synthesize NDataType;
@synthesize NNetworkType;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        NRequestParamDir=[[NSMutableDictionary alloc] init];
        NDataType=DAReturnDataType_String;
        NNetworkType=DANetworkType_HttpRequest;
    }
    
    return self;
}

-(void)dealloc
{
    [NRequestParamDir release];
    [super dealloc];
}
@end
