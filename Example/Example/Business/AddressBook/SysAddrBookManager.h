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
+(void)     loadFromAddrBook:(NSMutableArray*)arr;
@end
