//
//  SysAddrBookManager.h
//  Example
//
//  Created by wangwb on 13-1-9.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "VcardPersonEntity.h"
#import "GTMABAddressBook.h"
#import "SysAddrBook.h"
@interface SysAddrBookManager : NSObject
{
}
+(ABAddressBookRef)         getSingleAddressBook;
+(void)                     destroySingleAddressBook;
//======================删除所有联系人记录
+(BOOL)		RemoveAllRecord;
//======================删除指定ID的联系人记录
+(BOOL)		RemoveRecord:(ABRecordID) _id;
//======================加载联系人记录
+(void)     loadFromAddrBook:(NSMutableDictionary*)arr;
//=====================创建vcf
+(void)createVcard;

//=====================恢复从vcf
+(void)recoverAddressBookFormVcard:(NSString *)filePath;

//***************** 1、个人基本信息操作 ******************
+ (void)OperBasicInfoWithProperty : (ABPropertyID)propertyId
                         andValue : (NSString*)value
                      andOperType : (OperationType)opertype
                         inPerson : (GTMABPerson *) tmpPerson;

//***************** 2、电话号码信息操作 ******************
+(void)OperContactNumbersWithKey : (CFStringRef)key
                         andValue : (NSString*)value
                         andIndex : (NSUInteger)index
                      andOperType : (OperationType)opertype
                         inPerson : (GTMABPerson *) tmpPerson;
//***************** 3、相关联系人信息操作 *****************
+(void)OperRelatedContactsWithKey : (CFStringRef)key
                          andValue : (NSString*) value
                          andIndex : (NSUInteger)index
                       andOperType : (OperationType)opertype
                          inPerson : (GTMABPerson *) tmpPerson;
//***************** 4、住址信息操作 **********************
+(void)OperAddressesWithKey : (CFStringRef)key
                    andValue :(id) value
                    andIndex : (NSUInteger)index
                 andOperType : (OperationType)opertype
                    inPerson : (GTMABPerson *) tmpPerson;
//***************** 5、社交信息操作 **********************
+(void)OperNetSocialWithKey : (CFStringRef)key
                    andValue : (NSString*) value
                    andIndex : (NSUInteger)index
                 andOperType : (OperationType)opertype
                    inPerson : (GTMABPerson *) tmpPerson;
//***************** 6、IM信息操作 ***********************
+(void)OperIMsWithKey : (CFStringRef)key
              andValue : (NSString*) value
              andIndex : (NSUInteger)index
           andOperType : (OperationType)opertype
              inPerson : (GTMABPerson *) tmpPerson;
//***************** 7、邮件信息操作 **********************
+(void)OperEmailsWithKey : (CFStringRef)key
                 andValue : (NSString*) value
                 andIndex : (NSUInteger)index
              andOperType : (OperationType)opertype
                inPerson : (GTMABPerson *) tmpPerson;
//***************** 8、url信息操作 **********************
+(void)OperUrlsWithKey : (CFStringRef)key
               andValue : (NSString*) value
               andIndex : (NSUInteger)index
            andOperType : (OperationType)opertype
               inPerson : (GTMABPerson *) tmpPerson;
//***************** 9、日期信息操作 **********************
+(void)OperDatesWithKey : (CFStringRef)key
                andValue : (NSDate*) value
                andIndex : (NSUInteger)index
             andOperType : (OperationType)opertype
                inPerson : (GTMABPerson *) tmpPerson;
//***************** 10、备注操作 *********************
+(void)OperPersonNoteWithOperType : (OperationType)opertype
                          andValue : (NSString*) value
                          inPerson : (GTMABPerson *) tmpPerson;
//***************** 11、生日信息操作 *********************
+(void)OperBirthdayWithOperType : (OperationType)opertype
                        andValue : (NSDate*) value
                        inPerson : (GTMABPerson *) tmpPerson;
+(CFStringRef)getAdrBookType:(NSString*)str;
@end
