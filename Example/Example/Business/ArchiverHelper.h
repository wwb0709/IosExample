//
//  ArchiverHelper.h
//  CubeBrowser
//
//  Created by 国翔 韩 on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ArchiverHelper : NSObject

+(ArchiverHelper *)sharedInstance;

-(void)archiveObject:(id)object ByPath:(NSString *)archivePath;
-(id)getObjectByPath:(NSString *)archivePath;
@end
