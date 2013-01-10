//
//  DAUtility.m
//  DigitAlbum
//
//  Created by  on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DAUtility.h"
#import "ZipArchive.h"
#include <sys/sysctl.h>
#include "MBProgressHUD.h"
#import <AudioToolbox/AudioToolbox.h>

//typedef enum
//{
//    /*
//     AppleTV(2G) (AppleTV2,1)
//     iPad (iPad1,1)
//     iPad2,1 (iPad2,1)Wifi版
//     iPad2,2 (iPad2,2)GSM3G版
//     iPad2,3 (iPad2,3)CDMA3G版
//     iPhone (iPhone1,1)
//     iPhone3G (iPhone1,2)
//     iPhone3GS (iPhone2,1)
//     iPhone4 (iPhone3,1)
//     iPhone4(vz) (iPhone3,3)iPhone4 CDMA版
//     iPhone4S (iPhone4,1)
//     iPodTouch(1G) (iPod1,1)
//     iPodTouch(2G) (iPod2,1)
//     iPodTouch(3G) (iPod3,1)
//     iPodTouch(4G) (iPod4,1)
//     */
//	iPhone_1G,
//	iPhone_2G,
//	iPhone_3GS,
//	iPod_Touch_1G,
//	iPod_Touch_2G,
//	iPod_Touch_3G,
//	iPhone_4,
//    iPhone_4S,
//	iPod_Touch_4G,
//    iPad_1G,
//    iPad_2G
//}PlatFormType;


static MFMailComposeViewController* s_mailController;
@implementation DAUtility

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
//获取程序Document目录
+(NSString*)getAppDocumentDir
{
    static NSString *documentsDir;
    if (!documentsDir) {
        NSArray *pathArr=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir=[[pathArr objectAtIndex:0] retain];
    }
    return documentsDir;
}

//我的收藏中商铺和优惠券图片
+(NSString*)getPosterDir
{
    static NSString *posterDir;
    if (!posterDir)
    {
        posterDir=[[NSString stringWithFormat:@"%@/favorite/",[DAUtility getAppDocumentDir]] retain];
    }
    return posterDir;
}

//存放用户行为统计的目录
+(NSString*)getUserBehaviorDir
{
    static NSString *posterDir;
    if (!posterDir)
    {
        posterDir=[[NSString stringWithFormat:@"%@/userbehavior/",[DAUtility getAppDocumentDir]] retain];
    }
    return posterDir;
}


//创建文件夹用来标示第一次启动
+(void)CreateFirstLoginDir
{
    [DAUtility directoryCreate:[NSString stringWithFormat:@"%@/FirstLogin/", [DAUtility getAppDocumentDir]]];
}
+(BOOL)IsFirstLoginDirExist
{
    NSString *dir = [NSString stringWithFormat:@"%@/FirstLogin/", [DAUtility getAppDocumentDir]];
    return [self FileExists:dir];
}

+(BOOL) FileExists:(NSString*)path
{
    NSFileManager* manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:path];
}

+(BOOL) UnzipToPath:(NSString*)zipPath destDir:(NSString*)destDir
{
    BOOL		ret=	NO;
	ZipArchive* zip =	[[ZipArchive alloc] init];
	//=======打开ZIP文件,准备解压缩
	if( [zip UnzipOpenFile:zipPath] )
	{
		//====解压ZIP文件
		ret = [zip UnzipFileTo:destDir overWrite:YES];
		//====关闭ZIP文件
		[zip UnzipCloseFile];
	}
	[zip release];
    return ret;
}

+(NSString*) ReadStringFromPath:(NSString*) path
{
	NSData *reader = [NSData dataWithContentsOfFile:path];
	NSString *returnStr= [[[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding]autorelease];	
    return returnStr;
}

//Unique Device Identifier
+(NSString*) getUDID
{    
	//return [[UIDevice currentDevice] uniqueIdentifier];
    return [[UIDevice currentDevice] uniqueDeviceIdentifier];
}

////获取版本号
//+(NSString*) getVersion
//{
//    return @"1.0.2";
//}

+(NSInteger)getRandomNum:(NSInteger) maxNum
{
    static NSInteger playIndex=-1;
    //第一次触发时设置种子
    if (playIndex==-1) {
        srandom(time(NULL));
    }
    //保证获取的随机值不等于当前索引
    NSInteger newNum=[[NSNumber numberWithLong:(random()%maxNum)] intValue];
    while (newNum==playIndex) {
        newNum=[[NSNumber numberWithLong:(random()%maxNum)] intValue];
    }
    playIndex=newNum;
    return playIndex;
}

+(NSString*) GetFileNameFromPath:(NSString*) path
{
    NSArray *pathArr=[path pathComponents];
    return [pathArr objectAtIndex:pathArr.count-1];
}

+(BOOL) DeleteFile:(NSString*) path
{
    NSError *error;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:&error];
}
+(UIImage*)getRectBordImageWithColors:(UIColor*)colors
                                 rect:(CGRect)imgRect

{
    UIImage*		ui_img=		nil;
    CGSize size= imgRect.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef    bmpContext = UIGraphicsGetCurrentContext();
	if (bmpContext)
	{
		CGContextSaveGState(bmpContext);
		
        CGContextSetLineWidth(bmpContext, 2.0);
        CGContextSetFillColorWithColor(bmpContext, [UIColor whiteColor].CGColor);
        CGContextSetStrokeColorWithColor(bmpContext, [UIColor colorWithRed:190.0/255 green:190.0/255 blue:190.0/255 alpha:1.0].CGColor);
        CGContextAddRect(bmpContext, imgRect);
        CGContextFillRect(bmpContext, imgRect);
        CGContextAddRect(bmpContext, imgRect);
        CGContextDrawPath(bmpContext, kCGPathStroke);
		CGImageRef   img = CGBitmapContextCreateImage(bmpContext);  
		ui_img = [UIImage imageWithCGImage: img];  
		CGImageRelease(img);
		
		CGContextRestoreGState(bmpContext);
    }
    UIGraphicsEndImageContext();
	
	return ui_img;
}
+ (NSInteger) getLinesWithText:(NSString*)			txt 
					  textFont:(UIFont*)			font
					 rectWidth:(CGFloat)			width
				 lineBreakMode:(UILineBreakMode)	mode
{
	if (nil==txt || nil==font)
		return 0;
	NSInteger	lins=		0;
	CGFloat	maxHeight=		500;
	CGSize sizeForHeight=	[txt sizeWithFont:font];
	CGSize sizeForLines=	[txt sizeWithFont:font constrainedToSize:CGSizeMake(width, maxHeight) lineBreakMode:mode];
	
	lins= ceil(sizeForLines.height/sizeForHeight.height);	
	return lins;
}

+(CGSize)GetImageSize:(CGFloat)maxLength size:(CGSize)size
{
    if (size.width<=maxLength) {
        return size;
    }
    CGFloat scale=size.width>=size.height?size.width/size.height:size.height/size.width;
    CGFloat width=0;
    CGFloat height=0;
    if (size.width>=size.height) {
        width=maxLength;
        height=width/scale;
    }
    else
    {
        height=maxLength;
        width=height/scale;
    }
    return CGSizeMake(width, height);
}

+(CGSize)GetImageSizeByHeight:(CGFloat)maxHeight size:(CGSize)size
{
    CGFloat scale=size.width>=size.height?size.width/size.height:size.height/size.width;
    CGFloat width=0;
    CGFloat height=0;
    if (size.width>=size.height) {
        height=maxHeight;
        width=height*scale;
    }
    else
    {
        height=maxHeight;
        width=height/scale;
    }
    return CGSizeMake(width, height);
}

//创建目录，成功则返回YES
+ (BOOL) directoryCreate : (NSString *)directory
{
	BOOL bRet = NO;
	NSString *path = directory;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	bRet = [fileManager fileExistsAtPath:path];
	if (!bRet)
	{
		NSError * tmpErr = nil;
		bRet = [fileManager createDirectoryAtPath:path 
                      withIntermediateDirectories:YES 
                                       attributes:nil
                                            error:&tmpErr
                ];
		
		//printLog(@"%d",bRet);
	}
	return bRet;	
}

+ (NSString*) GetFormatTimeFromDate : (NSDate*)date
{
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setAMSymbol:NSLocalizedString(@"上午",nil)];
        [formatter setPMSymbol:NSLocalizedString(@"下午",nil)];
        [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd%@ a hh:mm",NSLocalizedString(@"年",nil),NSLocalizedString(@"月",nil),NSLocalizedString(@"日",nil)]];

    }
    NSString *timeText = [formatter stringFromDate:date];
    return timeText;
}

+ (NSString*) GetFormatTimeFromCurremtDate
{
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];

        [formatter setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd"]];
        
    }
    NSString *timeText = [formatter stringFromDate:[NSDate date]];
    return timeText;
}

+ (NSString*) GetFormatTimeFromInterval : (NSTimeInterval)timeInterval
{
//    static NSDateFormatter *formatter;
//    if (!formatter) {
//        formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"mm:ss"];
//        
//    }
//    NSString *timeText = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    NSInteger minute=(NSInteger)(timeInterval/60);
    NSString *timeMinuteText=[NSString stringWithFormat:(minute<10?@"0%d":@"%d"),minute];
    NSInteger second=(NSInteger)timeInterval%60;
    NSString *timesecondText=[NSString stringWithFormat:(second<10?@"0%d":@"%d"),second];
    return [NSString stringWithFormat:@"%@:%@",timeMinuteText,timesecondText];
}


+(BOOL) isOSVerEqualOrLarge:(NSString*) reqSysVer{
    BOOL ret=NO;
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
        ret=YES;
    }
    return ret;
}


+(PlatFormType)currentPlatformType
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    
	NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
	PlatFormType retType = Iphone_3GS;
	/*
     AppleTV(2G) (AppleTV2,1)
     iPad (iPad1,1)
     iPad2,1 (iPad2,1)Wifi版
     iPad2,2 (iPad2,2)GSM3G版
     iPad2,3 (iPad2,3)CDMA3G版
     
     iPhone (iPhone1,1)
     iPhone3G (iPhone1,2)
     iPhone3GS (iPhone2,1)
     iPhone4 (iPhone3,1)
     iPhone4(vz) (iPhone3,3)iPhone4 CDMA版
     iPhone4S (iPhone4,1)
     iPodTouch(1G) (iPod1,1)
     iPodTouch(2G) (iPod2,1)
     iPodTouch(3G) (iPod3,1)
     iPodTouch(4G) (iPod4,1)
     */
	if ([platform isEqualToString:@"iPhone1,1"]) 
    {
		retType = Iphone_1G;
	}
    else if ([platform isEqualToString:@"iPhone1,2"]) 
    {
		retType = Iphone_2G;
	}
    else if ([platform isEqualToString:@"iPhone3,1"]) 
    {
		retType = Iphone_4;
	}
    else if ([platform isEqualToString:@"iPhone3,3"]) 
    {
		retType = Iphone_4;
	}
    else if ([platform isEqualToString:@"iPhone4,1"]) 
    {
		retType = Iphone_4S;
	}
    else if ([platform isEqualToString:@"iPhone2,1"]) 
    {
		retType = Iphone_3GS;
	}
    else if ([platform isEqualToString:@"iPod1,1"]) 
    {
		retType = iPod_Touch_1G;
	}
    else if ([platform isEqualToString:@"iPod2,1"]) 
    {
		retType = iPod_Touch_2G;
	}
    else if ([platform isEqualToString:@"iPod4,1"]) 
    {
		retType = iPod_Touch_4G;
	}    
    else if ([platform isEqualToString:@"iPad1,1"]) 
	{
		retType = iPad_1G;
	}
	else if ([platform isEqualToString:@"iPad2,1"]) 
	{
		retType = iPad_2G;
	}
	
    return retType;
}

+(NSString *)getResolution
{    
    if([self currentPlatformType] == Iphone_4 || [self currentPlatformType] == iPod_Touch_4G || [self currentPlatformType] == Iphone_4S)
        return @"960x640";
    
    if([self currentPlatformType] == iPad_1G || [self currentPlatformType] == iPad_2G)
        return @"1024x768";
    
    return @"480x320";
}


+ (NSString*) GetFormatTime : (NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:NSLocalizedString(@"上午",nil)];
    [formatter setPMSymbol:NSLocalizedString(@"下午",nil)];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd%@ a hh:mm",NSLocalizedString(@"年",nil),NSLocalizedString(@"月",nil),NSLocalizedString(@"日",nil)]];
    NSString *timeText = [formatter stringFromDate:date];
    [formatter release];
    return timeText;
}




+ (UIImage *) scaleImageToSize: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(NSString*) GetDirFromPath:(NSString*) path
{
    NSArray *pathArr=[path pathComponents];
    NSString* fileName= [pathArr objectAtIndex:pathArr.count-1];
    NSString* dirPath= [path stringByReplacingOccurrencesOfString:fileName withString:@""];
    if (![dirPath hasSuffix:@"/"]) {
        return [NSString stringWithFormat:@"%@/",dirPath];
    }
    return dirPath;
}

+(NSString*) GetFileNameFromPathNoExtension:(NSString*) path
{
    NSArray *pathArr=[path pathComponents];
    NSString *fileName= [pathArr objectAtIndex:pathArr.count-1];
    return [fileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",[path pathExtension]] withString:@""];
}

static bool isstatusbarshow;
+ (void)showMsgInStatusBar:(NSString*)msg
{
    if (isstatusbarshow) {
        return ;
    }
    CGRect statusBarFrame=[[UIApplication sharedApplication] statusBarFrame];
    
    UIWindow* wd = [[UIWindow alloc] initWithFrame:statusBarFrame];
    [wd setBackgroundColor:[UIColor clearColor]];
    [wd setWindowLevel:UIWindowLevelStatusBar];
    wd.clipsToBounds=YES;
    //UILabel *statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,statusBarFrame.size.height, statusBarFrame.size.width, statusBarFrame.size.height)];
    UILabel *statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, statusBarFrame.size.width, statusBarFrame.size.height)];
    statusLabel.alpha=0.0;
    statusLabel.backgroundColor=[UIColor blackColor];
    statusLabel.textColor=[UIColor whiteColor];
    statusLabel.font=[UIFont systemFontOfSize:12];
    statusLabel.textAlignment=UITextAlignmentCenter;
    statusLabel.text=msg;
    
    UIWindow* appWd=[[UIApplication sharedApplication] keyWindow];
    [wd addSubview:statusLabel];
    [wd makeKeyAndVisible];
    
    UIViewAnimationOptions options=UIViewAnimationCurveLinear|UIViewAnimationOptionAllowUserInteraction;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^(void) {
        //statusLabel.frame=CGRectMake(0,0, statusBarFrame.size.width, statusBarFrame.size.height);
        statusLabel.alpha=1.0;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:2.0 options:options animations:^(void) {
            //statusLabel.frame=CGRectMake(0,-statusBarFrame.size.height, statusBarFrame.size.width, statusBarFrame.size.height);
            statusLabel.alpha=0.0;
        } completion:^(BOOL finished) {
            [statusLabel removeFromSuperview];
            [statusLabel release];
            [wd resignFirstResponder];
            [wd resignKeyWindow];
            [wd release];
            [appWd makeKeyAndVisible];
            isstatusbarshow = false;
        }];
    }];
}
+(void) isStatusBarShow{
    isstatusbarshow = true;
}


+(NSString*) getShopImage;//获取商户图片
{
    NSString *shopDir=[NSString stringWithFormat:@"%@/shop/",[DAUtility getPosterDir]];
    
    if (![DAUtility FileExists:shopDir]) {
        [DAUtility directoryCreate:shopDir];
    }
    return shopDir;
}
+(NSString*) getSaleImage;//获取优惠券图片
{
    NSString *saleDir=[NSString stringWithFormat:@"%@/sale/",[DAUtility getPosterDir]];
    
    if (![DAUtility FileExists:saleDir]) {
        [DAUtility directoryCreate:saleDir];
    }
    return saleDir;
}

+(NSString *)CurrentBehavior
{
    NSMutableString* content = [[NSMutableString alloc] initWithCapacity:10]; 
    NSMutableDictionary* dic = [self GetBehaviorContentDic];
    NSArray * keys = [dic allKeys];
    for (id key in keys) {
         [content appendFormat:@"<d><t>%@</t><c>%@</c></d>",key,[dic objectForKey:key]];
    }
    
    return content;
}
//获取文件夹下的所有行为数据
+(NSMutableDictionary*)GetBehaviorContentDic
{   
     NSMutableDictionary * tmpDict = [[[NSMutableDictionary alloc]init] autorelease];
    
//    [tmpDict setObject:@"1.10|2.10|3.10|4.10|5.3|6.2" forKey:@"2012-03-31"];
//    
//    [tmpDict setObject:@"1.10|2.10|3.10|4.10|5.3|6.2" forKey:@"2012-04-01"];

        NSFileManager *manager = [NSFileManager defaultManager];

        NSError *error = nil;
        NSArray *fileList = [manager contentsOfDirectoryAtPath:[self getUserBehaviorDir] error:&error];
        for(NSString *file in fileList) 
        {
            if(file != @"." && file != @"..") 
            {
                printLog(@"%@",file);
                NSString* filePath =[NSString stringWithFormat:@"%@%@", [self getUserBehaviorDir],[self GetFileNameFromPath:file]];
                NSString* value = [self ReadStringFromPath:filePath];
                NSString* key =  [self GetFileNameFromPath:file];
               
                NSRange range = [key rangeOfString:@".txt"];
                if (range.length>0) 
                {
                    key = [key substringToIndex:range.location];
                }
                NSString *currentDate = [self GetFormatTimeFromCurremtDate];
                if (![currentDate isEqualToString:key]) 
                {    
                    if(key!=nil&&range.length>0)
                     [tmpDict setObject:value forKey:key];
                } 
                
                
            }
        }

    return tmpDict;  
}
//如果发送成功则删除发送过的行为数据
+(void) deleteBehaviorFiles
{

    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *fileList = [manager contentsOfDirectoryAtPath:[self getUserBehaviorDir] error:&error];
    for(NSString *file in fileList) 
    {
        if(file != @"." && file != @"..") 
        {
            //NSLog(@"%@",file);
            NSString* filePath =[NSString stringWithFormat:@"%@%@", [self getUserBehaviorDir],[self GetFileNameFromPath:file]];
            NSString* key =  [self GetFileNameFromPath:file];
            NSRange range = [key rangeOfString:@".txt"];
            if (range.length>0) 
            {
                key = [key substringToIndex:range.location];
            }
            NSString *currentDate = [self GetFormatTimeFromCurremtDate];
            if (![currentDate isEqualToString:key])
            {
                if(key!=nil&&range.length>0)
                 [self DeleteFile:filePath];
            } 
            
            
        }
    }
}

//根据名字查找view
+ (UIView*) findViewWithClassName:(NSString*)  claName
                          inViews:(NSArray*) views
{
    NSLog(@"%@", views);
    if (nil==views)
        return nil;
    
    for (UIView* subV in views)
    {
        if([[NSString stringWithUTF8String:object_getClassName(subV)] isEqualToString:claName])
        {
            return subV;
        }
        else
        {
            UIView* subSubV= [self findViewWithClassName:claName inViews:[subV subviews]];
            if (subSubV)
                return subSubV;
        }
    }    
    return nil;
}

//发送邮件和短信



+ (MFMailComposeViewController*)getMailCtrler
{
    @synchronized(self)
    {
        if(nil==s_mailController)
        {
            s_mailController=  [[MFMailComposeViewController alloc] init];
        }
    }
    return s_mailController;
}

+ (void) releaseMailCtrlerWithShowCtrler:(UIViewController*) ctrler
{
    @synchronized(self)
    {
        if(s_mailController)
        {
            [UIView animateWithDuration:0.4f
                             animations:^(void) 
             {
                 CGRect rc=    s_mailController.view.frame;
                 rc= CGRectOffset(rc, 0, 460);
                 s_mailController.view.frame=    rc;
                 
             } 
             completion:^(BOOL finished) 
             {
                 [s_mailController.view removeFromSuperview];
                 [s_mailController release];
                 s_mailController=   nil;
             }];
            
        }
    }    
}

//向某些号码发送某些内容 add by wwb
+(BOOL)systemSendMsgForContent:(NSArray*)phoneNums
					   content:(NSString *)body
                      delegate:(id<MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>) delegate
             supViewController:(UIViewController *) viewcontroller
{
	if (NO==[DAUtility phoneCanCall]) 
	{	
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                            message:NSLocalizedString(@"此设备无法发送短信。",nil)
                                                           delegate:nil 
                                                  cancelButtonTitle:@"好"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
		return FALSE;
	}
	if ([DAUtility currentSystemType]>=System_ios_4_x)
	{

			BOOL canSendSms= [MFMessageComposeViewController canSendText];
			
			if (canSendSms)
			{
				MFMessageComposeViewController	*picker= [[MFMessageComposeViewController alloc]init];
				picker.messageComposeDelegate= delegate;
                picker.delegate=               delegate;
				picker.recipients=              phoneNums;
				picker.body=                    body;
				UIViewController * topViewController = viewcontroller;
                [picker.navigationBar setImage:@"NavigationBarImage.png"];
				[topViewController presentModalViewController:picker animated:YES];
				//NSLog(@"%@",[topViewController class]);
                
				[picker release];
                
                
			}
		
	}
	//else 
    //	{
    //		if (phoneNums && [phoneNums count]>0)
    //		{
    //			NSUInteger		index;
    //			NSMutableString *msg = [NSMutableString stringWithString:@"sms://"];
    //			for (index=0; index<[phoneNums count]; ++index)
    //			{
    //				[msg appendFormat:@"%@%@", (index==0 ? @"":@","), [phoneNums objectAtIndex:index]]; 
    //			}
    //			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:msg]]; //发短信 
    //		}
    //	}
    return TRUE;
	
}

//调用系统接口群发邮件
+ (void)systemGroupSendMail: (NSArray*)mails
                    subject: (NSString*)subject
                       body: (NSString*)body
                  imagePath: (NSString*)imagePath
			 ctrlerDelegate: (id<MFMailComposeViewControllerDelegate>) sender
             viewController: (UIViewController*) ctrler;
{

	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass && [mailClass canSendMail])
	{
		MFMailComposeViewController *picker = [self getMailCtrler];
		picker.mailComposeDelegate =    sender;
        //picker.delegate=                [DelegateCenter sharedDelegateCenter];
        if (mails)
            [picker setToRecipients:mails];
        if (subject)
            [picker setSubject:subject];
        if (body)
            [picker setMessageBody:body isHTML:NO];
        
        if ([imagePath length]>0&&imagePath) {
            NSData *data = [NSData dataWithContentsOfFile:imagePath]; 
            //        NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"bg_jingpin.png"]);  
            
            [picker addAttachmentData:data mimeType:@"image/png" fileName:@"blood_orange"];   
        }

		
        [picker.navigationBar setImage:@"NavigationBarImage.png"];	
        
        CGRect rcPre=   s_mailController.view.frame;
        CGRect rcNew=   CGRectOffset(rcPre, 0, 460);
        s_mailController.view.frame=    rcNew;
        [[UIApplication sharedApplication].keyWindow addSubview:picker.view];
        
        [UIView animateWithDuration:0.4f 
                         animations:^(void) 
         {
             s_mailController.view.frame=    rcPre;
             
         } 
            completion:^(BOOL finished) 
         {
             
         }];
	}
	else
	{
	
			NSUInteger		index=		0;
			NSMutableString *recipients = [NSMutableString stringWithString: @"mailto:"];
			for (index=0; index<[mails count]; ++index)
				[recipients appendFormat:@"%@%@", (index==0 ? @"":@","),[mails objectAtIndex:index]];
			
			NSString *email= [recipients stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
		
	}
    
}





+(void)removeHUDFromSuperview
{
    NSMutableArray *subviewsArr = [[NSMutableArray alloc ] initWithCapacity:3];
	for (UIView *v in [[[UIApplication sharedApplication] keyWindow] subviews])
    {
		if ([v isKindOfClass:[MBProgressHUD class]]) 
        {
			[subviewsArr addObject:v];
		}
	}
    for (UIView *review in subviewsArr)
    {
        [review removeFromSuperview];
    }
    [subviewsArr release];
}

+(void)showHUD:(NSString *) titleStr
{
    [DAUtility removeHUDFromSuperview];
    UIWindow * keyWin = [[UIApplication sharedApplication] keyWindow];
    if (keyWin != nil) 
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:keyWin animated:YES coverType:PROGRESS_HUD_TYPE_COVER];
        HUD.labelText = titleStr;
        HUD.yOffset = -40;
    }
    return;
}

+(void)showHUD:(NSString *) titleStr yOffset:(float) offset
{
    [DAUtility removeHUDFromSuperview];
    UIWindow * keyWin = [[UIApplication sharedApplication] keyWindow];
    if (keyWin != nil) 
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:keyWin animated:YES coverType:PROGRESS_HUD_TYPE_COVER];
        HUD.labelText = titleStr;
        HUD.yOffset = offset;
    }
    return;
}

+(void)showHUD_noCover:(NSString *) titleStr
{
    [DAUtility removeHUDFromSuperview];
    UIWindow * keyWin = [[UIApplication sharedApplication] keyWindow];
    if (keyWin != nil) 
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:keyWin animated:YES coverType:PROGRESS_HUD_TYPE_NOCOVER];
        HUD.labelText = titleStr;
        HUD.yOffset = -40;
    }
    return;
}
+(void)hideHUD
{
    UIWindow * keyWin = [[UIApplication sharedApplication] keyWindow];
    if (keyWin != nil) 
    {
        [MBProgressHUD hideHUDForView:keyWin animated:YES];
    }
    return;
}

+(void)playSoundForPsstUp
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"psst" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

+(void)playSoundForUp
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pop" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
}
+(void)playSoundPsstDown
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"psst_down" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

//判断手机操作系统类型
+(SystemType)currentSystemType
{
	SystemType retType = System_ios_3_x;
	NSString * tmpVersonType = [UIDevice currentDevice].systemVersion;
    
	NSArray * tmpArr = [tmpVersonType componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
	if ([[tmpArr objectAtIndex:0] isEqualToString:@"4"]) 
	{
		retType = System_ios_4_x;
	}
    else if([[tmpArr objectAtIndex:0] isEqualToString:@"5"])
    {
        retType= System_ios_5_x;
    }
    
	return retType;
}

+ (BOOL)phoneCanCall
{
	DeviceModelType type= [DAUtility currentDeviceModelType];
	switch (type) 
	{
		case DeviceModel_Iphone:
			return YES;
		default:
			return NO;
	}
}

//判断设备是iphone 还是 touch
+(DeviceModelType)currentDeviceModelType
{
	DeviceModelType retType = DeviceModel_IpodTouch;
	NSString * tmpDeviceModel = [UIDevice currentDevice].model;
	if ([tmpDeviceModel isEqualToString:@"iPhone"]) {
		retType = DeviceModel_Iphone;
	}
	return retType;
}


+ (NSURL *)smartURLForString:(NSString *)str

{
    
    NSURL *     result;
    
    NSString *  trimmedStr;
    
    NSRange     schemeMarkerRange;
    
    NSString *  scheme;
    
    
    
    result = nil;
    
    // 去除空白
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        
        
        if (schemeMarkerRange.location == NSNotFound) {
            
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
            
        } else {
            
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            
            assert(scheme != nil);
            
            
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                
                result = [NSURL URLWithString:trimmedStr];
                
            } else {
                
                // It looks like this is some unsupported URL scheme.
                
            }
            
        }
        
    }
    
    
    
    return result;
    
}
@end
