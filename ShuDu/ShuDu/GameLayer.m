//
//  GameLayer.m
//  ShuDu
//
//  Created by wangwb on 12-12-10.
//
//

#import "GameLayer.h"
#import "IntroLayer.h"
@implementation GameLayer
@synthesize sudokuCreator,gameTimer;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
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
        
        
        [self loadData];
		

	
        
	}
	return self;
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
//            cells[i][j] = [[Cell alloc]initWithFrame:CGRectMake(2+(CELLWIDTH+1)*i+1*(i/3),32+j*(CELLWIDTH+1)+(j/3)*1,CELLWIDTH,CELLWIDTH)];
//            CGRect rect = (CGRect)CGRectMake(2+(CELLWIDTH+1)*i+1*(i/3),32+j*(CELLWIDTH+1)+(j/3)*1,CELLWIDTH,CELLWIDTH);
            cells[i][j] = [CCSprite spriteWithFile:[Utility getFileName:@"gameinputselect"] rect:(CGRect)CGRectMake(0,0,CELLWIDTH,CELLWIDTH)];
            cells[i][j].position = ccp(2+(CELLWIDTH+1)*i+1*(i/3)+CELLWIDTH/2, 480-(32+j*(CELLWIDTH+1)+(j/3)*1+CELLWIDTH/2));
//            cells[i][j].x = i;
//            cells[i][j].y = j;
//            cells[i][j].value = [sudokuCreator GetCellWithX:i Y:j];
//            cells[i][j].isBlank = [sudokuCreator isBlankCellWithX:i Y:j];
//            [sudokuCreator GetCellWithX:i Y:j]
           
            int intvalue = -1;
            if ([sudokuCreator isBlankCellWithX:i Y:j] == NO) //已知的数字
            {
//                cells[i][j].userValue =  cells[i][j].value;
                intvalue = 0;

            }
            else
            {
                 intvalue = [sudokuCreator GetCellWithX:i Y:j];
            }
            CCLabelTTF	 *valuelable = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%u", intvalue] fontName:@"MarkerFelt-Thin" fontSize:22];
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
    
//    CCSprite *background2 = [self ];
	CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
	
	for( CCSprite *sprite in [self children] ){
        if( [sprite tag] < 20000 ) continue;
       
		if( CGRectContainsPoint([sprite boundingBox], touchPoint) ){
            [sprite setColor:ccGREEN];
            CCLabelTTF	 *valuelable = (CCLabelTTF	 *)[sprite getChildByTag:40000];
            int tag = sprite.tag-20000;
            [valuelable setString:[NSString stringWithFormat:@"%d",tag]];

			return;
		}
        
	}
    
}
-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[IntroLayer scene] withColor:ccWHITE]];
}
@end
