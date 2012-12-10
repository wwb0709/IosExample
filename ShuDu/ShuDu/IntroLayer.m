//
//  IntroLayer.m
//  ShuDu
//
//  Created by wangwb on 12-12-5.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "GameLayer.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];

	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
	

    background = [CCSprite spriteWithFile:[Utility getFileName:@"homgbg"]];

	background.position = ccp(size.width/2, size.height/2);

	// add the label as a child to this Layer
	[self addChild: background];
    
    
    //添加菜单
    
    // Default font size will be 28 points.
    [CCMenuItemFont setFontSize:20];
    
    // Achievement Menu Item using blocks
    CCMenuItem *itemStart = [CCMenuItemFont itemWithString:@"开始" block:^(id sender) {
        [self scheduleOnce:@selector(makeTransition:) delay:1];
    }];
    CCSprite *color = [CCSprite spriteWithFile:[Utility getFileName:@"home-but"]];
    [color setPosition:ccp( 21, 12)];
    [itemStart addChild:color z:-1 tag:1];
    // Leaderboard Menu Item using blocks
    CCMenuItem *itemModle = [CCMenuItemFont itemWithString:@"模式" block:^(id sender) {
    }];
    CCSprite *color1 = [CCSprite spriteWithFile:[Utility getFileName:@"home-but"]];
    [color1 setPosition:ccp( 21, 12)];
    [itemModle addChild:color1 z:-1 tag:1];
    CCMenuItem *itemRank = [CCMenuItemFont itemWithString:@"排行" block:^(id sender) {
    }];
    CCSprite *color2 = [CCSprite spriteWithFile:[Utility getFileName:@"home-but"]];
    [color2 setPosition:ccp( 21, 12)];
    [itemRank addChild:color2 z:-1 tag:1];
    CCMenu *menu = [CCMenu menuWithItems:itemStart, itemModle,itemRank, nil];
    
    [menu alignItemsVerticallyWithPadding:20];
    [menu setPosition:ccp( size.width/2, size.height/2 - 50)];
    
    // Add the menu to the layer
    [self addChild:menu];
	
	// In one second transition to the new scene
	
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene] withColor:ccWHITE]];
}
@end
