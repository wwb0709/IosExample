//
//  FileTypeModel.h
//  CubeBrowser
//
//  Created by 国翔 韩 on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTypeModel : NSObject

@property(nonatomic)int fileTypeID;
@property(nonatomic,retain)NSString *fileTypeName;
@property(nonatomic,retain)NSString *fileTypeDetail;
@property(nonatomic,retain)NSString *fileImgURL;
@property(nonatomic,assign)NSUInteger fileCount;
@end
