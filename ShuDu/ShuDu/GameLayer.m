//
//  GameLayer.m
//  ShuDu
//
//  Created by wangwb on 12-12-10.
//
//

#import "GameLayer.h"

@implementation GameLayer
@synthesize sudokuCreator,gameTimer;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer z:1];
    

	
	// return the scene
	return scene;
}
static int h,m;
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        [self setIsTouchEnabled: YES];
		// create and initialize a Label
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:[Utility getFileName:@"game"]];

        background.position = ccp(size.width/2, size.height/2);
        background.tag = 10000;
        
        // add the label as a child to this Layer
        [self addChild: background];
        
        
        CCSprite *background2= [CCSprite spriteWithFile:[Utility getFileName:@"gamebg"]];
          

        background2.position = ccp(size.width/2, 480-350/2);
        background2.tag = 10001;
        
        
        
        // add the label as a child to this Layer
        [self addChild: background2];
        
        //返回
        CCLabelTTF *back=  [CCLabelTTF labelWithString:@"back" fontName:@"MarkerFelt-Thin" fontSize:22];
       
        [back setColor:ccc3(91, 90, 51)];
        back.position = ccp(size.width-40, 20);
        back.tag = 88888;

        // add the label as a child to this Layer
        [self addChild: back];

        
        
        //开始暂停
        
        
        CCSprite* playNormalSprite1 = [CCSprite spriteWithFile:[Utility getFileName:@"gameinputselect"]];
        CCSprite* playNormalSprite2 = [CCSprite spriteWithFile:[Utility getFileName:@"gameinputselect"]];
        CCMenuItemSprite* play = [CCMenuItemSprite itemFromNormalSprite:playNormalSprite1
                                                          selectedSprite:playNormalSprite2
                                                                  target:self selector:nil];
        
        
        CCSprite* pauseNormalSprite1 = [CCSprite  spriteWithFile:[Utility getFileName:@"gameinputselect"]];
        CCSprite* pauseNormalSprite2 = [CCSprite  spriteWithFile:[Utility getFileName:@"gameinputselect"]];
        CCMenuItemSprite* pause = [CCMenuItemSprite itemFromNormalSprite:pauseNormalSprite1
                                                          selectedSprite:pauseNormalSprite2
                                                                  target:self selector:nil];
        
        CCMenuItemToggle* pauseToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(onPauseButton:) items:pause,play,nil];
        pauseToggle.anchorPoint = ccp(0.5f, 0.5f);
        pauseToggle.position = ccp(150, 50);
        [self addChild:pauseToggle ];
        
        
        [self loadData];
		

	
        
	}
	return self;
}
-(void)onPauseButton:(id)sender
{
    CCMenuItemToggle* toggle = sender;
    switch ([toggle selectedIndex]) {
        case 1:
            NSLog(@"play");
            break;
        case 0:
            NSLog(@"pause");
            break;
        default:
            break;
    }
 
}
-(void)loadData
{
    sudokuCreator = [[Sudoku alloc]init];//创建构造矩阵构造对象
    [sudokuCreator createMatrix];
    [sudokuCreator FillBlankInMatrixWithLevel:LEVEL_ESAY];
    
    for (int i=0;i<9; i++)
    {
        for (int j=0; j<9; j++)
        {

            //在此构造每一个矩阵，根据难度设置不同个数的空格

            cells[i][j] = [Cell spriteWithFile:[Utility getFileName:@"gameinputselect"] rect:(CGRect)CGRectMake(0,0,CELLWIDTH,CELLWIDTH)];
            cells[i][j].position = ccp(2+(CELLWIDTH+1)*i+1*(i/3)+CELLWIDTH/2, 480-(32+j*(CELLWIDTH+1)+(j/3)*1+CELLWIDTH/2));
            cells[i][j].x = i;
            cells[i][j].y = j;
            cells[i][j].value = [sudokuCreator GetCellWithX:i Y:j];
            cells[i][j].isBlank = [sudokuCreator isBlankCellWithX:i Y:j];
            
           
            NSString *strValue = @"";
            if ([sudokuCreator isBlankCellWithX:i Y:j] == NO) //已知的数字
            {
                cells[i][j].userValue =  cells[i][j].value;
                strValue = [NSString stringWithFormat:@"%u", [sudokuCreator GetCellWithX:i Y:j]];
            }
            else
            {
                
            }
            CCLabelTTF	 *valuelable = [CCLabelTTF labelWithString:strValue fontName:@"MarkerFelt-Thin" fontSize:22];
            [valuelable setColor:ccc3(91, 90, 51)];
            [valuelable setPosition:CGPointMake([cells[i][j] boundingBox].size.width /2, [cells[i][j] boundingBox].size.height /2)];
            valuelable.tag = 40000;
           
            [cells[i][j] addChild:valuelable];
            cells[i][j].tag = 20000+i*j+i;
        

            [self addChild:cells[i][j]];
            
            
        }
    }
    
    [sudokuCreator release];
    

    
    CCLabelTTF	 *useTime = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", @"111"] fontName:@"MarkerFelt-Thin" fontSize:22];
    [useTime setColor:ccc3(91, 90, 51)];
    [useTime setPosition:CGPointMake([self boundingBox].size.width /2, 480-16)];
    useTime.tag = 30000;
    [self addChild:useTime];
    

    
    
    h = 0;
    m = 0;
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];

}
-(void)pauseGameScene
{

}




-(void)addMenu:(CCSprite *)sprite
{
    [self setIsTouchEnabled: NO];
    MenuLayer *layer1 = [MenuLayer node];
    layer1.delegate = self;
    [self addChild:layer1 z:2 tag:99999];
    return;
//    CCMenuItemSprite *p = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"gameinputselect.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"gameinputselect.png"] target:self  selector:@selector(pauseGameScene)];

 
    CCMenuItem *p = [CCMenuItemFont itemWithString:@"Start" block:^(id sender) {
        
    }];
    p.position = CGPointMake(50.0f, 100.0f);
    p.anchorPoint = CGPointMake(0.5f, 0.5f);
    
    //[spritebatchnodereference addChild:p];
//    **//CAN I ADD p TO SPRITEBATCHNODE?**
    
    CCLabelTTF *pauseText = [CCLabelTTF labelWithString:@"II" fontName:@"Marker Felt" fontSize:20];
    pauseText.position = CGPointMake(22.0f, 28.0f);
    pauseText.anchorPoint = CGPointMake(0.5f, 0.5f);
    pauseText.color = ccRED;
    [p addChild:pauseText];
    
    //Create pause menu
    CCMenu *pauseMenu = [CCMenu menuWithItems: p, nil];
    pauseMenu.anchorPoint = CGPointMake(0.5f, 0.5f);
    pauseMenu.position = CGPointMake(50.0f, 200.0f);
//    pauseMenu.visible=TRUE;
    [self addChild:pauseMenu];
    return;
    
   	[CCMenuItemFont setFontSize:30];
	[CCMenuItemFont setFontName: @"Courier New"];
	
	
	CCMenuItem *item1 = [CCMenuItemFont itemWithString:@"Start" block:^(id sender) {
        
    }];

	CCMenuItem *item2 =[CCMenuItemFont itemWithString:@"Start1111" block:^(id sender) {
        
    }];
	CCMenuItem *item3 = [CCMenuItemFont itemWithString:@"Start33R434" block:^(id sender) {
        
    }];
	CCMenuItem *item4 = [CCMenuItemFont itemWithString:@"Start3434" block:^(id sender) {
        
    }];
	CCMenuItem *item5 = [CCMenuItemFont itemWithString:@"Start4324" block:^(id sender) {
        
    }];

	CCMenuItem *item6 =[CCMenuItemFont itemWithString:@"Start4324" block:^(id sender) {
        
    }];
	
	[item6 setContentSize:CGSizeMake(50, 50)];
    item6.anchorPoint = CGPointMake(0.5f, 0.5f);
    [item6 setPosition:ccp( 50, 50)];
 
    
	CCMenu *menu1 = [CCMenu menuWithItems: item1, item2, item3, item4, item5, item6, nil];
	[menu1 alignItemsVerticallyWithPadding:5];
    [menu1 setColor:ccBLACK];
     CCSprite *back = [CCSprite spriteWithFile:[Utility getFileName:@"gameinputselect"] rect:(CGRect)CGRectMake(0,0,50,50)];
    //[menu1 addChild:back z:-1];
    back.color = ccBLACK;
    
    float delayTime = 0.3f;
    
    for (CCMenuItemFont *each in [menu1 children])
    {
        each.scaleX = 0.0f;
        each.scaleY = 0.0f;
        CCAction *action = [CCSequence actions:
                            [CCDelayTime actionWithDuration: delayTime],
                            [CCScaleTo actionWithDuration:0.5F scale:1.0],
                            nil];
        delayTime += 0.2f;
        [each runAction: action];
    }
    [self addChild:menu1  z:1 tag:99999];
    return;
//    CGSize size = [[CCDirector sharedDirector] winSize];
//    //添加菜单
//    
//    // Default font size will be 28 points.
//    [CCMenuItemFont setFontSize:20];
//    
//    NSMutableArray *menuItemArr = [NSMutableArray array];
//    for (int i=0; i<10; i++) {
//        // Achievement Menu Item using blocks
//        CCMenuItem *item = [CCMenuItemFont itemWithString:[NSMutableString stringWithFormat:@"%d",i+1] block:^(id sender) {
//            CCMenuItem *item = sender;
//            [sprite setColor:ccGREEN];
//            CCLabelTTF	 *valuelable = (CCLabelTTF	 *)[sprite getChildByTag:40000];
//           
//            [valuelable setString:[NSString stringWithFormat:@"%d",item.tag]];
//            [self removeChildByTag:99999 cleanup:YES];
//
//        }];
//        item.tag = i+1;
//  
//        
//        CCSprite *back = [CCSprite spriteWithFile:[Utility getFileName:@"gameinputselect"] rect:(CGRect)CGRectMake(0,0,50,50)];
//        [back setAnchorPoint:ccp( 0, 0)];
//        [back setPosition:ccp( 25, 25)];
//        [back setColor:ccc3(93, 90, 55)];
//        [item addChild:back z:-1 tag:1];
//        
//        [menuItemArr addObject:item];
//    }
//
//    CCMenu *menu = [CCMenu menuWithArray:menuItemArr];
//    [menu alignItemsHorizontallyWithPadding:5];
//    [menu setColor:ccc3(91, 90, 55)];
//    [menu setPosition:ccp( size.width/2, size.height/2)];
//    
//    [menu alignItemsInColumns:
//     [NSNumber numberWithUnsignedInt:2],
//     [NSNumber numberWithUnsignedInt:2],
//     [NSNumber numberWithUnsignedInt:2],
//     [NSNumber numberWithUnsignedInt:2],
//     [NSNumber numberWithUnsignedInt:2],
//     nil
//     ];
//    [self addChild:menu  z:1 tag:99999];

}
-(void)updateTimeLabel
{

        NSMutableString *hourstr,*minstr;
        
        if (h<10)
        {
            hourstr = [NSMutableString stringWithFormat:@"0%d",h];
        }
        else
        {
            hourstr = [NSMutableString stringWithFormat:@"%d",h];
        }
        
        if (m<10)
        {
            minstr = [NSString stringWithFormat:@":0%d",m];
        }
        else
        {
            minstr = [NSString stringWithFormat:@":%d",m];
        }
        
        
        [hourstr appendString:minstr];
        

        CCLabelTTF	 *useTime = (CCLabelTTF	 *)[self getChildByTag:30000];
        [useTime setString:hourstr];
    
        m++;
        if (m == 60) {
            h++;
            m = 0;
        }
    
}


#pragma mark -
#pragma mark CCStandardTouchDelegate


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self getChildByTag:99999])
    {
        return;
    }
    
	CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
	
	for( CCSprite *sprite in [self children] ){
        if ([sprite tag] ==88888) {
            CGPoint point = sprite.position;
        
            if ( ccpDistance(point, touchPoint) < 20 ) {
                [self makeTransition:0.0];
                return;
            }
            
           
        }
        
        if( [sprite tag] < 20000 ) continue;
       
		if( CGRectContainsPoint([sprite boundingBox], touchPoint) ){
            Cell *cell =(Cell *)sprite;
            x = cell.x;
            y = cell.y;
            [self addMenu:sprite];
			return;
		}
        
	}
    
}
-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:dt scene:[IntroLayer scene] withColor:ccWHITE]];
}

- (void)currentSelectIndex:(NSInteger)index
{
    [self setIsTouchEnabled: YES];
    
    


    float delayTime = 0.3f;
    BOOL isConflict = NO;
    for (int i=0;i<9; i++)
    {
        for (int j=0; j<9; j++)
        {
            Cell *cell =cells[i][j];
            
            if (i==x||j==y) {
                
                
                if (cell.userValue == index) {
//                    [cell setColor:ccRED];
                    
                    cell.scaleX = 0.0f;
                    cell.scaleY = 0.0f;
                    CCAction *action = [CCSequence actions:
                                        [CCDelayTime actionWithDuration: delayTime],
                                        [CCScaleTo actionWithDuration:0.5F scale:1.0],
                                        nil];
                   
                    [cell runAction: action];
                    
                    isConflict = YES;
                }
            }
        }
    }
   
    
    if (cells[x][y].isBlank  == YES&&isConflict==NO)
    {
        Cell *cell =cells[x][y];
        [cell setColor:ccGREEN];
        cells[x][y].userValue =  index;
        CCLabelTTF	 *valuelable = (CCLabelTTF	 *)[cell getChildByTag:40000];
        [valuelable setString:[NSNumber numberWithInt:index].stringValue];
    }
    
    [self removeChildByTag:99999 cleanup:YES];

}
@end
