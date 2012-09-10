//
//  CustomLog.h
//  HaoLianLuo
//
//  Created by iPhone_wmobile on 10-11-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*
 dyl: 
 写此模块目的： 不依赖系统NSLog,开发者自由控制打印日志的方式
 */


#import <Foundation/Foundation.h>


@interface CustomLog : NSObject
{
}

////======日志管理初始化
//void	BeginCustomLog();
////======清理日志文件锁
//void	EndCustomLog();

//======输出日志
void    printLog(NSString *format, ...);

@end
