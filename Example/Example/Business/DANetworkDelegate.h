//
//  DANetworkDelegate.h
//  DigitAlbum
//
//  Created by  on 11-10-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DANetworkEntity.h"
//网络请求的回调
@protocol DANetworkDelegate 

@optional
-(void)NetworkReturn:(DANetworkEntity*)networkEntity;
@end
