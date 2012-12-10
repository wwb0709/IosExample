//
//  Utility.m
//  ShuDu
//
//  Created by wangwb on 12-12-10.
//
//

#import "Utility.h"

@implementation Utility
+ (BOOL)hightRes {
    if( [[CCDirector sharedDirector] contentScaleFactor] > 1.0f ){
        return YES;
    }
    
    return isDeviceIPad();
}

+(NSString*)getFileName:(NSString*)filename
{
    return [NSString stringWithFormat:@"%@%@.png",filename, (isDeviceIPad()?@"~ipad":([Utility hightRes]?@"@2x":@""))];
}
@end
