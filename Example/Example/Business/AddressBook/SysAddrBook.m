//
//  SysAddrBook.m
//  HaoLianLuo
//
//  Created by memac memac on 10-9-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SysAddrBook.h"
#import "SysPersonEntity.h"


static      ABAddressBookRef            s_addressBook=          nil;

@implementation SysAddrBook


#pragma mark -
#pragma mark addrBookCall

void abChangeCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    if(addressBook)
    {
        ABAddressBookRevert(addressBook);
        
//        CommonResource* common= [CommonResource sharedCommonResource];
//        [common addressChangeCallback];
    }
}


#pragma mark -
#pragma addressOp

+(ABAddressBookRef)         getSingleAddressBook
{
    @synchronized(self)
    {
        if (nil==s_addressBook)
        {
            s_addressBook=  ABAddressBookCreate();
            if(s_addressBook)
                ABAddressBookRegisterExternalChangeCallback(s_addressBook, abChangeCallback, nil);
        }
    }
    
    return s_addressBook;
}
+(void)                     destroySingleAddressBook
{
    @synchronized(self)
    {
        if (nil!=s_addressBook)
        {
            ABAddressBookUnregisterExternalChangeCallback(s_addressBook, abChangeCallback, nil);
            CFRelease(s_addressBook);
            s_addressBook=              nil;
        }
    }
}

+(BOOL)     setPhoneDictionary:(NSDictionary*) dict toRecordRef:(ABRecordRef) record;
{
    bool retVal=    false;
    
	ABMutableMultiValueRef  multiPhone= ABMultiValueCreateMutable(kABStringPropertyType);
	//===加入多值的电话号码
	if (dict && [dict count]>0)
	{
		NSArray* arrKey= [dict allKeys];
		if (arrKey)
		{	
			NSString*		val;
			NSString*		key;
			NSEnumerator*	rator= [arrKey objectEnumerator];
			while (key= [rator nextObject])
			{
                val=	[dict objectForKey:key];
                if(val)
                    ABMultiValueAddValueAndLabel(multiPhone, val, (CFStringRef)key, NULL);
			}
		}
	}
    
    CFErrorRef  error;
	if ( ABMultiValueGetCount(multiPhone)>0 )
		retVal= ABRecordSetValue(record, kABPersonPhoneProperty, multiPhone, &error);
    
	CFRelease(multiPhone);   
    
    return (false==retVal ? NO:YES);
}


//==========================删除所有联系人记录
+(BOOL)						RemoveAllRecord
{
	CFErrorRef		error;
	BOOL			isRemove= NO;
	ABAddressBookRef addrBook= [SysAddrBook getSingleAddressBook];
    
	NSArray* arrRecord= (NSArray*)ABAddressBookCopyArrayOfAllPeople(addrBook);
	
	if (arrRecord && [arrRecord count]>0) 
	{
		ABRecordRef	 recordRef;
		NSEnumerator *enumtator= [arrRecord objectEnumerator];
		
		while (recordRef= [enumtator nextObject])
			ABAddressBookRemoveRecord(addrBook, recordRef,  &error);
		
		isRemove= YES;
	}
	ABAddressBookSave(addrBook, &error);
	
	return isRemove;	
}

//======================删除指定ID的联系人记录
+(BOOL)					RemoveRecord:(ABRecordID) _id
{
    BOOL			 isRemove= NO;
    
    @synchronized(self)
    {
        ABAddressBookRef addrBook= [SysAddrBook getSingleAddressBook];
        ABRecordRef		 recordRef= ABAddressBookGetPersonWithRecordID(addrBook, _id);
        
        if (recordRef) 
        {
            CFErrorRef error;
            isRemove= ABAddressBookRemoveRecord(addrBook, recordRef,  &error);
            ABAddressBookSave(addrBook, &error);
        }
    }
	
	return isRemove;
}

//==========================设置指定ID的联系人头像
+(BOOL)						SetRecordImage:(UIImage*) _image
                   recordID:(ABRecordID) _id
{
	BOOL ret= NO;
	ABAddressBookRef	addrBook=  [SysAddrBook getSingleAddressBook];
	ABRecordRef			recordRef= ABAddressBookGetPersonWithRecordID(addrBook, _id);
	if (recordRef)
	{
		CFErrorRef	error;
        //		ABContact	*contact=	[ABContact contactWithRecord:recordRef];
        //		[contact setImage:_image];
        ret=    ([self setImage:_image recordRef:recordRef]==false ? NO:YES);
		
		ABAddressBookSave(addrBook, &error);
		
		ret= YES;
	}
	
	return ret;
}

//==========================取指定ID的联系人头像
+(UIImage*)					GetRecordImage:(ABRecordID) _id
{
	UIImage				*image=	nil;
	ABAddressBookRef	addrBook=  [SysAddrBook getSingleAddressBook];
	ABRecordRef			recordRef= ABAddressBookGetPersonWithRecordID(addrBook, _id);
	if (recordRef)
	{
		if (!ABPersonHasImageData(recordRef)) 
			return nil;
		CFDataRef imageData = ABPersonCopyImageData(recordRef);
		image = [[[UIImage alloc]initWithData:(NSData *)imageData] autorelease];
		CFRelease(imageData);
	}

	return image;
}




//==========================返回对应id的ABRecordRef
+(ABRecordRef)              RecordRefFromRecordID:(ABRecordID) _id
{
	ABAddressBookRef		addrBook=  [SysAddrBook getSingleAddressBook];
	ABRecordRef				recordRef= ABAddressBookGetPersonWithRecordID(addrBook, _id);
    
    return                  recordRef;
}
//==========================返回对应group id的ABRecordRef
+(ABRecordRef)              GroupRecordRefFromRecordID:(ABRecordID) _id
{
	ABAddressBookRef		addrBook=  [SysAddrBook getSingleAddressBook];
	ABRecordRef				recordRef= ABAddressBookGetGroupWithRecordID(addrBook, _id);
    
    return                  recordRef;
}


//==========================取联系人个数
+(NSInteger)				GetRecordCount
{
	ABAddressBookRef		addrBook= [SysAddrBook getSingleAddressBook];	
	NSInteger				count= ABAddressBookGetPersonCount(addrBook);
	
	return count;	
}


//==========================取所有联系人信息
+(NSInteger)				GetAllRecord:(NSMutableDictionary*) _dictionary
{
    NSInteger				count= 0;
	ABAddressBookRef		addrBook= [SysAddrBook getSingleAddressBook];
    @synchronized(self)
    {
        NSArray* arrRecord= (NSArray*)ABAddressBookCopyArrayOfAllPeople(addrBook);
        
        if (_dictionary && arrRecord && [arrRecord count]>0) 
        {
            ABRecordRef	 record;
            NSEnumerator *enumtator= [arrRecord objectEnumerator];
            
            while (record= [enumtator nextObject]) 
            {
                 NSAutoreleasePool *poolWhile= [[NSAutoreleasePool alloc] init];
                ABRecordID	idRecord= ABRecordGetRecordID(record);
                SysPersonEntity * entity= [[SysPersonEntity alloc] init];
                
                
                entity.ID= [NSString stringWithFormat:@"%d", idRecord];
                entity.firstName= (NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
                entity.lastName= (NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
                entity.haveSysImage= ABPersonHasImageData(record);
                //=====================读取系统头像
                //			if(ABPersonHasImageData(record))
                //				entity.sysImage= [UIImage imageWithData:(NSData*)ABPersonCopyImageData(record)];
                
                //if (entity.firstName || entity.lastName) 
                {
                    ABMultiValueRef mails=	ABRecordCopyValue(record, kABPersonEmailProperty);
                    NSInteger		count=	ABMultiValueGetCount(mails);
                    if (mails && count>0)
                    {
                        NSString* mail= (NSString*)ABMultiValueCopyValueAtIndex(mails, 0);
                        entity.email=	mail;
                        [mail release];
                    }
                    CFRelease(mails);
                    
                    
                    ABMultiValueRef phones= ABRecordCopyValue(record, kABPersonPhoneProperty);
                    
                    count= ABMultiValueGetCount(phones);
                    if (phones && count>0) 
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
                                NSString *lTmp = [NSString stringWithFormat:@"%s"," "];
                                phoneNum=[phoneNum stringByReplacingOccurrencesOfString:lTmp withString:@""]; 
                                
                                //=========是手机号码
                                if ([lable isEqualToString:(NSString*)kABPersonPhoneMobileLabel])
                                    entity.phoneNum= [NSString stringWithString: phoneNum];
                                
                                if (entity.dictPhoneNum==nil) 
                                    entity.dictPhoneNum= [NSMutableDictionary dictionaryWithCapacity:nCount];
                                
                                NSString *tmpPhoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
                                if (tmpPhoneNum.length>0) 
                                {
                                    NSString *tmpLabel = [NSString stringWithFormat:@"%@%@%d",lable,@"&&",nIndex];
                                    [entity.dictPhoneNum setObject:phoneNum forKey:tmpLabel];
                                }
                                
                            }
                            
                            [lable release];
                            [phone release];
                        }
                    }
                    CFRelease(phones);
                    
                    //helei 2011-4-25
                    //读网页
                    ABMultiValueRef  urls= ABRecordCopyValue(record, kABPersonURLProperty);
                    
                    count= ABMultiValueGetCount(urls);
                    if (urls && count>0) 
                    {
                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(urls);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            entity.web= (NSString*)ABMultiValueCopyValueAtIndex(urls, nIndex);
                            ////NSLog(entity.web);
                            break;  
                        }
                    }
                    CFRelease(urls);
                    //读地址
                    ABMultiValueRef address= ABRecordCopyValue(record, kABPersonAddressProperty);
                    
                    count= ABMultiValueGetCount(address);
                    if (address && count>0) 
                    {
                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(address);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            NSMutableString *adstr =[NSMutableString stringWithCapacity:5];
                            //获取地址Label
                            //NSString* addressLabel = (NSString*)ABMultiValueCopyLabelAtIndex(address, j);
                            //textView.text = [textView.text stringByAppendingFormat:@"%@\n",addressLabel];
                            //获取該label下的地址6属性
                            NSDictionary* personaddress =(NSDictionary*) ABMultiValueCopyValueAtIndex(address, nIndex);        
                            
                            
                            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
                            if(street != nil)
                            {
                                [adstr appendString:street];
                                [adstr appendString:@"@@"];
                            }
                            else
                            {
                                [adstr appendString:@""];
                                [adstr appendString:@"@@"];
                            }
                            
                            
                            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
                            if(state != nil)
                            {
                                [adstr appendString:state];
                                [adstr appendString:@"@@"];
                            }
                            else
                            {
                                [adstr appendString:@""];
                                [adstr appendString:@"@@"];
                            }
                            
                            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
                            if(city != nil)
                            {
                                [adstr appendString:city];
                                [adstr appendString:@"@@"];
                            }
                            else
                            {
                                [adstr appendString:@""];
                                [adstr appendString:@"@@"];
                            }
                            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
                            
                            if(country != nil)
                            {
                                [adstr appendString:country];
                                [adstr appendString:@"@@"];
                            }
                            else
                            {
                                [adstr appendString:@""];
                                [adstr appendString:@"@@"];
                            }
                            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
                            if(zip != nil)
                            {
                                [adstr appendString:zip];
                                [adstr appendString:@"@@"];
                            }
                            else
                            {
                                [adstr appendString:@""];
                                [adstr appendString:@"@@"];
                            }
                            entity.address = adstr;
                            break;
                        }
                    }
                    CFRelease(address);
                    
                    
                    //im
                    
                    ABMultiValueRef InstantMessage= ABRecordCopyValue(record, kABPersonInstantMessageProperty);
                    
                    count= ABMultiValueGetCount(InstantMessage);
                    if (InstantMessage && count>0) 
                    {
                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(InstantMessage);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            
            
                                NSDictionary* personInstantMessage =(NSDictionary*) ABMultiValueCopyValueAtIndex(InstantMessage, nIndex); 
                                
                                //NSLog(@"id:%d",ABMultiValueGetIdentifierAtIndex(InstantMessage, nIndex));
                                
                                NSArray * keys = [personInstantMessage allKeys];
                                if (2<=[keys count])
                                {

                                        NSMutableString * str = [NSMutableString stringWithCapacity:50];
                                        [str appendString:[personInstantMessage valueForKey:[keys objectAtIndex:1]]];

                                        entity.im = str;
                                   
                                        
                                        //NSLog(@"im value:%@",str);

                                }
                            
                         
                            
                        }
                        
                    }
                    CFRelease(InstantMessage);
                    
                    
                    
                    
                    //helei end
                    [_dictionary setObject:entity forKey:[NSString stringWithFormat:@"%d", idRecord]];
                }
                
                
                
                [entity release];
                
                ++count;
                [poolWhile release];
            }
        }
    }
	
	return count;
}

#pragma mark --
#pragma mark 记录存取相关

+(BOOL)     addRecordWithRef:(ABRecordRef) recordRef withError:(NSError **) error
{
	if (!ABAddressBookAddRecord([SysAddrBook getSingleAddressBook], recordRef, (CFErrorRef *) error))
        return NO;
    
	return ABAddressBookSave([SysAddrBook getSingleAddressBook], (CFErrorRef *) error);    
}


#pragma mark Images
+(UIImage *) imageWithRecordRef:(ABRecordRef) record
{
	if (!ABPersonHasImageData(record)) 
        return nil;
    
	CFDataRef imageData = ABPersonCopyImageData(record);
	UIImage *image = [UIImage imageWithData:(NSData *) imageData];
	CFRelease(imageData);
    
	return image;
}

+(bool)    setImage: (UIImage *)      image
           recordRef: (ABRecordRef)    record
{
	CFErrorRef  error;
	bool        success=   false;
	
	if (image == nil)
	{
		if (!ABPersonHasImageData(record)) 
            success=    true;
        else 
            success = ABPersonRemoveImageData(record, &error);
	}
    else
    {
        NSData *data = UIImagePNGRepresentation(image);
        success = ABPersonSetImageData(record, (CFDataRef) data, &error);
    }
    
    return success;
}


@end







