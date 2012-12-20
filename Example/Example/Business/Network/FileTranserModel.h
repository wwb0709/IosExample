//
//  FileTranserModel.h
//  IphoneReader
//
//  Created by TGBUS on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum FileTransferState {
    FileTransferPause=0,//没有在下载队列中
    FileTransferWaiting = 1,//队列里还没有开始传输,等待http响应头信息获取文件大小
    FileTransferWaitOther=2,//再队列中没有开始，等待其它下载完成，
    FileTransfering = 3,//开始传输
    FileTransferFinished=4,//传输完毕
    FileTransferFailed=5//传输出错
    };

@interface FileTranserModel : NSObject<NSCoding,NSCopying>

@property(nonatomic,assign)int fileID;
@property(nonatomic,retain)NSString *fileName;
@property(nonatomic,retain)NSString *imgUrl;
@property(nonatomic,retain)NSString *downoadUrl;
@property(nonatomic,assign)long long speed;
@property(nonatomic,assign)long long fileTrueSize;
@property(nonatomic,assign)long long fileTmpSize;
@property(nonatomic,retain)NSString *remainTime;
@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,retain)NSString *destationPath;
@property(nonatomic,retain)NSString *tmpPath;
@property(nonatomic,assign)int fileTranserState;//文件传输的状态
@property(nonatomic,assign)int errorCode;//传输出错代码
@property(nonatomic,retain)NSDictionary *userInfo;//asi出入的userInfo

@end
