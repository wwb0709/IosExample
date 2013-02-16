//
//  SysAddrBookManager.m
//  Example
//
//  Created by wangwb on 13-1-9.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import "SysAddrBookManager.h"
#import "DAUtility.h"
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
            s_addressBook=  [self MyAddressBookCreate];
            if(s_addressBook)
                ABAddressBookRegisterExternalChangeCallback(s_addressBook, MyabChangeCallback, nil);
        }
    }
    
    return s_addressBook;
}
+(ABAddressBookRef) MyAddressBookCreate
{
    ABAddressBookRef addressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else
    {
        addressBook = ABAddressBookCreate();
    }
    
    return addressBook;
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

+(void)loadFromAddrBook:(NSMutableDictionary*)arr
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
                else
                {
                    [entity.NameArr setValue:@"" forKey:@"0"];
                }
                tmp =(NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
                if ([tmp length]>0) {
                    [entity.NameArr setValue:tmp forKey:@"1"];
                    NSLog(@"lastname value:%@",tmp);
                }
                else
                {
                    [entity.NameArr setValue:@"" forKey:@"1"];
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
                    
                    
                    
                    
                    
//                    [arr addObject:entity];
                    [arr setValue:entity forKey:entity.ID];
                }
                
                
                
                [entity release];
                
                //                [poolWhile release];
            }
        }
    }
	
	
}

+(void)createVcard
{
    //BEGIN:VCARD
    //VERSION:2.1
    //PRODID:-//Apple Inc.//Mac OS X 10.8.2//EN
    //N:xs;mz;zjm;cw;qtcw
    //FN:cw mz zjm xs qtcw
    //NICKNAME:nc
    //    X-MAIDENNAME:xs
    //    X-PHONETIC-MIDDLE-NAME:zjmjp
    //    X-PHONETIC-LAST-NAME:xsjp
    //ORG:gs;bm
    //TITLE:zw
    //    EMAIL;INTERNET;HOME;pref:wwb113@qq.com
    //    EMAIL;INTERNET;WORK:wwb112@qq.com
    //    EMAIL;INTERNET:wwb113@qq.com
    //    TEL;CELL;VOICE;pref:15810330913
    //    TEL;IPHONE;CELL;VOICE:15810330914
    //    TEL;HOME;VOICE:11111
    //    TEL;WORK;VOICE:11444
    //    TEL;MAIN:113444
    //    TEL;HOME;FAX:22222
    //    TEL;WORK;FAX:2224344
    //    TEL;OTHER;FAX:22434
    //    TEL;PAGER:22222
    //TEL:222
    //    TEL;OTHER;VOICE:333
    //    ADR;HOME;pref;CHARSET=UTF-8:;;东三环;北京;北京;100000;中国
    //    X-SOCIALPROFILE;twitter:http://twitter.com/222
    //    X-SOCIALPROFILE;facebook:http://facebook.com/222
    //    X-SOCIALPROFILE;flickr:http://www.flickr.com/photos/333
    //    X-SOCIALPROFILE;linkedin:http://www.linkedin.com/in/333
    //    X-SOCIALPROFILE;myspace:http://www.myspace.com/333
    //    X-SOCIALPROFILE;sinaweibo:http://weibo.com/n/333
    //    NOTE;CHARSET=UTF-8:生生世世是
    //    URL;pref:http://www.222.com
    //    URL;HOME:http://www.222.com
    //    URL;WORK:http://www.222.com
    //URL:http://www.222.com
    //BDAY:1982-07-09
    //    X-AIM;HOME;pref:111
    //    X-AIM;WORK:1122
    //    X-AIM:2233
    //    IMPP;AIM;HOME;pref:aim:111
    //    IMPP;AIM;WORK:aim:1122
    //    IMPP;AIM:aim:2233
    //UID:39396744-dfb1-47c7-b5d8-a736f066f57d
    //    X-ABUID:39396744-DFB1-47C7-B5D8-A736F066F57D:ABPerson
    //END:VCARD
    
    NSMutableArray * vcf = [NSMutableArray array];
    //    [vcf addObject:@"BEGIN:VCARD"];
    //    [vcf addObject:@"VERSION:2.1"];
    //    [vcf addObject:@"PRODID:-//Apple Inc.//Mac OS X 10.8.2//EN"];
    //    [vcf addObject:@"N:xs;mz2;zjm;cw;qtcw"];
    //    [vcf addObject:@"FN:cw mz zjm xs qtcw"];
    //    [vcf addObject:@"NICKNAME:nc"];
    //    [vcf addObject:@"EMAIL;INTERNET:wwb113@qq.com"];
    //    [vcf addObject:@"TEL;HOME;VOICE:11111"];
    //    [vcf addObject:@"ADR;HOME;pref;CHARSET=UTF-8:;;东三环;北京;北京;100000;中国"];
    //    [vcf addObject:@"URL;WORK:http://www.222.com"];
    //    [vcf addObject:@"END:VCARD"];
    
    
    
  
    NSMutableDictionary* entityDic = [NSMutableDictionary dictionary];
    [self loadFromAddrBook:entityDic];
    NSArray * entityArr = [entityDic allKeys];
    for (int i=0; i<[entityArr count]; i++) {
        VcardPersonEntity * entity= [entityDic valueForKey:[entityArr objectAtIndex:i]];
        //一个vcard
        [vcf addObject:@"BEGIN:VCARD"];
        [vcf addObject:@"VERSION:2.1"];
        [vcf addObject:@"PRODID:-//Apple Inc.//Mac OS X 10.8.2//EN"];
        NSMutableArray * nameArr = [NSMutableArray array];
        for (int i=0; i<[[entity.NameArr allKeys] count]; i++) {
            [nameArr addObject:[entity.NameArr objectForKey:[NSString stringWithFormat:@"%d",i]]];
        }
        
        [vcf addObject:[NSString stringWithFormat:@"N:%@",[nameArr componentsJoinedByString:@";"]]];
        [vcf addObject:@"FN:cw mz zjm xs qtcw"];
        [vcf addObject:@"NICKNAME:nc"];
        
        
        for (int i=0; i<[[entity.PhoneArr allKeys] count]; i++) {
            NSMutableArray * phoneArr = [NSMutableArray array];
            [phoneArr addObject:@"TEL;IPHONE;CELL;VOICE"];
            
            NSString *phoneV = [entity.PhoneArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            [phoneArr addObject:[[phoneV componentsSeparatedByString:@";"] lastObject]];
            
            [vcf addObject:[phoneArr componentsJoinedByString:@":"]];
        }
        
        for (int i=0; i<[[entity.EmailArr allKeys] count]; i++) {
            NSMutableArray * emailArr = [NSMutableArray array];
            [emailArr addObject:@"EMAIL;INTERNET;WORK"];
            
            NSString *emailV = [entity.EmailArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            [emailArr addObject:[[emailV componentsSeparatedByString:@";"] lastObject]];
            
            [vcf addObject:[emailArr componentsJoinedByString:@":"]];
        }
        
        for (int i=0; i<[[entity.URLArr allKeys] count]; i++) {
            NSMutableArray * urlArr = [NSMutableArray array];
            [urlArr addObject:@"URL;pref"];
            
            NSString *urlV = [entity.URLArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            [urlArr addObject:[[urlV componentsSeparatedByString:@";"] lastObject]];
            
            [vcf addObject:[urlArr componentsJoinedByString:@":"]];
        }
        
        for (int i=0; i<[[entity.AddrArr allKeys] count]; i++) {
            //;;东三环;北京;北京;100000;中国
            NSMutableArray * addrArr = [NSMutableArray array];
            [addrArr addObject:@"ADR;HOME;pref;CHARSET=UTF-8"];
            
            NSString *adrV = [entity.AddrArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            [addrArr addObject:[[[[adrV componentsSeparatedByString:@";"] lastObject] componentsSeparatedByString:@"@@"] componentsJoinedByString:@";"]];
            
            [vcf addObject:[addrArr componentsJoinedByString:@":"]];
        }
        
        
        [vcf addObject:@"END:VCARD"];
    }
    
    NSString* vcfStr = [vcf componentsJoinedByString:@"\r\n"];
    NSLog(@"vcfStr:%@",vcfStr);
    
    
    //创建文件管理器
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    
    //获取document路径,括号中属性为当前应用程序独享
    
//    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,      NSUserDomainMask, YES);
//    
//    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    
    
    
    //定义记录文件全名以及路径的字符串filePath
    
    NSString *filePath =[DAUtility GetVcfNameFromCurremtDate];//[documentDirectory stringByAppendingPathComponent:@"contact.vcf"];
    
    
    
    //查找文件，如果不存在，就创建一个文件
    
    if (![fileManager fileExistsAtPath:filePath]) {
        printLog(@"%@",filePath);
        [vcfStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        //        [fileManager createFileAtPath:filePath contents:[[NSData alloc] in] attributes:nil];
        
    }
    
}

+(void)recoverAddressBookFormVcard:(NSString *)filePath
{
    NSString	*vpath=filePath;//[[NSBundle mainBundle] pathForResource:@"testvcard.vcf" ofType:nil];
    //   [self paraseVcard:vpath];
    //   [self createVcard];
    NSMutableArray * arr = [NSMutableArray array];
    //    [self loadFromAddrBook:arr];
    [self paraseVcard:vpath :arr];
    [self saveToAddrBook:arr];

}
+(void)paraseVcard:(NSString*)filepath :(NSMutableArray *)vcardArr
{
    NSFileManager	*fileManager=	[NSFileManager defaultManager];
    BOOL			isExist=		[fileManager fileExistsAtPath:filepath];
    NSString *vcf = nil;
    NSArray  * arr;
    if (isExist) {
        NSError * error= nil;
        vcf = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"astring:%@",vcf);
        arr = [vcf componentsSeparatedByString:@"\r\n"];
    }
    //     NSMutableArray * vcardArr = [NSMutableArray array];
    VcardPersonEntity * vcardEntity = nil;
    for (int i=0; i<[arr count]; i++) {
        
        NSString *str = (NSString*)[arr objectAtIndex:i];
        NSLog(@"****line:%d str:%@",i,str);
        if ([str isEqualToString:@"BEGIN:VCARD"]) {
            vcardEntity = [[VcardPersonEntity alloc] init];
        }
        if (vcardEntity) {
            
            //N:xs;mz;zjm;cw;qtcw
            NSArray *namearr = [str componentsSeparatedByString:@":"];
            if ([str hasPrefix:@"N:"])
            {
                NSString *name = (NSString *)[namearr lastObject];
                NSArray *namesArr = [name componentsSeparatedByString:@";"];
                for (int i=0; i<[namesArr count]; i++) {
                    [vcardEntity.NameArr setValue:[namesArr objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d", i]];
                }
                
                NSLog(@"****NAME:%@",name);
                
            }
            NSArray *Adrarr = [str componentsSeparatedByString:@":"];
            if ([str hasPrefix:@"ADR"])
            {
                NSString *adr = (NSString *)[Adrarr lastObject];
                NSArray *adrsArr = [adr componentsSeparatedByString:@";"];
                
                NSString *adrV = [NSString stringWithFormat:@"%@;%@",[self getAdrBookType:str],[adrsArr componentsJoinedByString:@"@@"]];
                [vcardEntity.NameArr setValue:adrV forKey:[NSString stringWithFormat:@"%d", [vcardEntity.NameArr count]]];
                
                
                NSLog(@"****ADR:%@",adr);
                
                
                
            }
            
            
            
            NSArray *arr = [str componentsSeparatedByString:@";"];
            
            if ([arr count]>0) {
                
                
                
                if ([str hasPrefix:@"TEL"])
                {
                    NSString *phone = (NSString *)[arr objectAtIndex:[arr count]-1];
                    NSArray *phonesArr = [phone componentsSeparatedByString:@":"];
                    if ([phonesArr count]>0) {
                        NSString *phoneV = [NSString stringWithFormat:@"%@;%@",[self getAdrBookType:str],[phonesArr objectAtIndex:1]];
                        [vcardEntity.PhoneArr setValue:phoneV forKey:[NSString stringWithFormat:@"%d", [vcardEntity.PhoneArr count]]];
                        NSLog(@"****TEL:%@",[phonesArr objectAtIndex:1]);
                    }
                    
                }
                
                
                if ([str hasPrefix:@"URL"])
                {
                    NSString *url = (NSString *)[arr objectAtIndex:[arr count]-1];
                    NSArray *urlsArr = [url componentsSeparatedByString:@":"];
                    if ([urlsArr count]>0) {
                        [vcardEntity.URLArr setValue:[urlsArr objectAtIndex:1] forKey:[NSString stringWithFormat:@"%d", [vcardEntity.URLArr count]]];
                        NSLog(@"****URL:%@",url);
                    }
                    
                }
                if ([str hasPrefix:@"X-AIM"])
                {
                    NSString *aim = (NSString *)[arr objectAtIndex:[arr count]-1];
                    NSArray *aimArr = [aim componentsSeparatedByString:@":"];
                    if ([aimArr count]>0) {
                        [vcardEntity.AIMArr setValue:[aimArr objectAtIndex:1] forKey:[NSString stringWithFormat:@"%d", [vcardEntity.AIMArr count]]];
                        NSLog(@"****AIM:%@",[aimArr objectAtIndex:1]);
                    }
                    
                }
                if ([str hasPrefix:@"X-SOCIALPROFILE"])
                {
                    NSString *social = (NSString *)[arr objectAtIndex:[arr count]-1];
                    NSArray *socialArr = [social componentsSeparatedByString:@":"];
                    if ([socialArr count]>0) {
                        
                        
                        [vcardEntity.SocialArr setValue:[socialArr objectAtIndex:1] forKey:[NSString stringWithFormat:@"%d", [vcardEntity.SocialArr count]]];
                        NSLog(@"****SOCIAL:%@",social);
                    }
                    
                }
                
                if ([str hasPrefix:@"EMAIL"])
                {
                    NSString *email = (NSString *)[arr objectAtIndex:[arr count]-1];
                    NSArray *emailsArr = [email componentsSeparatedByString:@":"];
                    if ([emailsArr count]>0) {
                        
                        [vcardEntity.EmailArr setValue:[emailsArr objectAtIndex:1] forKey:[NSString stringWithFormat:@"%d", [vcardEntity.EmailArr count]]];
                        NSLog(@"****EMAIL:%@",[emailsArr objectAtIndex:1]);
                    }
                    
                }
                
                
                
            }
            
        }
        
        if ([str isEqualToString:@"END:VCARD"]) {
            if (vcardEntity) {
                [vcardArr addObject:vcardEntity];
                [vcardEntity release];
                vcardEntity = nil;
                NSLog(@"****===============");
            }
        }
    }
    
    
    
}

//Mark: ========================本地通讯录 11大类操作
+(void)saveToAddrBook:(NSMutableArray*)arr
{
    
    //添加联系人
    GTMABAddressBook*    book_ = [[GTMABAddressBook addressBook:[SysAddrBook getSingleAddressBook]] retain];
    
    for (int i=0; i<[arr count]; i++) {
        VcardPersonEntity * entity= [arr objectAtIndex:i];
        GTMABPerson * tmpPerson = [GTMABPerson personWithFirstName:[entity.NameArr valueForKey:@"0"] lastName:[entity.NameArr valueForKey:@"1"]];
        [book_ addRecord:tmpPerson];
        
        for (int i=0; i<[[entity.PhoneArr allKeys] count]; i++) {
            
            NSString *phoneV = [entity.PhoneArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            NSArray * phoneVArr = [phoneV componentsSeparatedByString:@";"];
            if ([phoneVArr count]>1) {
                [SysAddrBookManager OperContactNumbersWithKey:(CFStringRef)[phoneVArr objectAtIndex:0] andValue:[phoneVArr objectAtIndex:1] andIndex:1 andOperType:OperationType_add inPerson:tmpPerson];
            }
            
        }
        
        for (int i=0; i<[[entity.AddrArr allKeys] count]; i++) {
            
            NSString *adrV = [entity.AddrArr objectForKey:[NSString stringWithFormat:@"%d",i]];
            NSArray * adrVArr = [adrV componentsSeparatedByString:@";"];
            if ([adrVArr count]>1) {
                
                NSArray * adrDetailVArr = [[adrVArr objectAtIndex:1] componentsSeparatedByString:@"@@"];
                if ([adrDetailVArr count]>4) {
                    
                    //                    一号,
                    //                    河北,
                    //                    石家庄,
                    //                    100022,
                    //                    中国
                    CFStringRef keys[6] = {kABPersonAddressStreetKey,
                        kABPersonAddressCityKey,
                        kABPersonAddressStateKey,
                        kABPersonAddressZIPKey,
                        kABPersonAddressCountryCodeKey,
                        kABPersonAddressCountryKey
                    };
                    CFStringRef values[6] = {(CFStringRef)([adrDetailVArr objectAtIndex:0]),
                        (CFStringRef)([adrDetailVArr objectAtIndex:2]),
                        (CFStringRef)([adrDetailVArr objectAtIndex:1]),
                        (CFStringRef)([adrDetailVArr objectAtIndex:3]),
                        CFSTR("80424"),
                        (CFStringRef)([adrDetailVArr objectAtIndex:4])};
                    CFDictionaryRef data =
                    CFDictionaryCreate(NULL,
                                       (void *)keys,
                                       (void *)values,
                                       6,
                                       &kCFCopyStringDictionaryKeyCallBacks,
                                       &kCFTypeDictionaryValueCallBacks);
                    
                    [SysAddrBookManager OperAddressesWithKey:(CFStringRef)[adrVArr objectAtIndex:0] andValue:(id)data andIndex:1 andOperType:OperationType_add inPerson:tmpPerson];
                    CFRelease(data);
                    
                }
                
            }
            
        }
        
        
        
        //3。相关联系人测试
        [SysAddrBookManager OperRelatedContactsWithKey:kABHomeLabel andValue:@"wwwwwwwww" andIndex:0 andOperType:OperationType_add inPerson:tmpPerson];
        
        [book_ save];
    }
    
    
      
    
    
    
    
    [book_ release];
    
    
    
}

//Mark: ========================本地通讯录 11大类操作 start====================================================
//***************** 1、个人基本信息操作 ******************
+ (void)OperBasicInfoWithProperty : (ABPropertyID)propertyId
                         andValue : (NSString*)value
                      andOperType : (OperationType)opertype
                         inPerson : (GTMABPerson *) tmpPerson
{
    if (value) {
        if (opertype == OperationType_del) {
            [tmpPerson removeValueForProperty:propertyId];
        }
        else if(opertype == OperationType_add||opertype == OperationType_edit)
            [tmpPerson setValue:value forProperty:propertyId];
    }
    
}

//***************** 2、电话号码信息操作 ******************
+ (void)OperContactNumbersWithKey : (CFStringRef)key
                         andValue : (NSString*)value
                         andIndex : (NSUInteger)index
                      andOperType : (OperationType)opertype
                         inPerson : (GTMABPerson *) tmpPerson
{
    ABMultiValueRef phones= ABRecordCopyValue([tmpPerson recordRef], kABPersonPhoneProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:phones ];
    
    if (MultiValue) {
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonPhoneProperty];
    CFRelease(MultiValue);
    CFRelease(phones);
    
}
//***************** 3、相关联系人信息操作 *****************
+ (void)OperRelatedContactsWithKey : (CFStringRef)key
                          andValue : (NSString*) value
                          andIndex : (NSUInteger)index
                       andOperType : (OperationType)opertype
                          inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef RelatedNames= ABRecordCopyValue([tmpPerson recordRef], kABPersonRelatedNamesProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:RelatedNames ];
    
    if (MultiValue) {
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonRelatedNamesProperty];
    CFRelease(MultiValue);
    CFRelease(RelatedNames);
    
}
//***************** 4、住址信息操作 **********************
+ (void)OperAddressesWithKey : (CFStringRef)key
                    andValue :(id) value
                    andIndex : (NSUInteger)index
                 andOperType : (OperationType)opertype
                    inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef addresses= ABRecordCopyValue([tmpPerson recordRef], kABPersonAddressProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:addresses ];
    
    if (MultiValue) {
        
        
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
        
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonAddressProperty];
    
    CFRelease(MultiValue);
    CFRelease(addresses);
    
}

//***************** 5、社交信息操作 **********************
+ (void)OperNetSocialWithKey : (CFStringRef)key
                    andValue : (NSString*) value
                    andIndex : (NSUInteger)index
                 andOperType : (OperationType)opertype
                    inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef SocialProfiles= ABRecordCopyValue([tmpPerson recordRef], kABPersonSocialProfileProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:SocialProfiles ];
    
    if (MultiValue) {
        
        
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
        
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonSocialProfileProperty];
    
    CFRelease(MultiValue);
    CFRelease(SocialProfiles);
    
}
//***************** 6、IM信息操作 ***********************
+ (void)OperIMsWithKey : (CFStringRef)key
              andValue : (NSString*) value
              andIndex : (NSUInteger)index
           andOperType : (OperationType)opertype
              inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef ims= ABRecordCopyValue([tmpPerson recordRef], kABPersonInstantMessageProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:ims ];
    
    if (MultiValue) {
        
        
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
        
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonInstantMessageProperty];
    
    CFRelease(MultiValue);
    CFRelease(ims);
    
    
}

//***************** 7、邮件信息操作 **********************
+ (void)OperEmailsWithKey : (CFStringRef)key
                 andValue : (NSString*) value
                 andIndex : (NSUInteger)index
              andOperType : (OperationType)opertype
                 inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef emails= ABRecordCopyValue([tmpPerson recordRef], kABPersonEmailProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:emails ];
    
    if (MultiValue) {
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonEmailProperty];
    CFRelease(MultiValue);
    CFRelease(emails);
    
}
//***************** 8、url信息操作 **********************
+ (void)OperUrlsWithKey : (CFStringRef)key
               andValue : (NSString*) value
               andIndex : (NSUInteger)index
            andOperType : (OperationType)opertype
               inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef urls= ABRecordCopyValue([tmpPerson recordRef], kABPersonURLProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:urls ];
    
    if (MultiValue) {
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonURLProperty];
    CFRelease(MultiValue);
    CFRelease(urls);
}

//***************** 9、日期信息操作 **********************
+ (void)OperDatesWithKey : (CFStringRef)key
                andValue : (NSDate*) value
                andIndex : (NSUInteger)index
             andOperType : (OperationType)opertype
                inPerson : (GTMABPerson *) tmpPerson
{
    
    ABMultiValueRef dates= ABRecordCopyValue([tmpPerson recordRef], kABPersonDateProperty);
    GTMABMutableMultiValue * MultiValue = [[GTMABMutableMultiValue alloc] initWithMultiValue:dates ];
    
    if (MultiValue) {
        
        if (opertype == OperationType_del)
        {
            [MultiValue removeValueAndLabelAtIndex:index];
        }
        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
        else if(opertype == OperationType_edit)
        {
            [MultiValue replaceValueAtIndex:index withValue:value];
        }
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonDateProperty];
    CFRelease(MultiValue);
    CFRelease(dates);
    
    
}

//***************** 10、备注操作 *********************
+ (void)OperPersonNoteWithOperType : (OperationType)opertype
                          andValue : (NSString*) value
                          inPerson : (GTMABPerson *) tmpPerson
{
    if (value) {
        if (opertype == OperationType_del) {
            [tmpPerson removeValueForProperty:kABPersonNoteProperty];
        }
        else if(opertype == OperationType_add||opertype == OperationType_edit)
            [tmpPerson setValue:value forProperty:kABPersonNoteProperty];
    }
    
    
}

//***************** 11、生日信息操作 *********************
+ (void)OperBirthdayWithOperType : (OperationType)opertype
                        andValue : (NSDate*) value
                        inPerson : (GTMABPerson *) tmpPerson
{
    
    
    if (value) {
        if (opertype == OperationType_del) {
            [tmpPerson removeValueForProperty:kABPersonBirthdayProperty];
        }
        else if(opertype == OperationType_add||opertype == OperationType_edit)
            [tmpPerson setValue:value forProperty:kABPersonBirthdayProperty];
    }
}


//Mark: ========================本地通讯录 11大类操作
+(CFStringRef)getAdrBookType:(NSString*)str
{
    
    
    if ([str rangeOfString:kLABLE_HOME].location != NSNotFound)  {
        return kABHomeLabel;
    }
    else if ([str rangeOfString:kLABLE_WORK].location != NSNotFound)  {
        return kABWorkLabel;
    }
    else if ([str rangeOfString:kLABLE_MAIN].location != NSNotFound)  {
        return kABPersonPhoneMainLabel;
    }
    else if ([str rangeOfString:kLABLE_PAGER].location != NSNotFound)  {
        return kABPersonPhonePagerLabel;
    }
    else
    {
        return kABOtherLabel;
    }

}
@end
