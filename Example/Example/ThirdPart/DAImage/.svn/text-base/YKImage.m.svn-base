//
//  YK_MyImage.m
//  VANCL
//
//  Created by yek on 10-11-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YKImage.h"
#import "YKCache.h"
#import "DAUtility.h"


#pragma mark YKImageLoadOperation

@class YKImageLoadOperation;

@protocol YKImageLoadOperationDelegate<NSObject>
/*
 图片加载完成
 */
-(void) imageLoadOperation:(YKImageLoadOperation*) imageLoadOperation loadedImage:(UIImage*) image url:(NSString*) url ;
@end

@interface YKImageLoadOperation : NSOperation
{
	NSString* url;
	id<YKImageLoadOperationDelegate> delegate;
    BOOL fromCash;
}
-(id) initWithImageUrl:(NSString*) aurl  delegate:(id<YKImageLoadOperationDelegate>) adelegate fromCash:(BOOL) fromCash;

@property(nonatomic) BOOL fromCash;
@property(nonatomic,copy) NSString* url;
@property(nonatomic,retain) id<YKImageLoadOperationDelegate> delegate;

@end



@interface YKImageLoadOperation()
-(void) performDelegateMethod:(id) sender;
@end
/*
 //TODO:添加缓存移除策略
 */
@implementation YKImageLoadOperation
@synthesize url;
@synthesize delegate;
@synthesize fromCash;

-(id) initWithImageUrl:(NSString*) aurl  delegate:(id<YKImageLoadOperationDelegate>) adelegate fromCash:(BOOL) from{
	assert(aurl!=nil);
    self=[super init];
	if(self){
        self.fromCash = from;
		self.url=aurl;
		self.delegate=adelegate;
	}
	return self;
}

-(void) dealloc{
	[url release];
	[delegate release];
	[super dealloc];
}

-(void)cancel{
    [self performDelegateMethod:nil];
    [super cancel];
    
    [delegate release];
    delegate=nil;
}
-(BOOL) isEqual:(id)object{
	BOOL ret=NO;
	if( self==object ||
       ([[object class] isEqual:[self class]] 
        //&& (url==[object url] || [url isEqual:[object url]] ) 
        && ((delegate==[object delegate]) || [delegate isEqual:[object delegate]] )) ){
           ret=YES;
       }
	return ret;
}

-(void) performDelegateMethod:(id) sender{
	UIImage* image=(UIImage*) sender;
	[delegate imageLoadOperation:self loadedImage:image url:url ];
	[image release];
}
-(void) main{
    if([self isCancelled]){
        return;
    }
	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    UIImage* image;
    if (self.fromCash) {
        fromCash = NO;
        image = [YKImage imageFromCashFile:url];
        
    }else{
       image =[YKImage imageFromUrl:url];
    }
	if(delegate!=nil && ![self isCancelled]){
		//[delegate imageLoadOperation:self loadedImage:image url:url ];
		[self performSelectorOnMainThread:@selector(performDelegateMethod:) withObject:[image retain] waitUntilDone:NO];
	}
	[pool release];
}


@end

#pragma mark YKImageLoadOperationHandler
/*!
 加载图片后，图片作为参数调用[object action:image url:aurl];
 */
@interface YKImageLoadOperationHandler : NSObject<YKImageLoadOperationDelegate>
{
	id object;
	SEL action;
	id param;
}
@property(nonatomic,assign) id object;
@property(nonatomic,assign) SEL action;
@property(nonatomic,assign) id param;

/*
 action:
 (void) *****:(UIImage*) image url:(NSString*) url;
 */
-(id) initWithObject:(id) aobject action:(SEL)aaction param:(id) aparam;
@end

@implementation YKImageLoadOperationHandler
@synthesize object;
@synthesize action;
@synthesize param;

NSTimeInterval startTime;
-(id) initWithObject:(id)aobject action:(SEL)aaction param:(id) aparam{
    self=[super init];
	if(self){
		startTime=[[NSDate date] timeIntervalSince1970];
		object=[aobject retain];
		action=aaction;
		param=[aparam retain];
	}
	return self;
}

-(BOOL) isEqual:(YKImageLoadOperationHandler*)ahandler{
	BOOL ret=NO;
	if( self==ahandler || 
       ( object==[ahandler object] || ( [object isEqual:[ahandler object]] 	   
	   && action==[ahandler action]) )
       //不需要考虑param 
	   //&& (param==[ahandler param] || [param isEqual:[ahandler param]] )) {
       ){
		ret=YES;
	}
	return ret;
}

-(void) imageLoadOperation:(YKImageLoadOperation *)imageLoadOperation loadedImage:(UIImage *)image url:(NSString *)url{
	[object performSelector:action withObject:image withObject:param];
	//NSTimeInterval endTime=[[NSDate date] timeIntervalSince1970];
	//NSLog(@"%@ timespan %f startTime:%f endTime:%f",[self class],endTime-startTime,startTime, endTime);
}

-(void) dealloc{
	[param release];
	[object release];
	[super dealloc];
}


@end

#pragma mark YKImageLoadOperationHandlerSetImage
/*!
 加载图片后，设置给imageView.image;
 */
static YKFileCache* fileCache;
@interface YKImageLoadOperationHandlerSetImage : NSObject
{
	UIImageView* imageView;
	UIActivityIndicatorView* indicatorView;
	UIImageView* backgroundView;
}
@property(nonatomic,retain) UIImageView* imageView;

-(id) initWithImageView:(UIImageView*) aimageView;
-(void) onLoadedImage:(UIImage*) image url:(NSString*) url;

@end

@implementation YKImageLoadOperationHandlerSetImage
@synthesize imageView;
-(void) showIndicator:(id) obj{
    
    @synchronized(self){
        indicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame=CGRectMake(imageView.bounds.origin.x+(imageView.bounds.size.width-20)/2.0, imageView.bounds.origin.y+(imageView.bounds.size.height-60)/2.0, 20, 20);
        [imageView addSubview:indicatorView];
        [indicatorView startAnimating];
        [indicatorView release];
    }
}
-(void) hideIndicator:(id) obj{
    @synchronized(self){
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        indicatorView=nil;
    }
    //	[backgroundView removeFromSuperview];
    //	backgroundView=nil;
}

-(id) initWithImageView:(UIImageView *)aimageView{
    self=[super init];
	if(self){
		self.imageView=aimageView;
		[self performSelectorOnMainThread:@selector(showIndicator:) withObject:nil waitUntilDone:NO];
	}
	return self;
}

-(void) onLoadedImage:(UIImage *)image url:(NSString *)url {
	[self performSelectorOnMainThread:@selector(hideIndicator:) withObject:nil waitUntilDone:NO];
    [imageView performSelectorOnMainThread:@selector(setImageViewFrame:) withObject:[NSArray arrayWithObjects:image,imageView, nil] waitUntilDone:YES];
	[imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
}



-(void) dealloc{
	[self hideIndicator:nil];
	[imageView release];
	[super dealloc];
}

-(BOOL)isEqual:(id)object{
    BOOL ret=NO;
    if(object!=nil){
        if([[self class] isEqual:[object class]]){
            if( imageView==[object imageView] || [imageView isEqual:[object imageView]]){
                ret=YES;
            }
        }
    }
    return ret;
}

@end



@interface YKImage()
+(void) queueLoadImageFromUrl:(NSString *)url object:(id) object action:(SEL) action  param:(id)param needCanclPrev:(BOOL) canclePrev fromCash:(BOOL) fromCashFile;
@end


@implementation YKImage


+(UIImage*) imageFromUrl:(NSString *)url{
	UIImage* ret=[YKImage imageFromUrl:url cacheEnable:YES];
	return ret;
}
+(UIImage*) imageFromUrl:(NSString *)url  cacheEnable:(BOOL) cacheEnable{
	if(url==nil){
		NSLog(@"!!!!warning url nil .method:%s",__FUNCTION__);
		return nil;
	}
	NSURL* u=[[NSURL alloc] initWithString:url];
	if(u==nil){
		NSLog(@"!!!!warning url invalid . method: %s",__FUNCTION__);
		return nil;
	}
	[u release];
    //NSLog(@"%s url=%@ ",__FUNCTION__,url);

	//NSLog(@"+(UIImage*) imageFromUrl:(NSString *)url=%@ enter...",url);
	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
	UIImage* ret=nil;
	NSData* dataCache=nil;
    NSString *imagePath=[NSString stringWithFormat:@"%@%@",[DAUtility getMVImage],[url lastPathComponent]];
	if(cacheEnable){
        if ([DAUtility FileExists:imagePath]) {
            dataCache=[NSData dataWithContentsOfFile:imagePath];
            if(nil!=dataCache){
                ret=[[UIImage imageWithData:dataCache] retain];
            }
        }
	}
	if(nil==ret){
        assert(![[NSThread currentThread] isMainThread]);
		//load from url
		NSError* error=nil;
		NSURL *tUrl = [[NSURL alloc] initWithString:url];
		//没法设置超时时间，使用error 检测成功或失败
        //test
       // NSLog(@"[total] [[NSData alloc] initWithContentsOfURL:%@ options:0 error:&error];",tUrl);
		NSData* data = [[NSData alloc] initWithContentsOfURL:tUrl options:0 error:&error];
		if (error!=nil) {
			ret=nil;
		}
		[tUrl release];
		//data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
		//NSData* data=[YK_MyImage dataFromUrl:url timeoutInterval:10];
		if(data!=nil){
			ret=[[UIImage imageWithData:data] retain];
			//NSLog(@"ret.size(%f,%f)",ret.size.width,ret.size.height);
		}
		//[pool release];
		
		if(ret==nil){
            NSLog(@"warning! +(UIImage*) imageFromUrl:(NSString *)url=%@ return nil", url);
		}else{
			if(cacheEnable){
               
                if (![DAUtility FileExists:[DAUtility getMVImage]]) {
                    [DAUtility directoryCreate:[DAUtility getMVImage]];
                }
                 NSString *imageSavePath=[NSString stringWithFormat:@"%@%@",[DAUtility getMVImage],[url lastPathComponent]];
                [data writeToFile:imageSavePath atomically:YES];
//                [fileCache setObject:data forKey:url];
//                [fileCache save];
//				[fileCache setObject:data forKey:url expireDate:[[NSDate date] dateByAddingTimeInterval:60] ];
			}
		}
		[data release];
	}
	[pool release];
	return [ret autorelease];
}
+(UIImage *)imageFromCashFile:(NSString *)aURL{
    if(aURL==nil){
		NSLog(@"!!!!warning url nil .method:%s",__FUNCTION__);
		return nil;
	}
	NSURL* u=[[NSURL alloc] initWithString:aURL];
	if(u==nil){
		NSLog(@"!!!!warning url invalid . method: %s",__FUNCTION__);
		return nil;
	}
	[u release];
    //NSLog(@"%s url=%@ ",__FUNCTION__,url);
    
	//NSLog(@"+(UIImage*) imageFromUrl:(NSString *)url=%@ enter...",url);
	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
	UIImage* ret=nil;
	NSData* dataCache=nil;
     NSString *imagePath=[NSString stringWithFormat:@"%@%@",[DAUtility getMVImage],[aURL lastPathComponent]];
    if ([DAUtility FileExists:imagePath]) {
        dataCache=[NSData dataWithContentsOfFile:imagePath];
        if(nil!=dataCache){
            ret=[[UIImage imageWithData:dataCache] retain];
        }
    }
    [pool release];
    return [ret autorelease];
}
//static NSMutableArray* queueOperation;
static NSOperationQueue* queue;
+(void) initialize{
    
	//queueOperation=[[NSMutableArray alloc] init];
	queue=[[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:4];
	fileCache=[[YKFileCache  alloc] initWithFileName:@"imageFileCache2.dat"];
}
+(void) queueLoadImageFromUrl:(NSString *)url imageView:(UIImageView *)imageView formCashFile:(BOOL) fromCashFile{
    if(imageView==nil){
        //	NSLog(@"!!!!warning imageView is nil ");
		return;
	}
	
	
	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];	
	YKImageLoadOperationHandlerSetImage* setImageHandler=[[YKImageLoadOperationHandlerSetImage alloc] initWithImageView:imageView];
	imageView.image=nil;
    
    
	[YKImage queueLoadImageFromUrl:url object:setImageHandler action:@selector(onLoadedImage:url:) param:nil needCanclPrev:YES fromCash:fromCashFile];
	[setImageHandler release];
	[pool release];
}

+(void) queueLoadImageFromUrl:(NSString *)url imageView:(UIImageView *)imageView{
	if(imageView==nil){
	//	NSLog(@"!!!!warning imageView is nil ");
		return;
	}
	
	
	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];	
	YKImageLoadOperationHandlerSetImage* setImageHandler=[[YKImageLoadOperationHandlerSetImage alloc] initWithImageView:imageView];
	imageView.image=nil;
    
    
	[YKImage queueLoadImageFromUrl:url object:setImageHandler action:@selector(onLoadedImage:url:) param:nil needCanclPrev:YES fromCash:NO];
	[setImageHandler release];
	[pool release];
}
+(void) queueLoadImageFromUrl:(NSString*) url receiver:(id<NSObject>) areceiver{
    if(areceiver==nil || ![areceiver respondsToSelector:@selector(setImage:)]){
        assert(NO);
        NSLog(@"!!!! %s areceiver invalid",__FUNCTION__);
    }
    [YKImage queueLoadImageFromUrl:url imageView:(UIImageView*) areceiver];
}

+(void) queueLoadImageFromUrl:(NSString *)url object:(id) object action:(SEL) action  param:(id)param{
    
    [self queueLoadImageFromUrl:url object:object action:action param:param needCanclPrev:NO fromCash:NO];
}
+(void) queueLoadImageFromUrl:(NSString *)url object:(id) object action:(SEL) action  param:(id)param needCanclPrev:(BOOL) canclePrev fromCash:(BOOL) fromCashFile{
	if(url==nil ){
	//	NSLog(@"!!!!warning url is nil . method=%s",__FUNCTION__);
		return;
	}
	
	NSURL* u=[[NSURL alloc] initWithString:url];
	if(u==nil){
	//	NSLog(@"!!!!warning url is invalid . method=%s",__FUNCTION__);		
		return;
	}
	[u release];
	
	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
	YKImageLoadOperationHandler* handler=[[YKImageLoadOperationHandler alloc] initWithObject:object action:action param:param];
	YKImageLoadOperation* operation;//=[[YKImageLoadOperation alloc] initWithImageUrl:url delegate:handler  fromCash:NO];
    if (fromCashFile) {
        operation=[[YKImageLoadOperation alloc] initWithImageUrl:url delegate:handler  fromCash:YES];
    }else{
        operation=[[YKImageLoadOperation alloc] initWithImageUrl:url delegate:handler  fromCash:NO];
    }
	if(canclePrev){
        //取消之前相同的operation
        NSArray* operationArray=[queue operations];
        for(NSOperation* op in operationArray){
            if([operation isEqual:op] && ![op isFinished]){
                //取消之前的operation
                //NSLog(@"!!!!op cancl url=%@ object=%@",url,object);
                [op cancel];
            }
        }
    }
	[queue performSelectorInBackground:@selector(addOperation:) withObject:operation];
	//[queueOperation addObject:queueOperation];
	//[queue addOperation:operation];
	[operation release];
	[handler release];
    
	[pool release];
}

@end






#pragma mark  category uibutton

@implementation UIButton( setImageFromUrl )

-(void) setImageFromUrl:(NSString*) urlString  forState:(UIControlState)state{
	if(urlString==nil){
		//!! NSLog(@"!!!!warning urlString is nil");
		return;
	}
    
	[YKImage queueLoadImageFromUrl:urlString object:self action:@selector(setImage:param:) param:nil];
}
-(void) setImage:(UIImage*) image param:(id) param{
	[self setImage:image forState:UIControlStateNormal];
}

-(void) setBackgroundImageFromUrl:(NSString*) urlString  {
	if(urlString==nil){
		//!! NSLog(@"!!!!warning urlString is nil");
		return;
	}
    
	[YKImage queueLoadImageFromUrl:urlString object:self action:@selector(setBackgroundImage:param:) param:nil];
}
-(void) setBackgroundImage:(UIImage*) image param:(id) param{
	[self setImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

-(void) setBackgroundImageFromUrl2:(NSString*) urlString  {
	if(urlString==nil){
		//!! NSLog(@"!!!!warning urlString is nil");
		return;
	}
    
	[YKImage queueLoadImageFromUrl:urlString object:self action:@selector(setBackgroundImage2:param:) param:nil];
}
-(void) setBackgroundImage2:(UIImage*) image param:(id) param{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}


@end



#pragma mark UIImage
@implementation UIImageView (setImageFromUrl )


-(void) setImageFromUrl:(NSString*) urlString{
	if(urlString==nil){
		//!! NSLog(@"!!!!warning urlString is nil");
		return;
	}
	[YKImage queueLoadImageFromUrl:urlString imageView:self];
}

-(void) setImageFromCashFile:(NSString *)urlString{
    if(urlString==nil){
		//!! NSLog(@"!!!!warning urlString is nil");
		return;
	}
	[YKImage queueLoadImageFromUrl:urlString imageView:self formCashFile:YES];
}

-(void)setImageViewFrame:(NSArray *)array
{
    if (!array||array.count!=2) {
        return;
    }
    id idImage=[array objectAtIndex:0];
    if (!idImage||![idImage isKindOfClass:[UIImage class]]) {
        return;
    }
    id idImageView=[array objectAtIndex:1];
    if (!idImageView||![idImageView isKindOfClass:[UIImageView class]]) {
        return;
    }
    UIImage *image=[array objectAtIndex:0];
    UIImageView *tmpimageView=[array objectAtIndex:1];
     //NSLog(@"%f %f",image.size.height,image.size.width);
    CGFloat imageViewHeight=image.size.height/image.size.width*tmpimageView.frame.size.width;
    tmpimageView.frame=CGRectMake(tmpimageView.frame.origin.x, tmpimageView.frame.origin.y, tmpimageView.frame.size.width, imageViewHeight);
    //NSLog(@"%f %f %f %f",tmpimageView.frame.origin.x,tmpimageView.frame.origin.y,tmpimageView.frame.size.width,tmpimageView.frame.size.height);
}
@end








