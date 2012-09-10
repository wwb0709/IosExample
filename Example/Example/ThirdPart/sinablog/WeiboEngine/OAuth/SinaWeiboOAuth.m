//
//  SinaWeiboOAuth.m
//  Zhiweibo2
//
//  Created by junmin liu on 11-2-18.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "SinaWeiboOAuth.h"
#import "SinaWeiboClient.h"

@implementation SinaWeiboOAuth


- (id)init {

	if (self = [super initWithConsumerKey:@"252219433"
						andConsumerSecret:@"ab8308f5f60ac3138a0ee699e9cca386"]) {
		self.requestTokenURL = [NSURL URLWithString: @"http://api.t.sina.com.cn/oauth/request_token"];
		self.accessTokenURL = [NSURL URLWithString: @"http://api.t.sina.com.cn/oauth/access_token"];
		self.authorizeURL = [NSURL URLWithString: @"http://api.t.sina.com.cn/oauth/authorize"];
		self.verifyCredentialsURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/account/verify_credentials.json"];
	}
	return self;
}

- (WeiboConnection *)getWeiboConnectionWithDelegate:(id)_delegate 
											 action:(SEL)anAction {
	return [SinaWeiboClient connectionWithDelegate:_delegate 
											action:anAction 
											 oAuth:self];
}



@end
