//
//  SysAddrBook.h
//  HaoLianLuo
//
//  Created by memac memac on 10-9-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>


@interface SysAddrBook : NSObject 
{
}
+(ABAddressBookRef)         getSingleAddressBook;
//==========================返回对应id的ABRecordRef
+(ABRecordRef)              RecordRefFromRecordID:(ABRecordID) _id;
//==========================返回对应group id的ABRecordRef
+(ABRecordRef)              GroupRecordRefFromRecordID:(ABRecordID) _id;
//==========================加入多条记录
+(NSInteger)				AddRecords:(NSArray*)	_arrEntity;
//==========================删除所有联系人记录
+(BOOL)						RemoveAllRecord;
//==========================删除一条联系人记录
+(BOOL)						RemoveRecord:(ABRecordID) _id;
//==========================取指定ID的联系人头像
+(UIImage*)					GetRecordImage:(ABRecordID) _id;
//==========================设置指定ID的联系人头像
+(BOOL)						SetRecordImage:(UIImage*) _image
                                  recordID:(ABRecordID) _id;
//==========================取所有联系人记录
+(NSInteger)				GetAllRecord:(NSMutableDictionary*) _dictionary;
//==========================取联系人个数
+(NSInteger)				GetRecordCount;

+(UIImage *)   imageWithRecordRef:(ABRecordRef) record;
+(bool)        setImage: (UIImage *)           image
              recordRef: (ABRecordRef)         record;

+(BOOL)     addRecordWithRef:(ABRecordRef) recordRef withError:(NSError **) error;
+(BOOL)     setPhoneDictionary:(NSDictionary*) dict toRecordRef:(ABRecordRef) record;






@end
