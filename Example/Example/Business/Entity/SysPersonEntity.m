//
//  SysPersonEntity.m
//  HaoLL
//
//  Created by memac memac on 10-9-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SysPersonEntity.h"
#import <AddressBook/ABPerson.h>

@implementation SysPersonEntity

@synthesize	ID;
@synthesize	avatar;
@synthesize	signature;
@synthesize	incomingCall;
@synthesize	outgoingCall;
@synthesize	callCount;
@synthesize	receivedMessage;
@synthesize	issuedMessage;
@synthesize	messageCount;
@synthesize	communicationCount;
@synthesize	phoneNum;
@synthesize	dictPhoneNum;
@synthesize	email;
@synthesize dictEmails;
@synthesize	MSN;
@synthesize	QQ;
@synthesize	web;
@synthesize	blog;
@synthesize yearOfBirth;
@synthesize	monthOfBirth;
@synthesize	dayOfBirth;
@synthesize	address;
@synthesize	remark;
@synthesize	regState;
@synthesize	status;
@synthesize	avatarPath;
@synthesize	groupIDList;
@synthesize	IMSI;
@synthesize	contactType;
@synthesize	callerPath;
@synthesize	lastName;
@synthesize	firstName;
@synthesize	isUpload;
@synthesize	commingCallRingToneName;
@synthesize	commingCallRingTonePath;
@synthesize	outGoingCallRingToneName;
@synthesize	outGoingCallRingTonePath;
@synthesize	isActivated;
@synthesize	customStatus;
@synthesize avatarFolderID;
//@synthesize sysImage;
@synthesize haveSysImage;
@synthesize im;


-(id)	init
{
	if(self=[super init])
	{
		lastName=	NULL;
		firstName=	NULL;
		phoneNum=	NULL;
		dictPhoneNum=	NULL;
        
        email=	NULL;
		dictEmails=	NULL;
		
		status=	-1;//默认应该是未注册状态
		signature= NULL;
		avatar= NULL;	
		avatarFolderID = nil;
		avatarPath = nil;
		
		//sysImage=	 nil;
		haveSysImage= false;
        im = nil;
	}
	
	return self;
}
-(void)	dealloc
{
	[self clear];
	[super dealloc];
}

-(void) clear
{
	if (signature) 
	{
		[signature release];
		signature= NULL;
	}
	if(avatar)
	{
		[avatar release];
		avatar= NULL;
	}
	if(lastName)
	{
		[lastName release];
		lastName= NULL;
	}
	if(firstName)
	{
		[firstName release];
		firstName= NULL;	
	}
	if(phoneNum)
	{
		[phoneNum release];
		phoneNum= NULL;
	}
	
	self.dictPhoneNum=	nil;
    
    if(email)
	{
		[email release];
		email= NULL;
	}
	
	self.dictEmails=	nil;
	//self.sysImage=		nil;
	
	if (nil!=avatarPath) {
		[avatarPath release];
		avatarPath = nil;
	}
	if (nil!=avatarFolderID) {
		[avatarFolderID release];
		avatarFolderID = nil;
	}
    [im release];
    im = nil;
}

-(void)	recoverUpdate:(SysPersonEntity *) entity
{
	self.firstName=		entity.firstName;
	self.lastName=		entity.lastName;
	self.phoneNum=		entity.phoneNum;
	if(entity.dictPhoneNum)
		self.dictPhoneNum= [NSMutableDictionary dictionaryWithDictionary: entity.dictPhoneNum];
	else
		self.dictPhoneNum= nil;

	self.email=			entity.email;
    
    if(entity.dictEmails)
		self.dictEmails= [NSMutableDictionary dictionaryWithDictionary: entity.dictEmails];
	else
		self.dictEmails= nil;
	self.MSN=			entity.MSN;
	self.QQ=			entity.QQ;
	self.web=			entity.web;
	self.blog=			entity.blog;
	self.monthOfBirth=	entity.monthOfBirth;
	self.dayOfBirth=	entity.dayOfBirth;
	self.address=		entity.address;
	self.remark=		entity.remark;
}

//==========================更新本联系人
-(void)	entityUpdate:(SysPersonEntity*) entity
{
	if (entity)
	{
		//0
		self.address =			entity.address;
		self.avatar =			entity.avatar;
		self.avatarPath =		entity.avatarPath;
		self.blog =			entity.blog;
		self.callCount =		entity.callCount;
		
		//5
		self.callerPath =				entity.callerPath;
		self.commingCallRingToneName = entity.commingCallRingToneName;
		self.commingCallRingTonePath = entity.commingCallRingTonePath;
		self.communicationCount =		entity.communicationCount;
		self.contactType =				entity.contactType;
		
		//10
		self.customStatus =				entity.customStatus;
		self.dayOfBirth =				entity.dayOfBirth;
		self.email =					entity.email;
		self.firstName =				entity.firstName;
		self.groupIDList =				entity.groupIDList;
		
		//15
		self.ID =						entity.ID;
		self.IMSI =						entity.IMSI;
		self.incomingCall =				entity.incomingCall;
		self.isAccessibilityElement =	entity.isAccessibilityElement;
		self.isActivated =				entity.isActivated;
		
		//20
		self.issuedMessage =			entity.issuedMessage;
		self.isUpload =					entity.isUpload;
		self.lastName =					entity.lastName;
		self.messageCount =				entity.messageCount;
		self.monthOfBirth =				entity.monthOfBirth;
		
		//25
		self.MSN =						entity.MSN;
		if(entity.dictPhoneNum)
			self.dictPhoneNum=	[NSMutableDictionary dictionaryWithDictionary: entity.dictPhoneNum];
		else 
			self.dictPhoneNum=	nil;
        
        if(entity.dictEmails)
			self.dictEmails=	[NSMutableDictionary dictionaryWithDictionary: entity.dictEmails];
		else 
			self.dictEmails=	nil;
		self.outgoingCall =				entity.outgoingCall;
		self.outGoingCallRingToneName = entity.outGoingCallRingToneName;
		
		//30
		self.phoneNum =				entity.phoneNum;
		self.QQ =					entity.QQ;
		self.receivedMessage =		entity.receivedMessage;
		self.regState =				entity.regState;
		self.remark =				entity.remark;
		
		//35
		self.signature =			entity.signature;
		self.status =				entity.status;
		self.web =					entity.web;
		self.yearOfBirth =			entity.yearOfBirth;
		self.avatarFolderID =		entity.avatarFolderID;	
		//self.sysImage=				entity.sysImage;
		haveSysImage=				entity.haveSysImage;
	}
}


-(SysPersonEntity *)entityDeepCopy
{
	SysPersonEntity * retEntity = [[SysPersonEntity alloc]init];//[[[SysPersonEntity alloc]init] autorelease];
	
	//0
	retEntity.address = self.address;
	retEntity.avatar = self.avatar;
	retEntity.avatarPath = self.avatarPath;
	retEntity.blog = self.blog;
	retEntity.callCount = self.callCount;
	
	//5
	retEntity.callerPath = self.callerPath;
	retEntity.commingCallRingToneName = self.commingCallRingToneName;
	retEntity.commingCallRingTonePath = self.commingCallRingTonePath;
	retEntity.communicationCount = self.communicationCount;
	retEntity.contactType = self.contactType;
	
	//10
	retEntity.customStatus = self.customStatus;
	retEntity.dayOfBirth = self.dayOfBirth;
	retEntity.email = self.email;
	retEntity.firstName = self.firstName;
	retEntity.groupIDList = self.groupIDList;
	
	//15
	retEntity.ID = self.ID;
	retEntity.IMSI = self.IMSI;
	retEntity.incomingCall = self.incomingCall;
	retEntity.isAccessibilityElement = self.isAccessibilityElement;
	retEntity.isActivated = self.isActivated;
	
	//20
	retEntity.issuedMessage = self.issuedMessage;
	retEntity.isUpload = self.isUpload;
	retEntity.lastName = self.lastName;
	retEntity.messageCount = self.messageCount;
	retEntity.monthOfBirth = self.monthOfBirth;
	
	//25
	retEntity.MSN = self.MSN;
	if(self.dictPhoneNum)
		retEntity.dictPhoneNum=	[NSMutableDictionary dictionaryWithDictionary: self.dictPhoneNum];
	else 
		retEntity.dictPhoneNum= nil;
    if(self.dictEmails)
		retEntity.dictEmails=	[NSMutableDictionary dictionaryWithDictionary: self.dictEmails];
	else 
		retEntity.dictEmails= nil;
	retEntity.outgoingCall = self.outgoingCall;
	retEntity.outGoingCallRingToneName = self.outGoingCallRingToneName;
	
	//30
	retEntity.phoneNum = self.phoneNum;
	retEntity.QQ = self.QQ;
	retEntity.receivedMessage = self.receivedMessage;
	retEntity.regState = self.regState;
	retEntity.remark = self.remark;
	
	//35
	retEntity.signature = self.signature;
	retEntity.status = self.status;
	retEntity.web = self.web;
	retEntity.yearOfBirth = self.yearOfBirth;
	retEntity.avatarFolderID = self.avatarFolderID;
	retEntity.haveSysImage=	   self.haveSysImage;
	
	return retEntity;
}

//从HLL联系人实体转换为系统通讯录对应的实体
//-(ABContact*)convert2ABContact
//{
//	ABContact *contact = [ABContact contactWithRecordID:[self.ID intValue]];
//	return contact;
//}

+(SysPersonEntity * )getSysPersonFromABRecordRef:(ABRecordRef) recordRef
{
	SysPersonEntity * retEntity = nil;
    
	if (nil!=recordRef) 
	{
		retEntity = [[[SysPersonEntity alloc] init] autorelease];
		
		retEntity.ID =          [NSString stringWithFormat:@"%d", ABRecordGetRecordID(recordRef)];
		retEntity.firstName=    (NSString*)ABRecordCopyValue(recordRef, kABPersonFirstNameProperty);
		retEntity.lastName=     (NSString*)ABRecordCopyValue(recordRef, kABPersonLastNameProperty);	
		retEntity.haveSysImage= ABPersonHasImageData(recordRef); 
        
		//多值
        ABMultiValueRef mails=	ABRecordCopyValue(recordRef, kABPersonEmailProperty);
        NSInteger		count=	ABMultiValueGetCount(mails);
        if (mails && count>0)
        {
            NSString* mail= (NSString*)ABMultiValueCopyValueAtIndex(mails, 0);
            retEntity.email=	mail;
            [mail release];
            
            CFIndex	nIndex;
            CFIndex	nCount=	ABMultiValueGetCount(mails);
            for (nIndex=0; nIndex<nCount; ++nIndex)
            {
                NSString*	lable= (NSString*)ABMultiValueCopyLabelAtIndex(mails, nIndex);
                NSString*	mail= (NSString*)ABMultiValueCopyValueAtIndex(mails, nIndex);
                
                if (lable && mail)
                {
                    NSArray		*arr= [mail componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()- "]];
                    NSString	*emailAddr= [arr componentsJoinedByString:@""];
                    
                    //=========
                     /*if ([lable isEqualToString:(NSString*)kABPersonPhoneMobileLabel])
                        retEntity.phoneNum= [NSString stringWithString: phoneNum];*/
                    
                    if (retEntity.dictEmails==nil) 
                        retEntity.dictEmails= [NSMutableDictionary dictionaryWithCapacity:nCount];
                    [retEntity.dictEmails setObject:emailAddr forKey:lable];
                }
                
                [lable release];
                [mail release];
            }
                
        }
        CFRelease(mails);
        
        ABMultiValueRef phones= ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
        if (phones) 
        {
            CFIndex	nIndex;
            CFIndex	nCount=	ABMultiValueGetCount(phones);
            for (nIndex=0; nIndex<nCount; ++nIndex)
            {
                NSString*	lable= (NSString*)ABMultiValueCopyLabelAtIndex(phones, nIndex);
                NSString*	phone= (NSString*)ABMultiValueCopyValueAtIndex(phones, nIndex);
                
                if (lable && phone)
                {
                    NSArray		*arr= [phone componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()- "]];
                    NSString	*phoneNum= [arr componentsJoinedByString:@""];
                    
                    //=========是手机号码
                    if ([lable isEqualToString:(NSString*)kABPersonPhoneMobileLabel])
                        retEntity.phoneNum= [NSString stringWithString: phoneNum];
                    
                    if (retEntity.dictPhoneNum==nil) 
                        retEntity.dictPhoneNum= [NSMutableDictionary dictionaryWithCapacity:nCount];
                    [retEntity.dictPhoneNum setObject:phoneNum forKey:lable];
                }
                
                [lable release];
                [phone release];
            }
            CFRelease(phones);
        }
	}
	
	return retEntity;    
}

//从系统通讯录对应的实体ABContact转换为 HLL联系人
//+(SysPersonEntity * )getOutlookContactEntityFromABContact : (ABContact *)abContact
//{
//	SysPersonEntity * retEntity = nil;
//	if (nil!=abContact) 
//	{
//		retEntity = [[[SysPersonEntity alloc] init] autorelease];
//		
//		retEntity.ID = [NSString stringWithFormat:@"%d",abContact.recordID];
//		retEntity.firstName= [abContact firstname];
//		retEntity.lastName= [abContact lastname];	
//		retEntity.haveSysImage= ABPersonHasImageData(abContact.record); 
//
//		//多值
//		//NSArray * mailLables=	[abContact emailLabels];
//		NSArray * mails=		[abContact emailArray];
//		if ([mails count]>0)
//			retEntity.email=	[mails objectAtIndex:0];
//		
//		NSArray * phoneLabels = [abContact phoneLabels];
//		NSArray * phoneArrays = [abContact phoneArray];
//		for(int i=0; i<[phoneArrays count]; i++)
//		{
//			NSString * tmpLabel = [phoneLabels objectAtIndex:i];
//			NSString * tmpOrigin = [phoneArrays objectAtIndex:i];
//			
//			//tank:2011.2.25剔除电话号码中的多余字符  － （）等
//			NSArray		*arr= [tmpOrigin componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()- "]];
//			NSString	*tmpNumber= [arr componentsJoinedByString:@""];
//			
//			if ([tmpLabel isEqualToString:(NSString*)kABPersonPhoneMobileLabel]) 
//			{
//				retEntity.phoneNum = tmpNumber;
//			}
//			if (retEntity.dictPhoneNum==nil) 
//				retEntity.dictPhoneNum=	[NSMutableDictionary dictionaryWithCapacity:[phoneArrays count]];
//
//			[retEntity.dictPhoneNum setObject:tmpNumber forKey:tmpLabel];
//
//		}
//	}
//	
//	return retEntity;
//}

@end
