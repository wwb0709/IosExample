//
//  UserService.m
//  LianLuoQuan
//
//  Created by 文 博 on 11-4-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserService.h"
//#import "CommonResource.h"
#import "CustomLog.h"
#import "SBJSON.h"
//#import "ReturnResponseEntity.h"

#import "DATypeDefine.h"
//#import "JsonParse.h"
#import "DAUtility.h"
//#import "XMLParse.h"
@implementation UserService

-(void) testPost
{

//    SBJSON * tmpJSON = [[SBJSON alloc] init];
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setValue:phone forKey:AH_USER_M];
//    [dict setValue:password forKey:AH_USER_LOGIN_PASSWORD];
//    
//    NSString* json = [tmpJSON stringWithObject:dict];
//    [tmpJSON release];
//    
//	printLog(@"%@",json);
//    int random = arc4random() % 1000;
    NSString* url = @"http://192.168.1.58:8080/ColorsTripServ/servlet/UploadServlet";
    
    DAAsynNetwork *asynNetwork=[DAAsynNetwork getIntance];
    DANetworkEntity *networkEntity=[[[DANetworkEntity alloc] init] autorelease];
    networkEntity.NRequestEntity=[[[DARequestEntity alloc] init] autorelease];
    networkEntity.NRequestEntity.RRequestType=DARequestType_User_Login;
    networkEntity.NRequestUrl=url;
    networkEntity.NNetworkType=DANetworkType_FormDataRequest;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:@"2" forKey:KPOSTFILENAME];
    [dic setObject:@"png" forKey:KPOSTCONTENTTYPE];
    [networkEntity.NRequestParamDir setObject:dic forKey:@"avatar"];
    [asynNetwork requestData:self networkInfo:networkEntity];

}
-(void)NetworkReturn:(DANetworkEntity *)networkEntity
{
    if(networkEntity.NRequestEntity.RRequestState==DARequestState_Fail)
    {
        networkEntity.NRequestEntity.RServerDesc = @"网络连接失败";
    }

    if(networkEntity.NReturnXml && [networkEntity.NReturnXml length]>0)//成功 
    {
        printLog(@"networkEntity.NReturnXml :%@",networkEntity.NReturnXml);
        networkEntity.NRequestEntity.RServerCode=@"success"; 
        networkEntity.NRequestEntity.RReturnObj =nil;
    
    }
    else
    {
        networkEntity.NRequestEntity.RServerCode=@"fail"; 
    }
        
   

    
    if (delegate) 
    {
        [delegate DARequestFinish:networkEntity.NRequestEntity];
    }
}
@end
