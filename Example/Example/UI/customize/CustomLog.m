//
//  CustomLog.m
//  HaoLianLuo
//
//  Created by iPhone_wmobile on 10-11-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomLog.h"
//#import "HllTypeDefine.h"

static		NSCondition*	fpLock= nil;

//=======================日志文件操作类[可用于多线程操作]
@implementation CustomLog

//====================日志管理初始化
static void	BeginCustomLog()
{
	if(!fpLock)
	{
		NSAutoreleasePool	*pool=	[[NSAutoreleasePool alloc] init];
		
		//==============初始化互斥锁
		fpLock=			[[NSCondition alloc] init];
		
		//==============清空或创建日志文件
		NSString *path=	[NSString stringWithFormat:@"%@/Documents/customLog.txt", NSHomeDirectory()];
		FILE*	 fpLog=	fopen([path UTF8String], "wt" );
		fclose(fpLog);
		
		[pool release];
	}
}

//==================清理日志文件锁
static void	EndCustomLog()
{
	if (fpLock) 
	{
		//==============释放互斥锁
		[fpLock release];
		fpLock=	nil;
	}
}

//==============输出到debug view
static void	DebugLog(NSString *format, va_list args)
{
	NSLogv(format, args);
}

//===========输出到日志文件
static BOOL	MYLog(NSString *format, va_list args)
{
	BeginCustomLog();
	
	NSAutoreleasePool	*pool= [[NSAutoreleasePool alloc] init];
	
	BOOL	ret=	NO;
	if(fpLock)
	{
		NSString *path=	[NSString stringWithFormat:@"%@/Documents/customLog.txt", NSHomeDirectory()];
		
		[fpLock lock];
		//===================以追加的方式打开日志文件
		FILE*	fpLog=	fopen([path UTF8String], "at" );
		if (fpLog)
		{
			NSString  *newFormat=	[NSString stringWithFormat:@"%@\n", format];
			NSString* ss= [[NSString alloc] initWithFormat:newFormat arguments:args];
			//====把信息输出到日志文件
			fwrite([ss UTF8String], sizeof(Byte), 
				   [ss lengthOfBytesUsingEncoding:NSUTF8StringEncoding]+1, fpLog);
			[ss release];
			//====关闭日志文件
			fclose(fpLog);
			ret= YES;
		}
		
		[fpLock unlock];
	}
	
	[pool release];
	
	return ret;
}



//======写日志文件并输出debug view
static BOOL	BOTHLog(NSString *format, va_list args)
{
	BeginCustomLog();	
	
	NSAutoreleasePool	*pool= [[NSAutoreleasePool alloc] init];
	
	BOOL	ret=	NO;
	NSLogv(format, args);	
	
	if (fpLock)
	{
		NSString *path=	[NSString stringWithFormat:@"%@/Documents/customLog.txt", NSHomeDirectory()];
		
		[fpLock lock];
		//===================以追加的方式打开日志文件
		FILE*	fpLog=	fopen([path UTF8String], "at" );
		if (fpLog)
		{
			NSString  *newFormat=	[NSString stringWithFormat:@"%@\n", format];
			NSString* ss= [[NSString alloc] initWithFormat:newFormat arguments:args];
			//====把信息输出到日志文件
			fwrite([ss UTF8String], sizeof(Byte), 
				   [ss lengthOfBytesUsingEncoding:NSUTF8StringEncoding]+1, fpLog);
			[ss release];
			//====关闭日志文件
			fclose(fpLog);
			ret=	YES;
		}
		
		[fpLock unlock];
	}
	
	[pool release];
	
	return ret;
}


void    printLog(NSString *format, ...)
{
    //tank:2011.9.16 如果不是产品证书则，打印所有log
    //if( COMPILING_CURTYPE != COMPILING_DISTRIBUTION)
    if (1)
    {
        va_list         args;
        va_start(args,  format); 
        //        BOTHLog(format, args);
        DebugLog(format, args);
    }
}


@end
