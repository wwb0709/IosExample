//
//  DARequestBaseService.h
//  DigitAlbum
//
//  Created by  on 11-10-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DARequestDelegate.h"
@interface DARequestBaseService : NSObject<DARequestDelegate>
{
    id<DARequestDelegate> delegate;
}
@property(nonatomic,assign) id<DARequestDelegate> delegate;

- (id)initwithTarget:(id)target;

@end

@interface DARequestBaseService(Protected)
-(void)RequestFinishReturn:(DARequestEntity*)requestEntity;//子类调用得触发回调
@end

@interface DARequestBaseService(Private)
-(void)RequestFinishReturnMainThread:(DARequestEntity*)requestEntity;
@end