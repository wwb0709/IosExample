//
//  DAUtility.h
//  DigitAlbum
//
//  Created by  on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h> 
#import "UIDevice+IdentifierAddition.h"
#import "DATypeDefine.h"
#import "EncryptionAndDecryption.h"


//#import "UIUtility.h"
@interface DAUtility : NSObject
+(BOOL) isOSVerEqualOrLarge:(NSString*) reqSysVer;
//文件夹
+(NSString*)getAppDocumentDir; //获取程序Document目录

+(BOOL) FileExists:(NSString*)path;//文件或文件夹是否存在
+(BOOL) UnzipToPath:(NSString*)path destDir:(NSString*)destDir;//解压文件
+(NSString*) ReadStringFromPath:(NSString*) path;//从文件读取文本

+(NSString*) getUDID;//获取UDID(Unique Device Identifier)
//+(NSString*) getVersion;//获取版本号
+(NSString *)getResolution;//当前屏幕的分辨率

+(NSInteger)getRandomNum:(NSInteger) maxNum;//获取随机数
+(NSString*) GetFileNameFromPathNoExtension:(NSString*) path;//从一个路径获取文件名无扩展名得
+(NSString*) GetFileNameFromPath:(NSString*) path;//从一个路径获取文件名
+(NSString*) GetDirFromPath:(NSString*) path;//从一个路径获取父文件夹
+(BOOL) DeleteFile:(NSString*) path;//删除一个文件
+(UIImage*)getRectBordImageWithColors:(UIColor*)colors
                                 rect:(CGRect)imgRect;//
+ (NSInteger) getLinesWithText:(NSString*)			txt 
					  textFont:(UIFont*)			font
					 rectWidth:(CGFloat)			width
				 lineBreakMode:(UILineBreakMode)	mode;//取文本显示的行数

+(CGSize)GetImageSize:(CGFloat)maxLength size:(CGSize)size;//获取图片的等比尺寸
+(CGSize)GetImageSizeByHeight:(CGFloat)maxHeight size:(CGSize)size;//根据高度获得图片的等比尺寸
+ (BOOL) directoryCreate : (NSString *)directory;//创建文件夹
+ (NSString*) GetFormatTimeFromDate : (NSDate*)date;//获取格式化的时间
+ (NSString*) GetFormatTimeFromCurremtDate;//获取当前的年月日
+ (NSString*) GetFormatTimeFromInterval : (NSTimeInterval)timeInterval;//获取格式化的时间
+ (NSString*) GetFormatTime : (NSDate*)date;//获取格式化的时间

+(void) isStatusBarShow;
+ (UIImage *) scaleImageToSize: (UIImage *) image toSize: (CGSize) size;//拉伸图片
+ (void)showMsgInStatusBar:(NSString*)msg;//在状态栏显示信息
//2012.03.12 songchunzhi
+(NSString*) getShopImage;//获取商户图片
+(NSString*) getSaleImage;//获取优惠券图片

//存放用户行为统计的目录
+(NSString*)getUserBehaviorDir;
+(NSString *)CurrentBehavior;
+(NSMutableDictionary*)GetBehaviorContentDic;
+(void) deleteBehaviorFiles;


//创建文件夹用来标示第一次启动
+(void)CreateFirstLoginDir;
+(BOOL)IsFirstLoginDirExist;


//根据名字查找view
+ (UIView*) findViewWithClassName:(NSString*)  claName
                          inViews:(NSArray*) views;


+ (MFMailComposeViewController*)getMailCtrler;
+ (void) releaseMailCtrlerWithShowCtrler:(UIViewController*) ctrler;

//调用系统接口群发邮件 add by wwb
+ (void)systemGroupSendMail: (NSArray*)mails
                    subject: (NSString*)subject
                       body: (NSString*)body
                  imagePath: (NSString*)imagePath
			 ctrlerDelegate: (id<MFMailComposeViewControllerDelegate>) sender
             viewController: (UIViewController*) ctrler;
//向某些号码发送某些内容 add by wwb
+(BOOL)systemSendMsgForContent:(NSArray*)phoneNums
					   content:(NSString *)body
                      delegate:(id<MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>) delegate
             supViewController:(UIViewController *) viewcontroller;




//等待框
+(void)removeHUDFromSuperview;
+(void)showHUD:(NSString *) titleStr yOffset:(float) offset;
+(void)showHUD:(NSString *) titleStr;
+(void)showHUD_noCover:(NSString *) titleStr;
+(void)hideHUD;

//播放声音
+(void)playSoundForPsstUp;
+(void)playSoundForUp;
+(void)playSoundPsstDown;


//判断手机操作系统类型
+(SystemType)currentSystemType;
//判断设备是否支持打电话
+ (BOOL)phoneCanCall;
//判断设备是iphone 还是 touch
+(DeviceModelType)currentDeviceModelType;


//组装URL
+ (NSURL *)smartURLForString:(NSString *)str;
@end
