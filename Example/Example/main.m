//
//  main.m
//  AiHao
//
//  Created by wwb on 12-6-19.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    int retVal = UIApplicationMain(argc, argv, nil,  NSStringFromClass([AppDelegate class]));
//    [pool release];
//    return retVal;
    @autoreleasepool {
        return UIApplicationMain(argc, argv, @"AppDelegate", @"AppDelegate");
    }
}


//#import <UIKit/UIKit.h>
//#import "wax.h"
//#import "wax_http.h"
//#import "wax_json.h"
//#import "wax_filesystem.h"
//#import "wax_xml.h"
//
//int main(int argc, char *argv[])
//{
//    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
//
//    wax_start("AppDelegate2.lua", luaopen_wax_http, luaopen_wax_json, luaopen_wax_xml, nil);
//
//    int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate2");
//    [pool release];
//    return retVal;
//}

