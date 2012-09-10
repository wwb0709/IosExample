//
//  DANetworkEntity.h
//  DigitAlbum
//
//  Created by  on 11-10-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DARequestEntity.h"

@interface DANetworkEntity : NSObject
{
    DARequestEntity *NRequestEntity;//请求的实体
    NSMutableDictionary *NRequestParamDir;//参数字典
    NSString *NReturnXml;//服务器端返回的xml
    NSData *NReturnData;//返回的数据
    NSString *NRequestUrl;//请求的网址
    ASIHTTPRequest *NRequest;//请求实体
    DAReturnDataTypeEnum NDataType;//返回的数据类型
    DANetworkTypeEnum NNetworkType;//网络请求类型
}

@property(nonatomic,retain) DARequestEntity *NRequestEntity;//请求的实体
@property(nonatomic,retain) NSMutableDictionary *NRequestParamDir;//参数字典
@property(nonatomic,retain) NSString *NReturnXml;//服务器端返回的xml
@property(nonatomic,retain) NSData *NReturnData;
@property(nonatomic,retain) NSString *NRequestUrl;
@property(nonatomic,retain) ASIHTTPRequest *NRequest;
@property DAReturnDataTypeEnum NDataType;
@property DANetworkTypeEnum NNetworkType;
@end
