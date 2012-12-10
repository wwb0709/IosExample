//
//  Utility.h
//  ShuDu
//
//  Created by wangwb on 12-12-10.
//
//

#import <Foundation/Foundation.h>
static BOOL isDeviceIPad(){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        return YES;
    }
#endif
    return NO;
}
@interface Utility : NSObject
+ (BOOL)hightRes;
+(NSString*)getFileName:(NSString*)filename;
@end
