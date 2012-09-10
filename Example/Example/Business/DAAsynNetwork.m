//
//  DAAsynNetwork.m
//  DigitAlbum
//
//  Created by  on 11-10-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DAAsynNetwork.h"
#import "Reachability.h"
#define MAXDOWNLOADTHREAD 3
#define USERINFOKEY @"networkInfo"

@implementation DAAsynNetwork

@synthesize networkInfoDir;
@synthesize ntQueue;
@synthesize targetDir;

- (id)init
{
    self = [super init];
    if (self) {
        //初始化下载实体字典
        networkInfoDir=[[NSMutableDictionary alloc] init];
        
        targetDir=[[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+(DAAsynNetwork *) getIntance
{
    static DAAsynNetwork *asynNetwork;
    @synchronized(self)
    {
        if(!asynNetwork)
        {
            asynNetwork=[[DAAsynNetwork alloc] init];
        }
        return asynNetwork;
    }
}

-(void)initQueue
{
    ntQueue=[[ASINetworkQueue alloc] init];
    [ntQueue setShowAccurateProgress:YES];
    [ntQueue setShouldCancelAllRequestsOnFailure:NO];
    [ntQueue setMaxConcurrentOperationCount:MAXDOWNLOADTHREAD];
}

-(BOOL) isDeviceWifiReachable{
    Reachability *isWifiReachable = [Reachability reachabilityForLocalWiFi];
    BOOL iswifiok = [isWifiReachable isReachableViaWiFi];
    return iswifiok;
}

-(NSString *)requestData:(id)target networkInfo:(DANetworkEntity*)networkEntity
{
    //只支持WiFi联网检查
//    NSString *iswifonly =   [[NSUserDefaults standardUserDefaults] objectForKey:SET_DEVICE_NEWORK_SUPPORT_WIFI_ONLY];
//    if ([iswifonly isEqualToString:@"1"]) {
//        if (![self isDeviceWifiReachable]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前环境没有WiFi网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
//            [alert release];
//            return nil;
//        }
//    }
    //创建一个新的请求ID
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    
    [NSThread detachNewThreadSelector:@selector(requestDataPrivate:) toTarget:self withObject:[NSArray arrayWithObjects:uuidString,target,networkEntity, nil]];
   
    return [uuidString autorelease];
}

-(void)requestDataPrivate:(NSArray*)parmArr
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *uuidString=[parmArr objectAtIndex:0];
    id target=[parmArr objectAtIndex:1];
    DANetworkEntity* networkEntity=[parmArr objectAtIndex:2];
    
    //给requestID赋值
    networkEntity.NRequestEntity.RRequestID=uuidString;
    
    //添加到回调字典
    [targetDir setObject:target forKey:uuidString];
    
    //组合参数字符串
    NSArray *keyArr=[networkEntity.NRequestParamDir allKeys];
    
    int random = arc4random() % 1000;
    NSString *paramStr=@"";
    
    //当有参数而且返回数据类型为字符的时候，再组合参数字符串，2011-10-27而且必须是HttpRequest类型时
    if (networkEntity.NNetworkType==DANetworkType_HttpRequest&&networkEntity.NDataType==DAReturnDataType_String) {
        /*if (keyArr.count==0) {
            paramStr = [NSString stringWithFormat:@"?t=%d&ver=%@&os=7&ide=%@&size=%@&singerid=%@", 
                        random, [DAUtility getVersion], [DAUtility getUDID], [DAUtility getResolution], @"5"];
        }
        else
        {
            paramStr = [NSString stringWithFormat:@"?t=%d&ver=%@&os=7&ide=%@&size=%@&singerid=%@&", 
                        random, [DAUtility getVersion], [DAUtility getUDID], [DAUtility getResolution], @"5"];
        }
        for (NSInteger i=0; i<keyArr.count; i++) 
        {
            if (i<keyArr.count-1) 
            {
                paramStr=[NSString stringWithFormat:@"%@%@=%@&",paramStr,[keyArr objectAtIndex:i],[networkEntity.NRequestParamDir objectForKey:[keyArr objectAtIndex:i]]];
            }
            else
            {
                paramStr=[NSString stringWithFormat:@"%@%@=%@",paramStr,[keyArr objectAtIndex:i],[networkEntity.NRequestParamDir objectForKey:[keyArr objectAtIndex:i]]];
            }
        }*/
    }
    else
    {
        paramStr=@"";
    }
    
    networkEntity.NRequestUrl=[NSString stringWithFormat:@"%@%@",networkEntity.NRequestUrl,paramStr];
    //进行统一编码 add by wwb 2012-3-16
    networkEntity.NRequestUrl = [networkEntity.NRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //开始网络请求，加入请求队列
    printLog(@"url:%@",networkEntity.NRequestUrl);
    NSURL *url=[NSURL URLWithString:networkEntity.NRequestUrl];
    if (networkEntity.NNetworkType==DANetworkType_HttpRequest)
    {
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url]; 
        if (networkEntity.NDataType==DAReturnDataType_String) {
            [request addRequestHeader:@"Accept-Encoding" value:@"gzip,compress"];
            [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];  
            [request setRequestMethod:@"GET"];
            [request setTimeOutSeconds:60];
        }else
        {
            [request setDownloadDestinationPath:networkEntity.NRequestEntity.RSavePath];             
        }
        
        [request setDelegate:self];
        
        if(networkEntity.NRequestEntity.RProgressView!=nil)
        {
            [request setDownloadProgressDelegate:networkEntity.NRequestEntity.RProgressView];
        }
        
        [request setShouldContinueWhenAppEntersBackground:YES];
        
        [request setUserInfo:[NSDictionary dictionaryWithObject:networkEntity forKey:USERINFOKEY]];
        networkEntity.NRequest=request;
        //添加到请求字典
        [networkInfoDir setObject:request forKey:networkEntity.NRequestEntity.RRequestID];
        if(ntQueue==nil)
        {
            [self initQueue];
        }
        
        [ntQueue addOperation:request];
    }
    else
    {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: url];
        //添加参数
        for (NSString *key in keyArr) {
            [request setPostValue:[networkEntity.NRequestParamDir objectForKey:key] forKey:key];
        }
        [request setTimeOutSeconds:60];
        [request setDelegate:self];
        [request setShouldContinueWhenAppEntersBackground:YES];
        [request setUserInfo:[NSDictionary dictionaryWithObject:networkEntity forKey:USERINFOKEY]];
        networkEntity.NRequest=request;
        //添加到请求字典
        [networkInfoDir setObject:request forKey:networkEntity.NRequestEntity.RRequestID];
        if(ntQueue==nil)
        {
            [self initQueue];
        }
        [ntQueue addOperation:request];
    }
    
    [ntQueue go];
    [pool release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    DANetworkEntity *networkEntity=[request.userInfo objectForKey:USERINFOKEY];
    
    //根据不同的请求获取不同的数据
    if (networkEntity.NDataType==DAReturnDataType_String) {
        networkEntity.NReturnXml=[request responseString];
    }
    else
    {
        networkEntity.NReturnData=[request responseData];

    }
    
    networkEntity.NRequestEntity.RRequestState=DARequestState_Finish;
    
    //实现动态调用
    //先retain，使用后再release，不然从缓存remove时会释放
    id target=[[targetDir objectForKey:networkEntity.NRequestEntity.RRequestID] retain];
    [networkInfoDir removeObjectForKey:networkEntity.NRequestEntity.RRequestID];
    [targetDir removeObjectForKey:networkEntity.NRequestEntity.RRequestID];
    SEL selector=@selector(NetworkReturn:);
    if ([target respondsToSelector:selector]) {
        [target performSelector:selector withObject:networkEntity];
    }
    [target release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
   DANetworkEntity *networkEntity=[request.userInfo objectForKey:USERINFOKEY];
    networkEntity.NRequestEntity.RRequestState=DARequestState_Fail;
    networkEntity.NRequestEntity.RError=[request error];
    
    //实现动态调用,当取消时，这里已经取不到target,所以不再触发下载失败事件
    //先retain，使用后再release，不然从缓存remove时会释放
    id target=[[targetDir objectForKey:networkEntity.NRequestEntity.RRequestID] retain];
    [networkInfoDir removeObjectForKey:networkEntity.NRequestEntity.RRequestID];
    [targetDir removeObjectForKey:networkEntity.NRequestEntity.RRequestID];
    if (target) {
        SEL selector=@selector(NetworkReturn:);
        if ([target respondsToSelector:selector]) {
            [target performSelector:selector withObject:networkEntity];
        }
    }
    [target release];
}

-(BOOL)CancelDownloadTask:(NSString *)taskID
{
    ASIHTTPRequest *request=[networkInfoDir objectForKey:taskID];
    if (request) {
        
        DANetworkEntity *networkEntity=[request.userInfo objectForKey:USERINFOKEY];
        //先retain，使用后再release，不然从缓存remove时会释放
        id target=[[targetDir objectForKey:networkEntity.NRequestEntity.RRequestID] retain];
        [networkInfoDir removeObjectForKey:taskID];
        [targetDir removeObjectForKey:taskID];
        //应该先从缓存移除后再取消，以免触发下载失败事件
        [request cancel];
        networkEntity.NRequestEntity.RRequestState=DARequestState_Cancel;
        
        //实现动态调用
        
        SEL selector=@selector(NetworkReturn:);
        if ([target respondsToSelector:selector]) {
            [target performSelector:selector withObject:networkEntity];
        }

        [target release];

        return true;

    }
    return false;
}

-(void)CancelAllDownloadTask
{
    NSArray *keys=[networkInfoDir allKeys];
    for (NSString *key in keys) {
        ASIHTTPRequest *request=[networkInfoDir objectForKey:key];
        if (request) {
            [request cancel];
            [networkInfoDir removeObjectForKey:key];
            [targetDir removeObjectForKey:key];
            
            DANetworkEntity *networkEntity=[request.userInfo objectForKey:USERINFOKEY];
            networkEntity.NRequestEntity.RRequestState=DARequestState_Cancel;
            
            //实现动态调用
            id target=[targetDir objectForKey:networkEntity.NRequestEntity.RRequestID];
            SEL selector=@selector(NetworkReturn:);
            if ([target respondsToSelector:selector]) {
                [target performSelector:selector withObject:networkEntity];
            }
        }
    }
}

@end
