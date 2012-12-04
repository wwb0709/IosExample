//
//  SysPersonEntity.h
//  HaoLL
//
//  Created by memac memac on 10-9-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

//#import "ABContact.h"

@interface SysPersonEntity : NSObject 
{
	/// ID
	NSString*	ID;

	/// 签名
	NSString*	signature;
	/// 电话呼入次数	
	NSInteger	incomingCall;
	/// 电话拨出次数	
	NSInteger	outgoingCall;
	/// 通话次数	
	NSInteger	callCount;
	/// 收到信息条数	
	NSInteger	receivedMessage;
	/// 发送信息条数	
	NSInteger	issuedMessage;
	/// 信息条数
	NSInteger	messageCount;
	/// 通讯次数，包括电话次数与短信次数的和
	NSInteger	communicationCount;
	/// 移动电话号码
	NSString*	phoneNum;
	/// 其它电话号码1
//	NSString*	otherNumber1;
	/// 其它电话号码2
//	NSString*	otherNumber2;
	NSMutableDictionary*	dictPhoneNum;
    /// IM
	NSString*	im;
	/// 电子邮件
	NSString*	email;
    NSMutableDictionary*	dictEmails;
	/// MSN地址
	NSString*	MSN;
	/// QQ号码
	NSString*	QQ;
	/// 个人主页
	NSString*	web;
	/// 个人博客
	NSString*	blog;
	/// 出生年
	NSInteger	yearOfBirth;
	/// 出生月
	NSInteger	monthOfBirth;
	/// 出生日
	NSInteger	dayOfBirth;
	/// 地址
	NSString*	address;
	/// 备注
	NSString*	remark;
	/// 注册状态
	NSInteger	regState;
	/// 状态
	NSInteger	status;

	/// 所属分组的ID集合
	NSString*	groupIDList;
	/// 该联系人所属用户的IMSI号
	NSString*	IMSI;
	/// 该联系人所属用类型 （sim卡或者outlook）
	NSString*	contactType;
	/// 来去电头像路径
	NSString*	callerPath;
	///
	NSString*	lastName;
	///
	NSString*	firstName;
	/// 是否上传过
	BOOL		isUpload;
	//来电铃声的名称
	NSString*	commingCallRingToneName;
	//来电铃声的路径
	NSString*	commingCallRingTonePath;
	//去电铃声的名称
	NSString*	outGoingCallRingToneName;
	//去电铃声的路径
	NSString*	outGoingCallRingTonePath;
	/// 该IMSI对应的用户是否已激活
	BOOL		isActivated;
	/// 自定义状态名称
	NSString*	customStatus;
	
	/// 头像ID	
	NSString*	avatar;
	
	//  头像栏目ID
	NSString *  avatarFolderID;
	
	/// 头像路径
	NSString*	avatarPath;
	
	//UIImage*	sysImage;
	bool		haveSysImage;
}

//@property(nonatomic, retain)	UIImage*	sysImage;

@property(nonatomic, retain)	NSString*	im;
@property						bool		haveSysImage;
@property(nonatomic, retain)	NSString*	ID;
@property(nonatomic, retain)	NSString*	avatar;
@property(nonatomic, retain)	NSString*	signature;
@property						NSInteger	incomingCall;
@property						NSInteger	outgoingCall;
@property						NSInteger	callCount;
@property						NSInteger	receivedMessage;
@property						NSInteger	issuedMessage;
@property						NSInteger	messageCount;
@property						NSInteger	communicationCount;
@property(nonatomic, retain)	NSString*	phoneNum;
@property(nonatomic, retain)	NSMutableDictionary*	dictPhoneNum;
@property(nonatomic, retain)	NSString*	email;
@property(nonatomic, retain)	NSMutableDictionary*	dictEmails;
@property(nonatomic, retain)	NSString*	MSN;
@property(nonatomic, retain)	NSString*	QQ;
@property(nonatomic, retain)	NSString*	web;
@property(nonatomic, retain)	NSString*	blog;
@property						NSInteger	yearOfBirth;
@property						NSInteger	monthOfBirth;
@property						NSInteger	dayOfBirth;
@property(nonatomic, retain)	NSString*	address;
@property(nonatomic, retain)	NSString*	remark;
@property						NSInteger	regState;
@property						NSInteger	status;
@property(nonatomic, retain)	NSString*	avatarPath;
@property(nonatomic, retain)	NSString*	groupIDList;
@property(nonatomic, retain)	NSString*	IMSI;
@property(nonatomic, retain)	NSString*	contactType;
@property(nonatomic, retain)	NSString*	callerPath;
@property(nonatomic, retain)	NSString*	lastName;
@property(nonatomic, retain)	NSString*	firstName;
@property						BOOL		isUpload;
@property(nonatomic, retain)	NSString*	commingCallRingToneName;
@property(nonatomic, retain)	NSString*	commingCallRingTonePath;
@property(nonatomic, retain)	NSString*	outGoingCallRingToneName;
@property(nonatomic, retain)	NSString*	outGoingCallRingTonePath;
@property						BOOL		isActivated;
@property(nonatomic, retain)	NSString*	customStatus;
@property(nonatomic, retain)	NSString *  avatarFolderID;

-(id)						init;
-(void)						dealloc;
-(void)						clear;
-(SysPersonEntity *)	entityDeepCopy;
//==========================更新本联系人
-(void)						entityUpdate:(SysPersonEntity*) entity;
//==========================执行恢复操作时使用
-(void)						recoverUpdate:(SysPersonEntity *) entity;
//从HLL联系人实体转换为系统通讯录对应的实体
//-(ABContact *)convert2ABContact;

//从系统通讯录对应的实体ABContact转换为 HLL联系人
//+(SysPersonEntity * )getOutlookContactEntityFromABContact : (ABContact *)abContact;
+(SysPersonEntity * )getSysPersonFromABRecordRef:(ABRecordRef) recordRef;
@end
