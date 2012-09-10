//
//  DAAsynNetwork.h
//  DigitAlbum
//
//  Created by  on 11-10-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASIProgressDelegate.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "DANetworkEntity.h"
#import "DAUtility.h"

@interface DAAsynNetwork : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    ASINetworkQueue *ntQueue;//下在队列
    NSMutableDictionary *networkInfoDir;//下载列表
    NSMutableDictionary *targetDir;//回调列表
}
 
@property(nonatomic,retain) ASINetworkQueue *ntQueue;
@property(nonatomic,retain) NSMutableDictionary *networkInfoDir;
@property(nonatomic,retain) NSMutableDictionary *targetDir;

+(DAAsynNetwork *) getIntance;//返回唯一的下载服务实体

-(BOOL) isDeviceWifiReachable;

-(NSString *)requestData:(id)target networkInfo:(DANetworkEntity*)networkEntity;//获取数据

-(void)requestDataPrivate:(NSArray*)parmArr;//另起线程调用的

-(BOOL)CancelDownloadTask:(NSString *)taskID;//取消下载

- (void)requestFinished:(ASIHTTPRequest *)request;//下载完成

- (void)requestFailed:(ASIHTTPRequest *)request;//下载失败

-(void)initQueue;//初始化队列
-(void)CancelAllDownloadTask;//取消所有下载


@end
