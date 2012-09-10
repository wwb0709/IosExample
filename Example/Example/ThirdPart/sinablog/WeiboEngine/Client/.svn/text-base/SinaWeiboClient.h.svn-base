//
//  SinaWeiboClient.h
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-21.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboConnection.h"

@interface SinaWeiboClient : WeiboConnection {
    
}

+ (SinaWeiboClient *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction
									  oAuth:(OAuth *)_oAuth;

+ (SinaWeiboClient *)connectionWithDelegate:(id)aDelegate 
									 action:(SEL)anAction;

#pragma mark -
#pragma mark Followed Timeline 

- (void)getFollowedTimelineMaximumID:(long long)maxID startingAtPage:(int)page count:(int)count;
- (void)getFollowedTimelineSinceID:(long long)sinceID startingAtPage:(int)pageNum count:(int)count; // statuses/friends_timeline
- (void)getFollowedTimelineSinceID:(long long)sinceID withMaximumID:(long long)maxID startingAtPage:(int)pageNum count:(int)count; // statuses/friends_timeline

#pragma mark -
#pragma mark Comments

- (void)getCommentCounts:(NSArray *)_statusIds;

#pragma mark -
#pragma mark Compose new Tweet

- (void)post:(NSString*)tweet;

- (void)upload:(NSData*)jpeg status:(NSString *)status;
- (void)forward:(NSString*)tweet idstring:(long long)aidstring iscomment:(int)aiscomment;
- (void)forwardcomment:(NSData*)jpeg status:(NSString *)status idstring:(long long)aidstring iscomment:(int) aiscomment;
-(void)addmyfollowers:(long long)uid;

- (void)getMyFriendlineSinceID:(long long)sinceID startingAtPage:(int)page count:(int)count;
-(void)getPersonalInformation:(NSString*)name weibocount:(int)count page:(int)apage;
-(void)Get_Attention:(long long )MyId OtherID:(long long)otherid;
-(void)Cancel_Attention:(long long)otherid;
-(void)getCommentsFromID:(long long)fromID count:(int)count Page:(int)page;
-(void)getWeiboInfo:(long long)weiboID;
-(void)addMyComment:(NSString *)comment idstring:(long long)aidstring forwar:(int)isforward;
@end
