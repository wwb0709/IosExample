//
//  FileTranserHelper.h
//  IphoneReader
//
//  Created by TGBUS on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIProgressDelegate.h"
@class FileTranserModel;

#define ArchiverPath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Downloading"]

@protocol FileTranserHelperDelegate <NSObject>
//文件大小都是经过转化过适合单位的字符串
//进度大小为0-1

-(void)fileTranserFail:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel;
-(void)fileTranserStartNewTask:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel;//刚开始添加到下载队列中
-(void)fileTranserCancelTask:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel;//取消正在下载的文件
-(void)fileTranserResponse:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel;//获得文件大小
-(void)fileTranserUpdateData:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel;
-(void)fileTranserFinished:(NSNumber *)tag transerModel:(FileTranserModel *)transerModel;

@end

@interface FileTranserHelper : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    @private
    NSOperationQueue *tasks;//这个队列只有正在下载
    int count;
}

@property(nonatomic,assign)id<FileTranserHelperDelegate> filetranserDelegate;
@property(nonatomic,assign)BOOL isShowNotification;

+(FileTranserHelper *)sharedInstance;
-(void)cancelForURL:(NSString *)url;
-(BOOL)isArchivedFile:(NSString *)url;
-(BOOL)isStartingFile:(NSString *)url;
-(void)startDownloadFile:(FileTranserModel *)fileTransferModel delegate:(id<FileTranserHelperDelegate>)delegate;
-(void)setMaxCurrentOperation:(int)count;
-(void)showNotification:(NSString *)info;
-(id)unArchiverModel:(NSString *)filePath;
-(BOOL)isTransferingFile:(int)tag;
-(void)startDownloadFile:(NSString *)url tag:(int)tag  fileTransferModel:(FileTranserModel *)fileTransferModel fileTranserHelperDelegate:(id<FileTranserHelperDelegate>)fileTranserHelperDelegate downloadProgress:(id)downloadProgress;
-(void)cancelForTag:(int)tag;
-(NSString *)getDowningFolderPath;//得到存放正在下载文件的文件夹
-(void)deleteFile:(NSString *)filePath;
-(void)deleteModelFromArchiver:(int)fileID;
-(NSMutableArray *)getArchivelist;//得到所有正在下载的数据
-(FileTranserModel *)getFileTransferModelByTag:(int)tag;//通过id获取最新数据的model
-(NSString *)getErroInfoByHttpErrorCode:(int)errorCode;
-(BOOL)isArchive:(int)tag;

//字符转化函数
-(float)getFileSizeNumber:(NSString *)size;
-(NSString *)getFileSizeString:(long long)size;
-(NSString *)getTimeString:(long long)totalSize speed:(long long)speed;

@end
