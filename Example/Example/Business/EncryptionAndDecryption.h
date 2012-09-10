//
//  Decrypt.h
//  HaoLianLuo
//
//  Created by iPhone_wmobile on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"


@interface EncryptionAndDecryption : NSObject {
    
}

+(NSString*) encryption:(NSString*) info;
+(NSString*) decrypt:(NSString*) info;

+(NSString*) encryptionHLL:(NSString*) info;
+(NSString*) decryptHLL:(NSString*) info;

@end
