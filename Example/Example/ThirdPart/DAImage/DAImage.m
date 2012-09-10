//
//  DA_MyImage.m
//  VANCL
//
//  Created by yek on 10-11-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DAImage.h"
//#import "DACache.h"

#pragma mark DAImageLoadOperation

@class DAImageLoadOperation;

@protocol DAImageLoadOperationDelegate<NSObject>
/*
 图片加载完成
 */
-(void) imageLoadOperation:(DAImageLoadOperation*) imageLoadOperation loadedImage:(UIImage*) image url:(NSString*) url ;
@end

@interface DAImageLoadOperation : NSOperation
{
	NSString* url;
	id<DAImageLoadOperationDelegate> delegate;
}
-(id) initWithImageUrl:(NSString*) aurl  delegate:(id<DAImageLoadOperationDelegate>) adelegate;

@property(nonatomic,copy) NSString* url;
@property(nonatomic,retain) id<DAImageLoadOperationDelegate> delegate;

@end



@interface DAImageLoadOperation()
-(void) performDelegateMethod:(id) sender;
@end
/*
 //TODO:添加缓存移除策略
 */
@implementation DAImageLoadOperation
@synthesize url;
@synthesize delegate;

-(id) initWithImageUrl:(NSString*) aurl  delegate:(id<DAImageLoadOperationDelegate>) adelegate{
	assert(aurl!=nil);
    self=[super init];
	if(self){
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
	UIImage* image=[DAImage imageFromUrl:url];
	if(delegate!=nil && ![self isCancelled]){
		//[delegate imageLoadOperation:self loadedImage:image url:url ];
		[self performSelectorOnMainThread:@selector(performDelegateMethod:) withObject:[image retain] waitUntilDone:NO];
	}
	[pool release];
}


@end

#pragma mark DAImageLoadOperationHandler
/*!
 加载图片后，图片作为参数调用[object action:image url:aurl];
 */
@interface DAImageLoadOperationHandler : NSObject<DAImageLoadOperationDelegate>
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

@implementation DAImageLoadOperationHandler
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

-(BOOL) isEqual:(DAImageLoadOperationHandler*)ahandler{
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

-(void) imageLoadOperation:(DAImageLoadOperation *)imageLoadOperation loadedImage:(UIImage *)image url:(NSString *)url{
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

#pragma mark DAImageLoadOperationHandlerSetImage
/*!
 加载图片后，设置给imageView.image;
 */
@interface DAImageLoadOperationHandlerSetImage : NSObject
{
	UIImageView* imageView;
	UIActivityIndicatorView* indicatorView;
	UIImageView* backgroundView;
}
@property(nonatomic,retain) UIImageView* imageView;

-(id) initWithImageView:(UIImageView*) aimageView;
-(void) onLoadedImage:(UIImage*) image url:(NSString*) url;

@end

@implementation DAImageLoadOperationHandlerSetImage
@synthesize imageView;
-(void) showIndicator:(id) obj{
    
    @synchronized(self){
        indicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame=CGRectMake(imageView.bounds.origin.x+(imageView.bounds.size.width-20)/2.0, imageView.bounds.origin.y+(imageView.bounds.size.height-20)/2.0, 20, 20);
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

-(void) onLoadedImage:(UIImage *)image url:(NSString *)url{
	[self performSelectorOnMainThread:@selector(hideIndicator:) withObject:nil waitUntilDone:NO];
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



@interface DAImage()
+(void) queueLoadImageFromUrl:(NSString *)url object:(id) object action:(SEL) action  param:(id)param needCanclPrev:(BOOL) canclePrev ;
@end


@implementation DAImage

//static DAFileCache* fileCache;
+(UIImage*) imageFromUrl:(NSString *)url{
	UIImage* ret=[DAImage imageFromUrl:url cacheEnable:YES];
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
	if(cacheEnable){
//		dataCache=[fileCache objectForKey:url];
		if(nil!=dataCache){
			ret=[[UIImage imageWithData:dataCache] retain];
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
		//NSData* data=[DA_MyImage dataFromUrl:url timeoutInterval:10];
		if(data!=nil){
			ret=[[UIImage imageWithData:data] retain];
			//NSLog(@"ret.size(%f,%f)",ret.size.width,ret.size.height);
		}
		//[pool release];
		
		if(ret==nil){
		//	NSLog(@"warning! +(UIImage*) imageFromUrl:(NSString *)url=%@ return nil", url);
		}else{
			if(cacheEnable){
//				[fileCache setObject:data forKey:url expireDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*7 ] ];
			}
		}
		[data release];
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
//	fileCache=[[DAFileCache  alloc] initWithFileName:@"imageFileCache2.dat"];
}

+(void) queueLoadImageFromUrl:(NSString *)url imageView:(UIImageView *)imageView{
	if(imageView==nil){
	//	NSLog(@"!!!!warning imageView is nil ");
		return;
	}
	
	
	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];	
	DAImageLoadOperationHandlerSetImage* setImageHandler=[[DAImageLoadOperationHandlerSetImage alloc] initWithImageView:imageView];
	imageView.image=nil;
    
    
	[DAImage queueLoadImageFromUrl:url object:setImageHandler action:@selector(onLoadedImage:url:) param:nil needCanclPrev:YES];
	[setImageHandler release];
	[pool release];
}
+(void) queueLoadImageFromUrl:(NSString*) url receiver:(id<NSObject>) areceiver{
    if(areceiver==nil || ![areceiver respondsToSelector:@selector(setImage:)]){
        assert(NO);
        NSLog(@"!!!! %s areceiver invalid",__FUNCTION__);
    }
    [DAImage queueLoadImageFromUrl:url imageView:(UIImageView*) areceiver];
}

+(void) queueLoadImageFromUrl:(NSString *)url object:(id) object action:(SEL) action  param:(id)param{
    [self queueLoadImageFromUrl:url object:object action:action param:param needCanclPrev:NO];
}
+(void) queueLoadImageFromUrl:(NSString *)url object:(id) object action:(SEL) action  param:(id)param needCanclPrev:(BOOL) canclePrev {
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
	DAImageLoadOperationHandler* handler=[[DAImageLoadOperationHandler alloc] initWithObject:object action:action param:param];
	DAImageLoadOperation* operation=[[DAImageLoadOperation alloc] initWithImageUrl:url delegate:handler];
    
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
    
	[DAImage queueLoadImageFromUrl:urlString object:self action:@selector(setImage:param:) param:nil];
}
-(void) setImage:(UIImage*) image param:(id) param{
	[self setImage:image forState:UIControlStateNormal];
}

-(void) setBackgroundImageFromUrl:(NSString*) urlString  {
	if(urlString==nil){
		//!! NSLog(@"!!!!warning urlString is nil");
		return;
	}
    
	[DAImage queueLoadImageFromUrl:urlString object:self action:@selector(setBackgroundImage:param:) param:nil];
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
    
	[DAImage queueLoadImageFromUrl:urlString object:self action:@selector(setBackgroundImage2:param:) param:nil];
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
	[DAImage queueLoadImageFromUrl:urlString imageView:self];
}


@end








