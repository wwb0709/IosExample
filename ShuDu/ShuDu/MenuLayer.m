//
//  MenuLayer.m
//  ShuDu
//
//  Created by wangwb on 12-12-12.
//
//

#import "MenuLayer.h"

@implementation MenuLayer
@synthesize delegate;
// on "init" you need to initialize your instance
//-(id) init
//{
//	// always call "super" init
//	// Apple recommends to re-assign "self" with the "super's" return value
//	if( (self=[super init]) ) {
//		
//        [self setIsTouchEnabled: YES];
//        CGSize size = [[CCDirector sharedDirector] winSize];
//        //添加菜单
//
//        // Default font size will be 28 points.
//        [CCMenuItemFont setFontSize:20];
//
//        NSMutableArray *menuItemArr = [NSMutableArray array];
//        for (int i=0; i<10; i++) {
//            // Achievement Menu Item using blocks
//            CCMenuItem *item = [CCMenuItemFont itemWithString:[NSMutableString stringWithFormat:@"%d",i+1] block:^(id sender) {
//               
//            }];
//            item.tag = i+1;
//
//
//            CCSprite *back = [CCSprite spriteWithFile:[Utility getFileName:@"gameinputselect"] rect:(CGRect)CGRectMake(0,0,50,50)];
//            [back setAnchorPoint:ccp( 0.5, 0.5)];
//            [back setPosition:ccp( 25, 25)];
//            [back setColor:ccc3(93, 90, 55)];
//            [item addChild:back z:-1 tag:1];
//
//            [menuItemArr addObject:item];
//        }
//
//        CCMenu *menu = [CCMenu menuWithArray:menuItemArr];
//        [menu alignItemsHorizontallyWithPadding:5];
//        [menu setColor:ccc3(91, 90, 55)];
//        [menu setPosition:ccp( size.width/2, size.height/2)];
//
//        [menu alignItemsInColumns:
//         [NSNumber numberWithUnsignedInt:2],
//         [NSNumber numberWithUnsignedInt:2],
//         [NSNumber numberWithUnsignedInt:2],
//         [NSNumber numberWithUnsignedInt:2],
//         [NSNumber numberWithUnsignedInt:2],
//         nil
//         ];
//        [self addChild:menu  z:1 tag:99999];
//        
//	}
//	return self;
//}
-(id)init {
    self =[super init];
   CGSize size = [[CCDirector sharedDirector] winSize];
    if(self){
        //[self setContentSize:CGSizeMake(200, 200)];
        
        
        CCLayerColor *layerColor = [CCLayerColor layerWithColor:ccc4(255, 0, 255, 200)];
     
        [layerColor setContentSize:CGSizeMake(200, 200)];
        layerColor.anchorPoint =  ccp(0.5f, 0.5f);
        layerColor.position  = CGPointMake(size.width / 2-100, size.height / 2-100);
        [self addChild:layerColor z:0];
        
        // 设置CCMenuItemFont的默认属性
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:26];
        // 生成几个文字标签并指定它们的选择器
//        CCMenuItemFont* item1 = [CCMenuItemFont itemWithString:@"Go Back!" target:self selector:@selector(openSound:)];
        
//        CCSprite* normal = [CCSprite spriteWithFile:[Utility getFileName:@"gameinputselect"]];
//        normal.color = ccRED;
//        CCSprite* selected = [CCSprite spriteWithFile:[Utility getFileName:@"gameinputselect"]];
//        selected.color = ccGREEN;
//        CCMenuItemSprite* item2 = [CCMenuItemSprite itemWithNormalSprite:normal
//                                                          selectedSprite:selected target:self selector:@selector(openSound:)];
//        // 用其它两个菜单项生成一个切换菜单(图片也可以用于切换)
//        [CCMenuItemFont setFontName:@"STHeitiJ-Light"];
//        [CCMenuItemFont setFontSize:18];
//        CCMenuItemFont* toggleOn = [CCMenuItemFont itemWithString:@"I'm ON!"];
//        CCMenuItemFont* toggleOff = [CCMenuItemFont itemWithString:@"I'm OFF!"];
//        CCMenuItemToggle* item3 = [CCMenuItemToggle itemWithTarget:self selector:@selector(openSound:) items:toggleOn, toggleOff, nil];
        // 用菜单项生成菜单
        
//        CCMenuItemLabel *item4 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(menuItem1Touched:)];
//        item4.disabledColor = ccc3(32,32,64);
//        item4.color = ccc3(200,200,255);
        
        
        
        
        CCMenuItemFont* item1 = [CCMenuItemFont itemWithString:@"1" target:self selector:@selector(CurrentSelect:)];
        item1.tag = 1;
        CCMenuItemFont* item2 = [CCMenuItemFont itemWithString:@"2" target:self selector:@selector(CurrentSelect:)];
        item2.tag = 2;
        CCMenuItemFont* item3 = [CCMenuItemFont itemWithString:@"3" target:self selector:@selector(CurrentSelect:)];
        item3.tag = 3;
        CCMenuItemFont* item4 = [CCMenuItemFont itemWithString:@"4" target:self selector:@selector(CurrentSelect:)];
        item4.tag = 4;
        CCMenuItemFont* item5 = [CCMenuItemFont itemWithString:@"5" target:self selector:@selector(CurrentSelect:)];
        item5.tag = 5;
        CCMenuItemFont* item6 = [CCMenuItemFont itemWithString:@"6" target:self selector:@selector(CurrentSelect:)];
        item6.tag = 6;
        CCMenuItemFont* item7 = [CCMenuItemFont itemWithString:@"7" target:self selector:@selector(CurrentSelect:)];
        item7.tag = 7;
        CCMenuItemFont* item8 = [CCMenuItemFont itemWithString:@"8" target:self selector:@selector(CurrentSelect:)];
        item8.tag = 8;
        CCMenuItemFont* item9 = [CCMenuItemFont itemWithString:@"9" target:self selector:@selector(CurrentSelect:)];
        item9.tag = 9;
        CCMenuItemFont* item10 = [CCMenuItemFont itemWithString:@"10" target:self selector:@selector(CurrentSelect:)];
        item10.tag = 10;
        
        
        CCMenu* menu = [CCMenu menuWithItems:item1, item2, item3,item4,item5, item6,item7,item8,item9,item10,nil];
        menu.position = CGPointMake(200 / 2, 200 / 2);
        menu.color =  ccWHITE;
        [layerColor addChild:menu];
        // 排列对齐很重要,这样的话菜单项才不会叠加在同一个位置
        [menu alignItemsInColumns:
         [NSNumber numberWithUnsignedInt:2],
         [NSNumber numberWithUnsignedInt:2],
         [NSNumber numberWithUnsignedInt:2],
         [NSNumber numberWithUnsignedInt:2],
         [NSNumber numberWithUnsignedInt:2],
         nil
         ];
        
        
        
        
        
//        CCMenuItemFont *menuOne =[CCMenuItemFont itemWithString:@"开启声音"];
//        CCMenuItemFont *menuTwo =[CCMenuItemFont itemWithString:@"关闭声音" block:^(id sender) {    }];
//        CCMenuItemToggle *tMenu =[CCMenuItemToggle itemWithTarget:self selector:@selector(openSound:)items:menuOne,menuTwo, nil];
//        CCMenu *menu =[CCMenu menuWithItems:tMenu, nil];
//        //用菜单项生成菜单
//        menu.position =ccp(size.width/2, size.height/2);
//        //坐标
//        [menu alignItemsVerticallyWithPadding:20];
//        //排列对齐 *这个很重要，如果没有菜单将重叠在一起
//        [self addChild:menu z:0 tag:2];
    }
    return self;
}
-(void)openSound:(id)sender{
    [delegate currentSelectIndex:1];
}

-(void)CurrentSelect:(id)sender{
    CCMenuItemFont* item= sender;
    int tag = item.tag;
    [delegate currentSelectIndex:tag];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
