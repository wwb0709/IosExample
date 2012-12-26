//
//  FileTranserHelper.m
//  IphoneReader
//
//  Created by TGBUS on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FileTranserHelper.h"
#import "FileTranserModel.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

static FileTranserHelper *instance;

@interface FileTranserHelper () {
@private
}
-(void)archiverModel:(id)model filePath:(NSString *)filePath;
-(void)hideNotification:(UILabel *)label;

@end
@implementation FileTranserHelper

@synthesize filetranserDelegate;
@synthesize isShowNotification;

+(FileTranserHelper *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[FileTranserHelper alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    self.filetranserDelegate=nil;
    [instance release];
    instance=nil;
    [super dealloc];
}

-(BOOL)isArchivedFile:(NSString *)url
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",url]]];
}


-(BOOL)isArchive:(int)tag
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",tag]]];
}

-(BOOL)isStartingFile:(NSString *)url
{
    for(ASIHTTPRequest *request in [tasks operations])
    {
        if([[request.url description] isEqualToString:url])
        {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isTransferingFile:(int)tag
{
    for(ASIHTTPRequest *request in [tasks operations])
    {
        FileTranserModel *file=[request.userInfo objectForKey:@"File"];
        if(file.fileID==tag)
        {
            return YES;
        }
    }
    return NO;
}

-(NSString *)getDowningFolderPath
{
    NSString *downingPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Downloading"];
     NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:downingPath])
    {
        NSError *error=nil;
        [fileManager createDirectoryAtPath:downingPath withIntermediateDirectories:YES attributes:nil error:&error];
        if(error!=nil)
        {
            NSLog(@"创建Downloading文件夹出错!%@",error);
        }
    }

    return downingPath;
}

-(NSMutableArray *)getArchivelist
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error=nil;
    
    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[self getDowningFolderPath] error:&error];
    if(error!=nil)
    {
        NSLog(@"读取归档列表错误%@",error);
    }
    NSMutableArray *archivelist=[[[NSMutableArray alloc] init] autorelease];
    for(NSString *str in filelist)
    {
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if(![str hasSuffix:@"temp"]&&[fileManager fileExistsAtPath:[[self getDowningFolderPath]stringByAppendingPathComponent:[str stringByAppendingFormat:@".temp"]]])
        {
            FileTranserModel *file=[self unArchiverModel:[[self getDowningFolderPath] stringByAppendingPathComponent:str]];
            if(file!=nil)
            {
                [archivelist addObject:file];
            }
        }
    }
    return archivelist;
}

-(FileTranserModel *)getFileTransferModelByTag:(int)tag
{
    NSMutableArray *filelist=[self getArchivelist];
    for(FileTranserModel *tmpFile in filelist)
    {
        if(tmpFile.fileID==tag)
        {
            return tmpFile;
        }
    }
    return nil;
}

-(void)setMaxCurrentOperation:(int)_count
{
    if(tasks==nil)
    {
        tasks=[[NSOperationQueue alloc] init];
    }
    count=_count;
    if(count==0)
    {
        count=2;//默认是2
    }
    [tasks setMaxConcurrentOperationCount:count];
}
//XX:XX格式
-(void)showNotification:(NSString *)info
{
  
        NSString *notifi=[NSString stringWithString:info];
        NSUInteger location=[notifi rangeOfString:@":"].location;
        NSString *fileName=nil;
        NSString *otherText=nil;
        NSString *showText=nil;
        if(location<100000)
        {
            fileName=[notifi substringToIndex:location];
            otherText=[notifi substringFromIndex:location+1];
            showText =[NSString stringWithFormat:@"%@:%@",fileName,otherText];
        }
        if([fileName length]>15)
        {
            fileName=[NSString stringWithFormat:@"%@...",[fileName substringToIndex:15]];
        }
        if(fileName==nil)
        {
            showText=info;
        }
       
        UILabel *label = [[UILabel alloc] init];
        [label setText:showText];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 6;
        label.backgroundColor = [UIColor blackColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        [label setAlpha:0.0f];
        
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.mainWindow addSubview:label];
        if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            label.font = [UIFont systemFontOfSize:15];
            CGSize trueSize=[showText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15]];
            label.frame = CGRectMake(0, 35, trueSize.width+30, 30);
            [label setCenter:CGPointMake(appDelegate.mainWindow.center.x, 416)];
        }
        else
        {
            label.font = [UIFont systemFontOfSize:20];
            CGSize trueSize=[showText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:20]];
            label.frame = CGRectMake(0, 10, trueSize.width+50, 30);
            [label setCenter:CGPointMake(1024/2, 748-40)];
            [label setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        }
        [label release];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0f];
        label.alpha =1.0;
        [UIView commitAnimations];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideNotification:) object:nil];
        [self performSelector:@selector(hideNotification:) withObject:label afterDelay:2.0];
}

-(void)hideNotification:(UILabel *)label
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [label setAlpha:0.0];
    [UIView commitAnimations];
    
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

-(void)startDownloadFile:(FileTranserModel *)fileTransferModel delegate:(id<FileTranserHelperDelegate>)delegate
{
    if([self isStartingFile:fileTransferModel.downoadUrl])
    {
        [self showNotification:[NSString stringWithFormat:@"%@%@!",fileTransferModel.fileName,NSLocalizedString(@"已经在下载了", @"")]];
        return;
    }
    
    if(tasks==nil)
    {
        tasks=[[NSOperationQueue alloc] init];
        if(count==0)
        {
            count=2;
        }
        [tasks setMaxConcurrentOperationCount:count];
    }

    
    [self showNotification:[NSString stringWithFormat:@"%@%@!",fileTransferModel.fileName,NSLocalizedString(@"开始下载", @"")]];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fileTransferModel.downoadUrl]];
    [request setDelegate:self];
    [request setDownloadProgressDelegate:self];
    NSString *destionFolderPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *destionPath=[destionFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileTransferModel.fileName]];
    [request setDownloadDestinationPath:destionPath];
    NSString *tmpPath=[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileTransferModel.fileName]];
    [request setTemporaryFileDownloadPath:tmpPath];
    [request setAllowResumeForFileDownloads:YES];//支持断点续传
    [request setTimeOutSeconds:180.0f];
    [request setShouldContinueWhenAppEntersBackground:YES];
    
    FileTranserModel *fileInfo=nil;
    //如果已经进行了归档则提取
    if([self isArchivedFile:fileTransferModel.fileName])
    {
        fileInfo=[self unArchiverModel:[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileTransferModel.fileName]]];
    }
    if(fileInfo==nil)
    {
        fileInfo=[[[FileTranserModel alloc] init] autorelease];
        [fileInfo setDownoadUrl:fileTransferModel.downoadUrl];
        [fileInfo setFileName:fileTransferModel.fileName];
        [fileInfo setImgUrl:fileTransferModel.imgUrl];
        [fileInfo setFileTrueSize:fileTransferModel.fileTrueSize];
        [fileInfo setTmpPath:tmpPath];
        [fileInfo setDestationPath:destionPath];
        [fileInfo setProgress:0.0f];
        fileInfo.fileTmpSize=0;//数据第一次返回上次已经传输的大小。所以下载前要清空
        [self archiverModel:fileInfo filePath:[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileInfo.fileName]]];
    }
    fileInfo.fileTmpSize=0.0;
    fileInfo.errorCode=-1;
//    fileInfo.fileTranserState=FileTransfering;
    if(tasks.operationCount>=tasks.maxConcurrentOperationCount)
    {
        [fileInfo setFileTranserState:FileTransferWaitOther];
    }
    else
    {
        [fileInfo setFileTranserState:FileTransferWaiting];
    }
    NSMutableDictionary *userInfo=[[NSMutableDictionary alloc]init];
    [userInfo setObject:fileInfo forKey:@"File"];
    [request setUserInfo:userInfo];//设置上下文的文件基本信息
    [request setTimeOutSeconds:30.0f];
    [tasks addOperation:request];
    NSLog(@"开始下载的url:%@",request.url);
    [userInfo release];
    [request release];    
    
    if([filetranserDelegate respondsToSelector:@selector(fileTranserStartNewTask:transerModel:)])
    {
        [filetranserDelegate fileTranserStartNewTask:nil transerModel:fileInfo];
    }

}
-(void)startDownloadFile:(NSString *)url tag:(int)tag fileTransferModel:(FileTranserModel *)fileTransferModel fileTranserHelperDelegate:(id<FileTranserHelperDelegate>)fileTranserHelperDelegate downloadProgress:(id)downloadProgress
{
    if([url length]==0||url==nil)
    {
        NSLog(@"地址url有错误%@",url);
        return;
    }
    if(fileTransferModel.fileName==nil)
    {
        NSLog(@"文件名为nil");
        return;
    }
    if([self isTransferingFile:tag])
    {
        NSLog(@"文件已经在传输了");
        [self showNotification:[NSString stringWithFormat:@"%@%@!",fileTransferModel.fileName,NSLocalizedString(@"已经在下载了", @"")]];
        return;
    }
    if(tasks==nil)
    {
        tasks=[[NSOperationQueue alloc] init];
        if(count==0)
        {
            count=2;
        }
        [tasks setMaxConcurrentOperationCount:count];
    }
    if(![self isTransferingFile:tag])
    {
        [self showNotification:[NSString stringWithFormat:@"%@%@!",fileTransferModel.fileName,NSLocalizedString(@"开始下载", @"")]];
        ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        if(downloadProgress!=nil)
        {
            [request setDownloadProgressDelegate:downloadProgress];
        }
        else
        {
            [request setDownloadProgressDelegate:self];
        }
        NSString *destionFolderPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Downloads"];
        NSString *destionPath=[destionFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ipa",fileTransferModel.fileName]];
        [request setDownloadDestinationPath:destionPath];
        NSString *tmpPath=[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileTransferModel.fileName]];
        [request setTemporaryFileDownloadPath:tmpPath];
        [request setAllowResumeForFileDownloads:YES];//支持断点续传
        [request setTimeOutSeconds:180.0f];
        [request setShouldContinueWhenAppEntersBackground:YES];
        
        FileTranserModel *fileInfo=nil;
        //如果已经进行了归档则提取
        if([self isArchive:tag])
        {
            fileInfo=[self unArchiverModel:[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",tag]]];
        }
        if(fileInfo==nil)
        {
            fileInfo=[[[FileTranserModel alloc] init] autorelease];
            [fileInfo setFileID:tag];
            [fileInfo setDownoadUrl:url];
            [fileInfo setFileName:fileTransferModel.fileName];
            [fileInfo setImgUrl:fileTransferModel.imgUrl];
            [fileInfo setFileTrueSize:fileTransferModel.fileTrueSize];
            [fileInfo setTmpPath:tmpPath];
            [fileInfo setDestationPath:destionPath];
            [fileInfo setProgress:0.0f];
            [self archiverModel:fileInfo filePath:[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",tag]]];
        }
        fileInfo.fileTmpSize=0;//数据第一次返回上次已经传输的大小。所以下载前要清空
        fileInfo.errorCode=-1;
        if(tasks.operationCount>=tasks.maxConcurrentOperationCount)
        {
            [fileInfo setFileTranserState:FileTransferWaitOther];
        }
        else
        {
            [fileInfo setFileTranserState:FileTransferWaiting];
        }
        NSMutableDictionary *userInfo=[[NSMutableDictionary alloc]init];
        [userInfo setObject:fileInfo forKey:@"File"];
        [request setUserInfo:userInfo];//设置上下文的文件基本信息
        [request setTimeOutSeconds:30.0f];
        [userInfo release];
        [tasks addOperation:request];
        NSLog(@"开始下载的url:%@",request.url);
        [request release];    
    
        if([filetranserDelegate respondsToSelector:@selector(fileTranserStartNewTask:transerModel:)])
        {
            [filetranserDelegate fileTranserStartNewTask:[NSNumber numberWithInt:tag] transerModel:fileInfo];
        }
    }
}

#pragma ASIHttpReqeust委托
/*这里注意，请求一个文件的开始下载的时候，会返回2次，一个是text/html另一个是下载文件的实际信息
{
    "Cache-Control" = "max-age=1800";
    Connection = "keep-alive";
    "Content-Length" = 1;
    "Content-Type" = "text/html";
    Date = "Mon, 04 Jun 2012 08:25:10 GMT";
    Expires = "Mon, 04 Jun 2012 08:55:10 GMT";
    Location = "http://222.186.49.120/file/MDAwMDAwMDFyeICJGOeW5qbg2t5nz7EvvZD1x1d5TqQ66nvE655QUg../89e218d42946916b711834d6c729be30713ba6/netdisk_iPhone_1.0.1.8.ipa?key=AAABQE_Mhf7ggcUa&p=&a=0-124.205.140.98&c=lr:47178a8c48b25c0dee32763181e47328/500k&mode=download";
    Server = nginx;
    "X-Powered-By" = "PHP/5.3.1";
}
 {
 "Cache-Control" = "max-age=86400";
 Connection = close;
 "Content-Disposition" = "attachment; filename=\"netdisk_iPhone_1.0.1.8.ipa\"";
 "Content-Length" = 7420838;
 "Content-Type" = "application/octet-stream";
 Date = "Mon, 04 Jun 2012 08:25:11 GMT";
 Expires = "Tue, 05 Jun 2012 08:25:11 GMT";
 "Last-Modified" = "Thu, 22 Dec 2011 00:00:00 GMT";
 Server = "nginx/1.1.13";
 }
*/
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
     FileTranserModel *fileInfo=[request.userInfo objectForKey:@"File"];//标示ID
    //将文件名称和大小收集然后归档
    NSDictionary *headerDict=[request responseHeaders];
    NSLog(@"头信息%@\nrequest.responseStatusCode=%d",responseHeaders,request.responseStatusCode);
    if(headerDict==nil)
    {
        [request redirectToURL:request.originalURL];
        return;
    }
    [fileInfo setErrorCode:request.responseStatusCode];

    //如果下载响应的信息不是文件大小，而是网页或者别的，则返回
    //1。,这个网页可能是相应下载前的回复
    //2.可能是类似如下的链接的，需要输入验证码的http://115.com/file/c257x6ak#%20%E5%BF%AB%E6%92%AD-v1.1.10-Appifan.com.ipa
    NSString *contentType=[headerDict objectForKey:@"Content-Type"];
    if([contentType rangeOfString:@"text/html"].location<100)
    {
        NSLog(@"fileInfo.fileTrueSize=%lld",fileInfo.fileTrueSize);
        return;
    }
    //获取实际文件大小
    NSString *fileTureSize=[headerDict objectForKey:@"Content-Length"];
    NSString *rangeString=[headerDict objectForKey:@"Content-Range"];
    if(rangeString!=nil)
    {
        NSInteger dotIndex=[rangeString rangeOfString:@"/"].location;
        fileTureSize=[rangeString substringFromIndex:dotIndex+1];
    }
    [fileInfo setFileTrueSize:[fileTureSize longLongValue]];
    [fileInfo setFileTranserState:FileTransfering];
    [self archiverModel:fileInfo filePath:[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",fileInfo.fileID]]];

    //启动计时器
    NSTimer *timer=[request.userInfo objectForKey:@"Timer"];
    if(timer==nil)
    {
        NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(clearDataInTimer:) userInfo:fileInfo repeats:YES];
        NSMutableDictionary *dict=(NSMutableDictionary *)request.userInfo;
        [dict setObject:timer forKey:@"Timer"];
    }
    if(filetranserDelegate!=nil)
    {
        if([filetranserDelegate respondsToSelector:@selector(fileTranserResponse:transerModel:)])
        {
            [filetranserDelegate fileTranserResponse:[NSNumber numberWithInt:fileInfo.fileID] transerModel:fileInfo];
        }  
    }
}

//每隔1s执行依次更新一下界面，速度归0重新累计
-(void)clearDataInTimer:(NSTimer *)timer
{
    FileTranserModel *fileModel=timer.userInfo;
    for(ASIHTTPRequest *request in [tasks operations])
    {
        FileTranserModel *file=[request.userInfo objectForKey:@"File"];
        NSLog(@"file.fileID=%d",file.fileID);
        if(file.downoadUrl==fileModel.downoadUrl&&filetranserDelegate!=nil)   
        {
            if([filetranserDelegate respondsToSelector:@selector(fileTranserUpdateData:transerModel:)])
            {
                //不接受数据的时候speed会为0，接受数据的函数不会走了，所以要即时处理时间
                file.remainTime=[self getTimeString:file.fileTrueSize-file.fileTmpSize speed:file.speed];
                NSLog(@"时间定时器==============ID=%d,%lld,%lld,百分比=%f,Speed=%lld,传输状态:%d,,剩余时间%@",fileModel.fileID,fileModel.fileTmpSize,fileModel.fileTrueSize,fileModel.progress,fileModel.speed,fileModel.fileTranserState,fileModel.remainTime);
                [filetranserDelegate fileTranserUpdateData:[NSNumber numberWithInt:file.fileID] transerModel:file];
            }
        }
    }
    fileModel.speed=0;
}

//不断更新归档文件数据
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    FileTranserModel *fileInfo=[request.userInfo objectForKey:@"File"];
    if(fileInfo.fileTrueSize==0)
    {
        NSLog(@"请求文件有误,没有得到文件大小，查看返回头信息");
        return;
    }
    if(fileInfo.fileTmpSize==0)//第一次请求的时候，会返回上次已经传输的数据大小
    {
        fileInfo.fileTmpSize+=bytes; 
        return;
    }
    else
    {
        NSLog(@"%lld",bytes);
    }
    //更新数据
    fileInfo.speed+=bytes;
    fileInfo.fileTmpSize+=bytes; 
    fileInfo.progress=(CGFloat)fileInfo.fileTmpSize/fileInfo.fileTrueSize;
    NSLog(@"fileInfo.progress=%f",fileInfo.progress);
    [fileInfo setFileTranserState:FileTransfering];
    [self archiverModel:fileInfo filePath:[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileInfo.fileName]]];
}

//下载有时候会是200
-(void)requestFinished:(ASIHTTPRequest *)request
{
    FileTranserModel *fileInfo=(FileTranserModel *)[request.userInfo objectForKey:@"File"];
    [fileInfo setFileTranserState:FileTransferFinished];
    
    //如果下载完成则停止计时器
    NSTimer *timer=[request.userInfo objectForKey:@"Timer"];
    [timer invalidate];
    NSLog(@"下载完成时的code=%d,%d",request.error.code,fileInfo.errorCode);//默认是0，如果是bad url也会走这个方法，并且也是0，所以通过手机文件大小和预期文件大小对比
//    if(fileInfo.fileTrueSize==fileInfo.fileTmpSize&&fileInfo.fileTrueSize)
//    {
        //成功下载结束后,删除本地下载列表里的数据
        [self deleteModelFromArchiverByURL:fileInfo.fileName];
        if(filetranserDelegate!=nil)
        {
            [self performSelectorOnMainThread:@selector(showNotification:) withObject:[NSString stringWithFormat:@"%@:%@",fileInfo.fileName,NSLocalizedString(@"下载完成", @"")] waitUntilDone:YES];
            if([filetranserDelegate respondsToSelector:@selector(fileTranserFinished:transerModel:)])
            {
                [filetranserDelegate fileTranserFinished:[NSNumber numberWithInt:fileInfo.fileID] transerModel:fileInfo];
            }
        }
//    }
//    else
//    {
//        if([filetranserDelegate respondsToSelector:@selector(fileTranserFail:transerModel:)])
//        {
//            [self performSelectorOnMainThread:@selector(showNotification:) withObject:[NSString stringWithFormat:@"%@:%@",fileInfo.fileName,NSLocalizedString(@"下载失败", @"")] waitUntilDone:YES];
//            [fileInfo setFileTranserState:FileTransferFailed];
//            [filetranserDelegate fileTranserFail:[NSNumber numberWithInt:fileInfo.fileID] transerModel:fileInfo];
//        }
//    }
}


//
//http://www.eagleland.cn/EL_html/eagleland/erudition/2010/0101/151.html
//
//
-(NSString *)getErroInfoByHttpErrorCode:(int)errorCode
{
    NSString *stateText=@"";
    NSLog(@"errorCode=%d",errorCode);
    switch (errorCode) {
        case 10000://文件不完整
            stateText=NSLocalizedString(@"下载的文件不完整!", @"") ;
            break;
        case 2://asi的超时是2
            stateText=NSLocalizedString(@"链接超时", @"");
            break;
        case 100://自己定义的100,没有网络
            stateText=NSLocalizedString(@"网络连接异常!", @"");
            break;
        case 400:
            stateText=NSLocalizedString(@"下载地址非法!", @"");
            break;
        case 401:
            stateText=NSLocalizedString(@"未登陆授权", @"");
            break;
        case 403:
            stateText=NSLocalizedString(@"链接已失效", @"");
            break;
        case 404:
            stateText=NSLocalizedString(@"资源文件已经被删除!", @"");
            break;
        case 407:
            stateText=NSLocalizedString(@"需要代理身份验证", @"");
            break;
        case 408:
            stateText=NSLocalizedString(@"链接超时!", @"");
            break;
        default:
            stateText=NSLocalizedString(@"未知错误", @"");
            break;
    }
    return stateText;
}

//0-下载完成或者链接地址失效（不会走错误回调）
//2-30s链接超时
//4-取消cancel 下载
//5-是链接地址非法（空地址或者别的） bad url
//全部使用http的错误代码，代码可以查看网址http://www.eagleland.cn/EL_html/eagleland/erudition/2010/0101/151.html
//408time out
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSTimer *timer=[request.userInfo objectForKey:@"Timer"];
    [timer invalidate];
    FileTranserModel *fileInfo=[request.userInfo objectForKey:@"File"];
    [fileInfo setFileTranserState:FileTransferFailed];
    int errorCode=request.responseStatusCode;
    if(request.error.code==2)
    {
        errorCode=2;
    }
    [fileInfo setErrorCode:errorCode];
    [self archiverModel:fileInfo filePath:[ArchiverPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",fileInfo.fileID]]];
    NSLog(@"下载出错:%@,responseStatusCode=%d",[request error],request.responseStatusCode);
    if([filetranserDelegate respondsToSelector:@selector(fileTranserFail:transerModel:)])
    {
        [self showNotification:[NSString stringWithFormat:@"%@:%@",fileInfo.fileName,NSLocalizedString(@"下载失败", @"")]];
        [filetranserDelegate fileTranserFail:[NSNumber numberWithInt:fileInfo.fileID] transerModel:fileInfo];
    }
}

-(void)deleteModelFromArchiverByURL:(NSString *)url
{
    //把持久数据里的归档信息删除
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *path=[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",url]];
    if(![fileManager fileExistsAtPath:path])
    {
        NSLog(@"删除的归档文件不存在!%@",path);
    }
    NSError *error=nil;
    [fileManager removeItemAtPath:path error:&error];
    if(error!=nil)
    {
        NSLog(@"删除归档出错:%@",error);
    }
    return;

}
-(void)deleteModelFromArchiver:(int)fileID
{
    //把持久数据里的归档信息删除
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *path=[[self getDowningFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",fileID]];
    if(![fileManager fileExistsAtPath:path])
    {
        NSLog(@"删除的归档文件不存在!%@",path);
    }
    NSError *error=nil;
    [fileManager removeItemAtPath:path error:&error];
    if(error!=nil)
    {
        NSLog(@"删除归档出错:%@",error);
    }
}

-(void)cancelForURL:(NSString *)url
{
    for(ASIHTTPRequest *request in tasks.operations)
    {
        FileTranserModel *file=[request.userInfo objectForKey:@"File"];
        if([file.downoadUrl isEqualToString:url])
        {
            NSTimer *timer=[request.userInfo objectForKey:@"Timer"];
            [timer invalidate];
            [request clearDelegatesAndCancel];
            [file setFileTranserState:FileTransferPause];
            if([filetranserDelegate respondsToSelector:@selector(fileTranserCancelTask:transerModel:)])
            {
                [filetranserDelegate fileTranserCancelTask:[NSNumber numberWithInt:file.fileID] transerModel:file];
            }
        }
    }
}

-(void)cancelForTag:(int)tag
{
    for(ASIHTTPRequest *request in tasks.operations)
    {
        FileTranserModel *file=[request.userInfo objectForKey:@"File"];
        if(file.fileID==tag)
        {
            NSTimer *timer=[request.userInfo objectForKey:@"Timer"];
            [timer invalidate];
            [request clearDelegatesAndCancel];
            [file setFileTranserState:FileTransferPause];
            if([filetranserDelegate respondsToSelector:@selector(fileTranserCancelTask:transerModel:)])
            {
                [filetranserDelegate fileTranserCancelTask:[NSNumber numberWithInt:file.fileID] transerModel:file];
            }
        }
    }
}
//23KB->23000
-(float)getFileSizeNumber:(NSString *)size
{
    if(size==nil||[size length]==0)
    {
        NSLog(@"需要转化成浮点数字的的数据非法");
        return 0.0;
    }
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)//是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)//是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)//是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else//没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}

//23000->23KB
-(NSString *)getFileSizeString:(long long)size
{
    if(size>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        NSString *tempString=[NSString stringWithFormat:@"%f",(CGFloat)size/1024/1024];
        NSInteger dotIndex=[tempString rangeOfString:@"."].location;
        return [NSString stringWithFormat:@"%@MB",[tempString substringToIndex:dotIndex+2]];
    }
    else if(size>=1024&&size<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        NSString *tempString=[NSString stringWithFormat:@"%f",(CGFloat)size/1024];
        NSInteger dotIndex=[tempString rangeOfString:@"."].location;
        return [NSString stringWithFormat:@"%@KB",[tempString substringToIndex:dotIndex+2]];
    }
    else if(size>0&&size<1024)//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%lldB",size];
    }
    else
    {
        return @"0B";
    }
}

-(NSString *)getTimeString:(long long)remainSize speed:(long long)speed
{
    NSString *resultString=@"--:--:--";
    if(speed==0||remainSize<=0)
    {
        return resultString;
    }
    float second=remainSize/speed;
    if(speed==0)
    {
        return resultString;
    }
    
    NSString *hourString=nil;
    NSString *minString=nil;
    NSString *secondString=nil;
    int hour=second/3600;
    if(hour==0)
    {
        hourString=@"00";
    }
    else if(hour>0&&hour<10)
    {
        hourString=[NSString stringWithFormat:@"0%d",hour];
    }
    else
    {
        hourString=[NSString stringWithFormat:@"%d",hour];
    }
    int remainSecond=second-3600*hour;
    
    int min=remainSecond/60;
    if(min==0)
    {
        minString=@"00";
    }
    else if(min>0&&min<10)
    {
        minString=[NSString stringWithFormat:@"0%d",min];
    }
    else
    {
        minString=[NSString stringWithFormat:@"%d",min];
    }
    
    remainSecond=remainSecond-60*min;
    
    if(remainSecond==0)
    {
        secondString=@"00";
    }
    else if(remainSecond>0&&remainSecond<10)
    {
        secondString=[NSString stringWithFormat:@"0%d",remainSecond];
    }
    else
    {
        secondString=[NSString stringWithFormat:@"%d",remainSecond];
    }
    resultString=[NSString stringWithFormat:@"%@:%@:%@",hourString,minString,secondString];
    return resultString;
}

-(void)deleteFile:(NSString *)filePath
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error=nil;
    if([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:&error];
        if(error!=nil)
        {
            NSLog(@"删除文件出错:%@",error);
        }
    }
}

-(void)archiverModel:(id)model filePath:(NSString *)filePath
{
    NSMutableData *archiverData=[[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:archiverData];
    [archiver encodeObject:model forKey:@"Data"];
    [archiver finishEncoding];
    BOOL flag=[archiverData writeToFile:filePath atomically:NO];
    if(!flag)
    {
        NSLog(@"归档失败");
    }
    [archiver release];
    [archiverData release];
}

-(id)unArchiverModel:(NSString *)filePath
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"反归档的路径不存在:%@",filePath);
        return nil;
    }
    
    NSData *unArchiverData=[[NSData alloc] initWithContentsOfFile:filePath];
    NSLog(@"filePath=%@",filePath);
    NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:unArchiverData];
    id model=[unarchiver decodeObjectForKey:@"Data"];
    [unarchiver finishDecoding];
    [unarchiver release];
    [unArchiverData release];
    FileTranserModel *file=(FileTranserModel *)model;
    //获取最新的文件临时大小
    NSError *error=nil;
    NSDictionary *attributeDict=[fileManager attributesOfItemAtPath:file.tmpPath error:&error];
    if(error!=nil)
    {
        NSLog(@"读取正在下载文件属性出错:%@",error);
    }
    [file setFileTmpSize:[[attributeDict objectForKey:NSFileSize] longValue]];
    [file setFileTranserState:FileTransferPause];//默认暂停状态
    for(ASIHTTPRequest *request in [tasks operations])
    {
        FileTranserModel *taskfile=[request.userInfo objectForKey:@"File"];
        if(file.fileID==taskfile.fileID)
        {
            [file setFileTranserState:taskfile.fileTranserState];
        }
    }
    NSLog(@"读取出来的fileTmpSize=%lld,fileTrueSize=%lld,百分比=%f",file.fileTmpSize,file.fileTrueSize,file.progress);
    return model;
}

@end
