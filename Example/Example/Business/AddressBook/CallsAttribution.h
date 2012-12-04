//
//  CallsAttribution.h
//  HaoLianLuo
//
//  Created by iPhone_wmobile on 10-10-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CallsAttribution : NSObject {
   
}

//=======查询手机号码对应的电话供应商
+ (NSString*) providerOfPhone: (NSString*) phone;
//=======查询手机号码对应的归属地
+ (NSString*) attributionOfPhone: (NSString*) phone;

@end
