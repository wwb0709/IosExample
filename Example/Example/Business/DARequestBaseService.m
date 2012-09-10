//
//  DARequestBaseService.m
//  DigitAlbum
//
//  Created by  on 11-10-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DARequestBaseService.h"

@implementation DARequestBaseService
@synthesize delegate;
- (id)initwithTarget:(id)target
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.delegate=target;
    }
    
    return self;
}

-(void)RequestFinishReturn:(DARequestEntity*)requestEntity
{
    [self performSelectorOnMainThread:@selector(RequestFinishReturnMainThread:) withObject:requestEntity waitUntilDone:NO];
}

-(void)RequestFinishReturnMainThread:(DARequestEntity*)requestEntity
{
    if (delegate) {
        [delegate DARequestFinish:requestEntity];
    }
}

@end
