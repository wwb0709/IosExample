//
//  SysAddrBookManager.m
//  Example
//
//  Created by wangwb on 13-1-9.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import "SysAddrBookManager.h"
static      ABAddressBookRef            s_addressBook=          nil;
@implementation SysAddrBookManager
#pragma mark -
#pragma mark addrBookCall

void MyabChangeCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    if(addressBook)
    {
        ABAddressBookRevert(addressBook);
        
    //        CommonResource* common= [CommonResource sharedCommonResource];
    //        [common addressChangeCallback];
    }
}
+(ABAddressBookRef)         getSingleAddressBook
{
    @synchronized(self)
    {
        if (nil==s_addressBook)
        {
            s_addressBook=  ABAddressBookCreate();
            if(s_addressBook)
                ABAddressBookRegisterExternalChangeCallback(s_addressBook, MyabChangeCallback, nil);
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
            ABAddressBookUnregisterExternalChangeCallback(s_addressBook, MyabChangeCallback, nil);
            CFRelease(s_addressBook);
            s_addressBook=              nil;
        }
    }
}

//==========================删除所有联系人记录
+(BOOL)						RemoveAllRecord
{
	CFErrorRef		error;
	BOOL			isRemove= NO;
	ABAddressBookRef addrBook= [SysAddrBookManager getSingleAddressBook];
    
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
        ABAddressBookRef addrBook= [SysAddrBookManager getSingleAddressBook];
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

+(void)loadFromAddrBook:(NSMutableArray*)arr
{
    
	ABAddressBookRef		addrBook= [SysAddrBookManager getSingleAddressBook];
    @synchronized(self)
    {
        NSArray* arrRecord= (NSArray*)ABAddressBookCopyArrayOfAllPeople(addrBook);
        
        if (arr && arrRecord && [arrRecord count]>0)
        {
            ABRecordRef	 record;
            NSEnumerator *enumtator= [arrRecord objectEnumerator];
            
            while (record= [enumtator nextObject])
            {
                //                NSAutoreleasePool *poolWhile= [[NSAutoreleasePool alloc] init];
                ABRecordID	idRecord= ABRecordGetRecordID(record);
                VcardPersonEntity * entity= [[VcardPersonEntity alloc] init];
                
                
                entity.ID= [NSString stringWithFormat:@"%d", idRecord];
                NSString *tmp =(NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
                if ([tmp length]>0) {
                    [entity.NameArr setValue:tmp forKey:@"0"];
                    NSLog(@"firstname value:%@",tmp);
                }
                tmp =(NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
                if ([tmp length]>0) {
                    [entity.NameArr setValue:tmp forKey:@"1"];
                    NSLog(@"lastname value:%@",tmp);
                }
                
                
                
                
                {
                    ABMultiValueRef mails=	ABRecordCopyValue(record, kABPersonEmailProperty);
                    NSInteger		count1=	ABMultiValueGetCount(mails);
                    if (mails && count1>0)
                    {
                        
                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(mails);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            NSString*	lable= (NSString*)ABMultiValueCopyLabelAtIndex(mails, nIndex);
                            NSString*	email= (NSString*)ABMultiValueCopyValueAtIndex(mails, nIndex);
                            if (lable && email)
                            {
                                [entity.EmailArr setValue:[NSString stringWithFormat:@"%@;%@",lable,email] forKey:[NSString stringWithFormat:@"%ld",nIndex]];
                                NSLog(@"EmailArr value:%@",[NSString stringWithFormat:@"%@;%@",lable,email]);
                                
                            }
                            
                            [lable release];
                            [email release];
                        }
                        
                        
                    }
                    CFRelease(mails);
                    
                    
                    
                    ABMultiValueRef phones= ABRecordCopyValue(record, kABPersonPhoneProperty);
                    
                    count1= ABMultiValueGetCount(phones);
                    if (phones && count1>0)
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
                                
                                
                                [entity.PhoneArr setValue:[NSString stringWithFormat:@"%@;%@",lable,phoneNum] forKey:[NSString stringWithFormat:@"%ld",nIndex]];
                                
                                NSLog(@"PhoneArr value:%@",[NSString stringWithFormat:@"%@;%@",lable,phoneNum]);
                                
                                
                            }
                            
                            [lable release];
                            [phone release];
                        }
                    }
                    CFRelease(phones);
                    
                    //helei 2011-4-25
                    //读网页
                    ABMultiValueRef  urls= ABRecordCopyValue(record, kABPersonURLProperty);
                    
                    count1= ABMultiValueGetCount(urls);
                    if (urls && count1>0)
                    {
                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(urls);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            NSString*	lable= (NSString*)ABMultiValueCopyLabelAtIndex(urls, nIndex);
                            NSString*	url= (NSString*)ABMultiValueCopyValueAtIndex(urls, nIndex);
                            if (lable && url)
                            {
                                [entity.URLArr setValue:[NSString stringWithFormat:@"%@;%@",lable,url] forKey:[NSString stringWithFormat:@"%ld",nIndex]];
                                NSLog(@"URLArr value:%@",[NSString stringWithFormat:@"%@;%@",lable,url]);
                                
                            }
                            
                            [lable release];
                            [url release];
                        }
                    }
                    CFRelease(urls);
                    //读地址
                    ABMultiValueRef address= ABRecordCopyValue(record, kABPersonAddressProperty);
                    
                    count1= ABMultiValueGetCount(address);
                    if (address && count1>0)
                    {
                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(address);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            NSMutableString *adstr =[NSMutableString stringWithCapacity:5];
                            //获取地址Label
                            NSString* lable = (NSString*)ABMultiValueCopyLabelAtIndex(address, nIndex);
                            
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
                            
                            
                            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
                            
                            if(country != nil)
                            {
                                [adstr appendString:country];
                                //                                [adstr appendString:@"@@"];
                            }
                            else
                            {
                                [adstr appendString:@""];
                                //                                [adstr appendString:@"@@"];
                            }
                            
                            if (lable && adstr)
                            {
                                [entity.AddrArr setValue:[NSString stringWithFormat:@"%@;%@",lable,adstr] forKey:[NSString stringWithFormat:@"%ld",nIndex]];
                                NSLog(@"AddrArr value:%@",[NSString stringWithFormat:@"%@;%@",lable,adstr]);
                                
                            }
                        }
                    }
                    CFRelease(address);
                    
                    
                    //im
                    
                    ABMultiValueRef InstantMessage= ABRecordCopyValue(record, kABPersonInstantMessageProperty);
                    
                    count1= ABMultiValueGetCount(InstantMessage);
                    if (InstantMessage && count1>0)
                    {
                        CFIndex	nIndex;
                        CFIndex	nCount=	ABMultiValueGetCount(InstantMessage);
                        for (nIndex=0; nIndex<nCount; ++nIndex)
                        {
                            
                            
                            NSDictionary* personInstantMessage =(NSDictionary*) ABMultiValueCopyValueAtIndex(InstantMessage, nIndex);
                            
                            //NSLog(@"id:%d",ABMultiValueGetIdentifierAtIndex(InstantMessage, nIndex));
                            
                            NSString* lable = (NSString*)ABMultiValueCopyLabelAtIndex(InstantMessage, nIndex);
                            
                            NSArray * keys = [personInstantMessage allKeys];
                            if (2<=[keys count])
                            {
                                
                                NSMutableString * str = [NSMutableString stringWithCapacity:50];
                                [str appendString:[personInstantMessage valueForKey:[keys objectAtIndex:1]]];
                                [str appendString:@"("];
                                [str appendString:[personInstantMessage valueForKey:[keys objectAtIndex:0]]];
                                [str appendString:@")"];
                                
                                
                                
                                [entity.AIMArr setValue:[NSString stringWithFormat:@"%@;%@",lable,str] forKey:[NSString stringWithFormat:@"%ld",nIndex]];
                                NSLog(@"im value:%@",[NSString stringWithFormat:@"%@;%@",lable,str]);
                                
                            }
                            
                            
                            
                        }
                        
                    }
                    CFRelease(InstantMessage);
                    
                    
                    
                    
                    
                    [arr addObject:entity];
                }
                
                
                
                [entity release];
                
                //                [poolWhile release];
            }
        }
    }
	
	
}
@end
