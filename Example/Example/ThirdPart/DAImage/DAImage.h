//
//  DA_MyImage.h
//  VANCL
//
//  Created by yek on 10-11-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DAImage : NSObject {
    
}

/*
 从网址中加载图片，会阻塞
 */
+(UIImage*) imageFromUrl:(NSString*) url;
+(UIImage*) imageFromUrl:(NSString *)url  cacheEnable:(BOOL) cacheEnable;

/*
 加入异步加载图片队列中，图片加载完成后设置为imageView.image。
 */
+(void) queueLoadImageFromUrl:(NSString*) url imageView:(UIImageView*) imageView;
+(void) queueLoadImageFromUrl:(NSString*) url receiver:(id<NSObject>) areceiver;
  
  
/*
 加入异步加载图片队列中，图片加载完成后调用[object action:loadedImage ***:param ];
 参数列表：
 url:
 图片网址
 object:
 图片加载完成后调用此对象的action方法。 [object action:loadedImage ***:param];
 action:
 图片加载完成后调用方法。
 needCanclPrev:如果[object action]已经在队列中则取消队列中的
 action格式为：(void) *****:(UIImage*) image ***:(id) param;
 */
+(void) queueLoadImageFromUrl:(NSString *)url object:(id) object action:(SEL) action param:(id) param ;

+(void) queueLoadImageFromUrl:(NSString *)url object:(id) object action:(SEL) action  param:(id)param needCanclPrev:(BOOL) canclePrev ;

/*
 从队列中删除
 */
//todo +(void) removeQueueLoadImageFromUrl:(NSString*) url;




@end




@interface UIButton( setImageFromUrl )

/*
 异步加载图片，图片加载完成后设为对应状态的图片
 */
-(void) setImageFromUrl:(NSString*) urlString  forState:(UIControlState)state;
-(void) setBackgroundImageFromUrl:(NSString*) urlString  ;
-(void) setBackgroundImageFromUrl2:(NSString*) urlString  ;
@end

@interface UIImageView (setImageFromUrl )

-(void) setImageFromUrl:(NSString*) urlString;

@end




