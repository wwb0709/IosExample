//
//  MenuLayer.h
//  ShuDu
//
//  Created by wangwb on 12-12-12.
//
//

#import <QuartzCore/QuartzCore.h>
#import "cocos2d.h"
@protocol CurrentSelectDelegate
@optional
- (void)currentSelectIndex:(NSInteger)index;
@end

@interface MenuLayer : CCLayer

@property (nonatomic,assign) id<CurrentSelectDelegate> delegate;
@end
