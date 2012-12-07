//
//  Enum.h
//  DigitAlbum
//
//  Created by  on 11-9-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTabBarHeight 49.0f
//新浪微博
#define kWBSDKDemoAppKey @"3097404234"
#define kWBSDKDemoAppSecret @"f547c092fad2e25f09d5f59f9fb2a619"


//post 文件参数
#define KPOSTDATA @"postdata"
#define KPOSTFILENAME @"postfilename"
#define KPOSTCONTENTTYPE @"postcontenttype"
#define KPOSTKEY @"postkey"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

typedef enum
{
	Iphone_1G,
	Iphone_2G,
	Iphone_3GS,
	Iphone_Touch_1G,
	Iphone_Touch_2G,
	Iphone_Touch_3G,
	Iphone_4,
    Iphone_4S,
	Iphone_Touch_4G,
    iPod_Touch_1G,
    iPod_Touch_2G,
    iPod_Touch_4G,
    iPad_1G,
    iPad_2G,
    Iphone_Above4   //tank:2011.12.6 所有已经超过了4的新手机，我们现在使用这个标志,
}PlatFormType;

//现有主流嵌入式苹果机类型
typedef enum
{
	System_ios_3_x,
	System_ios_4_x,
    System_ios_5_x
}SystemType;

typedef enum
{
	DeviceModel_Iphone,
	DeviceModel_IpodTouch
}DeviceModelType;

typedef enum
{
    DARequestType_User_Login=0,//用户登陆
    DARequestType_User_Regist,//用户注册
    DARequestType_User_GetVerifyCode,//获取验证码
    DARequestType_User_GetPass,//获取密码
    DARequestType_User_ResetPass,//重置密码
    DARequestType_DownShopImage,
    DARequestType_DownSaleImage,
    DARequestType_Address_Back,//备份
    DARequestType_Address_Recover,//恢复
    DARequestType_SalesDetail, //查询优惠详情
    DARequestType_Number_Seach,//号码检索
    DARequestType_Number_Group,//精品号库分组
    DARequestType_Number_GroupDetail,//精品号库详情
    DARequestType_Merchant_YiSou,//商户搜索一搜
    DARequestType_Merchant_Merchant,//附近商户
    DARequestType_Merchant_MerchantSale,//附近商户优惠
    DARequestType_Merchant_GetCity,//获取城市
    DARequestType_FeedBack,  //问题反馈
    DARequestType_update, //更新请求
    DARequestType_SendUserBehavior, //发送用户行为统计
    DARequestType_SendInstall, //发送安装请求
    DARequestType_LoginRequest //用户登陆统计

}DARequestTypeEnum;//请求类型


typedef enum
{
    DARequestState_Ready,//准备
    DARequestState_Start,//开始
    DARequestState_Finish,//完成
    DARequestState_Fail,//失败
    DARequestState_Cancel//取消
}DARequestStateEnum;//请求状态枚举


typedef enum
{
    DAReturnDataType_String,//字符串
    DAReturnDataType_Data//数据
}DAReturnDataTypeEnum;//返回的数据类型

typedef enum
{
    DANetworkType_HttpRequest,
    DANetworkType_FormDataRequest
}DANetworkTypeEnum;//网络提交类型

typedef enum 
{
    BusinessErrorCode_None                                      = 0,
    BusinessErrorCode_ASIConnectionFailureErrorType             = 1,
    BusinessErrorCode_ASIRequestTimedOutErrorType               = 2,
    BusinessErrorCode_ASIAuthenticationErrorType                = 3,
    BusinessErrorCode_ASIRequestCancelledErrorType              = 4,
    BusinessErrorCode_ASIUnableToCreateRequestErrorType         = 5,
    BusinessErrorCode_ASIInternalErrorWhileBuildingRequestType  = 6,
    BusinessErrorCode_ASIInternalErrorWhileApplyingCredentialsType  = 7,
	BusinessErrorCode_ASIFileManagementError                    = 8,
	BusinessErrorCode_ASITooMuchRedirectionErrorType            = 9,
	BusinessErrorCode_ASIUnhandledExceptionError                = 10,
	BusinessErrorCode_ASICompressionError                       = 11,
    
    BusinessErrorCode_LLQ_ServerError00                       = 21,
    BusinessErrorCode_LLQ_ServerError05                       = 22,    //
    BusinessErrorCode_LLQ_ServerError25                       = 25,    //文字提示
    BusinessErrorCode_LLQ_ServerError26                       = 26    //文字提示（需要跳转）
}BusinessErrorCode;

