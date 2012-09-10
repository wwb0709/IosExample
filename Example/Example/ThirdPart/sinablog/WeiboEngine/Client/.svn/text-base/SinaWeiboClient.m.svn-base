//
//  SinaWeiboClient.m
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-21.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "SinaWeiboClient.h"


@implementation SinaWeiboClient

- (void)dealloc {
	[super dealloc];
}

+ (SinaWeiboClient *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction
									  oAuth:(OAuth *)_oAuth {
	SinaWeiboClient *connection = [[[SinaWeiboClient alloc]initWithDelegate:aDelegate
																	 action:anAction
																	  oAuth:_oAuth] autorelease];
	return connection;
}

+ (SinaWeiboClient *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction {
	SinaWeiboClient *connection = [[[SinaWeiboClient alloc]initWithDelegate:aDelegate
																	 action:anAction] autorelease];
	return connection;
}


- (void)processError:(NSDictionary *)dic {
	NSString *msg = [dic objectForKey:@"error"];
	if (msg) {
		NSLog(@"Weibo responded with an error: %@", msg);
		int errorCode = 0;//[[dic objectForKey:@"error_code"] intValue];
		NSRange range = [msg rangeOfString:@":"];
		if (range.length == 1 && range.location != NSNotFound) {
			errorCode = [[msg substringToIndex:range.location] intValue];
		}
		hasError = true;
		switch (errorCode) {
			default: 
				self.errorMessage = @"Weibo Server Error";
				self.errorDetail  = msg;
				break;					
		}
	}
}

- (NSString *)baseUrl {
	return @"http://api.t.sina.com.cn/";
}


#pragma mark -
#pragma mark overide public methods

- (void)verifyCredentials {
	[self asyncGet:@"account/verify_credentials.json" params:nil];
}


#pragma mark -
#pragma mark Followed Timeline

- (void)getFollowedTimelineMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
    [self getFollowedTimelineSinceID:0 withMaximumID:maxID startingAtPage:page count:count];
}

- (void)getFollowedTimelineSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count
{
    [self getFollowedTimelineSinceID:sinceID withMaximumID:0 startingAtPage:page count:count];
}

- (void)getFollowedTimelineSinceID:(long long)sinceID 
					 withMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", sinceID] forKey:@"since_id"];
    }
    if (maxID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", maxID] forKey:@"max_id"];
    }
    if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
	[super asyncGet:@"statuses/friends_timeline.json" params:params];
}
#pragma mark -
#pragma mark 获取我的好友列表
- (void)getMyFriendlineSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:[NSString stringWithFormat:@"%lld", sinceID] forKey:@"since_id"];
    [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"cursor"];
    [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    
    [super asyncGet:@"statuses/friends.json" params:params];
    
}
#pragma mark -
#pragma mark 获取我的粉丝列表;

- (void)getFriendlineSinceID:(long long)sinceID 
               withMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sinceID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", sinceID] forKey:@"since_id"];
    }
    if (maxID > 0) {
        [params setObject:[NSString stringWithFormat:@"%lld", maxID] forKey:@"max_id"];
    }
    if (page > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
	[super asyncGet:@"statuses/followers.json" params:params];
}

- (void)getFriendlineSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count
{
    [self getFriendlineSinceID:sinceID withMaximumID:0 startingAtPage:page count:count];
}

#pragma mark -
#pragma mark Comments


- (void)getCommentCounts:(NSArray *)_statusIds {
	needAuth = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	
	NSMutableString *ids = [[NSMutableString alloc]init];
	
	int count = _statusIds.count;
	int maxCount = 100;
	for (int i=0; i<count; i++) {
		NSNumber *statusId = [_statusIds objectAtIndex:i];
		[ids appendFormat:@"%lld", [statusId longLongValue]];
		maxCount--;
		if (i < count - 1 && maxCount > 0 ) {
			[ids appendString:@","];
		}
		if (maxCount <= 0) { 
			break;
		}
	}
	[params setObject:ids forKey:@"ids"];
	[ids release];
	[super asyncGet:@"statuses/counts.json" params:params];
}

#pragma mark -
#pragma mark Compose new Tweet

- (void)post:(NSString*)tweet
{
	needAuth = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:tweet forKey:@"status"];
	[super asyncPost:@"statuses/update.json" params:params withFiles:nil];
    
}


- (void)upload:(NSData*)jpeg status:(NSString *)status
{
    needAuth = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:status forKey:@"status"];
    RequestFile *file = [[[RequestFile alloc]initWithJpegData:jpeg forKey:@"pic"]autorelease];
	[super asyncPost:@"statuses/upload.json" params:params withFiles:[NSArray arrayWithObject:file]];
    
    /*
     needAuth = YES;
     NSString *path = [NSString stringWithFormat:@"statuses/upload.%@", API_FORMAT];
     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
     status, @"status",
     _engine.consumerKey, @"source",
     nil];
     
     NSString *param = [self nameValString:dic];
     NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", TWITTERFON_FORM_BOUNDARY];
     
     param = [param stringByAppendingString:[NSString stringWithFormat:@"--%@\r\n", TWITTERFON_FORM_BOUNDARY]];
     param = [param stringByAppendingString:@"Content-Disposition: form-data; name=\"pic\";filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"];
     NSLog(@"jpeg size: %d", [jpeg length]);
     
     NSMutableData *data = [NSMutableData data];
     [data appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
     [data appendData:jpeg];
     [data appendData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
     
     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
     [params setObject:_engine.consumerKey forKey:@"source"];
     [params setObject:status forKey:@"status"];
     //[params setObject:[NSString stringWithFormat:@"%@", statusId] forKey:@"source"];
     
     [self post:[self getURL:path queryParameters:params] data:data];
     */
}
#pragma mark -
#pragma mark 转发微博
- (void)forward:(NSString*)tweet idstring:(long long)aidstring iscomment:(int)aiscomment
{
	needAuth = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:[NSString stringWithFormat:@"%lld",aidstring] forKey:@"id"];
    [params setObject:tweet forKey:@"status"];
    [params setObject:[NSString stringWithFormat:@"%d",aiscomment] forKey:@"is_comment"];
	[super asyncPost:@"statuses/repost.json" params:params withFiles:nil];
    
}
- (void)forwardcomment:(NSData*)jpeg status:(NSString *)status idstring:(long long)aidstring iscomment:(int) aiscomment
{
    needAuth = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:[NSString stringWithFormat:@"%lld",aidstring] forKey:@"id"];
    [params setObject:status forKey:@"status"];
    [params setObject:[NSString stringWithFormat:@"%d",aiscomment] forKey:@"is_comment"];
    RequestFile *file = [[[RequestFile alloc]initWithJpegData:jpeg forKey:@"pic"]autorelease];
	[super asyncPost:@"statuses/repost.json" params:params withFiles:[NSArray arrayWithObject:file]];
}
#pragma mark -
#pragma mark 评论微博
-(void)addMyComment:(NSString *)comment idstring:(long long)aidstring forwar:(int)isforward{
    needAuth=YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:comment forKey:@"comment"];
    [params setObject:[NSString stringWithFormat:@"%lld",aidstring] forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%d",isforward] forKey:@"comment_ori"];
	[super asyncPost:@"statuses/comment.json" params:params withFiles:nil];
    
    
}
#pragma mark -
#pragma mark 关注某人
-(void)addmyfollowers:(long long)uid{
    needAuth=YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:[NSString stringWithFormat:@"%lld",uid] forKey:@"user_id"];
	[super asyncPost:@"friendships/create.json" params:params withFiles:nil];
    
    
}
#pragma mark -
#pragma mark 获取个人主页
-(void)getPersonalInformation:(NSString* )name weibocount:(int)count page:(int)apage{
    needAuth=YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (name==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无此微博昵称请返回" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    [params setObject:name forKey:@"screen_name"];
    [params setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    [params setObject:[NSString stringWithFormat:@"%d",apage] forKey:@"page"];
	[super asyncPost:@"statuses/user_timeline.json" params:params withFiles:nil];
    
}
#pragma mark -
#pragma mark 获取是否关注该用户
-(void)Get_Attention:(long long )MyId OtherID:(long long )otherid{
    needAuth=YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:[NSString stringWithFormat:@"%lld",MyId] forKey:@"user_a"];
    [params setObject:[NSString stringWithFormat:@"%lld",otherid] forKey:@"user_b"];
    [super asyncPost:@"friendships/exists.json" params:params withFiles:nil];
}
#pragma mark -
#pragma mark 取消关注该用户
-(void)Cancel_Attention:(long long)otherid{
    needAuth=YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:[NSString stringWithFormat:@"%lld",otherid] forKey:@"user_id"];
    [super asyncPost:@"friendships/destroy.json" params:params withFiles:nil];
}
#pragma mark -
#pragma mark Statuses/Comments
- (void)getCommentsFromID:(long long)fromID count:(int)count Page:(int)page
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSString stringWithFormat:@"%lld", fromID] forKey:@"id"];    
    
    [params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    
    [params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    
	[super asyncGet:@"statuses/comments.json" params:params];
}
#pragma mark -
#pragma mark Statuses/show/:id
- (void)getWeiboInfo:(long long)weiboID
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSString stringWithFormat:@"%lld", weiboID] forKey:@"id"];    
    
	[super asyncGet:@"statuses/show/:id.json" params:params];
}
@end
