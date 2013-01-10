//
//  VcardPersonEntity.h
//  Example
//
//  Created by wangwb on 13-1-6.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VcardPersonEntity : NSObject
{
    NSMutableDictionary*	NameArr;//姓名
    NSMutableDictionary*	PhoneArr;//电话
    NSMutableDictionary*	EmailArr;//邮件
    NSMutableDictionary*	AddrArr;//地址
    NSMutableDictionary*	SocialArr;//社交
    NSMutableDictionary*	URLArr;//URL
    NSMutableDictionary*	AIMArr;//AIM
    
    NSString*	remark;//备注
    NSString*	date;//出生日期
    
    NSString*	depart;//部门
    NSString*	company;//公司
    NSString*	zhiwei;//职位
    
    NSString*	ID;//ID
    
}

@property(nonatomic, retain) NSMutableDictionary*	NameArr;//姓名
@property(nonatomic, retain) NSMutableDictionary*	PhoneArr;//电话
@property(nonatomic, retain) NSMutableDictionary*	EmailArr;//邮件
@property(nonatomic, retain) NSMutableDictionary*	AddrArr;//地址
@property(nonatomic, retain) NSMutableDictionary*	SocialArr;//社交
@property(nonatomic, retain) NSMutableDictionary*	URLArr;//URL
@property(nonatomic, retain) NSMutableDictionary*	AIMArr;//AIM

@property(nonatomic, copy) NSString*	remark;//备注
@property(nonatomic, copy) NSString*	date;//出生日期
@property(nonatomic, copy) NSString*	depart;//部门
@property(nonatomic, copy) NSString*	company;//公司
@property(nonatomic, copy) NSString*	zhiwei;//职位
@property(nonatomic, copy) NSString*	ID;//ID


@end
