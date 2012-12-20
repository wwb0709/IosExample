//
//  FileTypeModel.m
//  CubeBrowser
//
//  Created by 国翔 韩 on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FileTypeModel.h"

@implementation FileTypeModel

@synthesize fileTypeID;
@synthesize fileTypeName;
@synthesize fileTypeDetail;
@synthesize fileImgURL;
@synthesize fileCount;

-(void)dealloc
{
    self.fileImgURL=nil;
    self.fileTypeName=nil;
    self.fileTypeDetail=nil;
    [super dealloc];
}

@end
