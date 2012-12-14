//
//  GameLayer.h
//  ShuDu
//
//  Created by wangwb on 12-12-10.
//
//
#import "cocos2d.h"
#import "Sudoku.h"
#import "Cell.h"
#import "global.h"
#import "IntroLayer.h"
#import "MenuLayer.h"
typedef enum {
    MenuButtonFinish =1,
    MenuButtonBack,
  
} GameMenuButton;
@interface GameLayer : CCLayer<CurrentSelectDelegate>
{
    Cell *cells[9][9];
    Sudoku *sudokuCreator;
    NSTimer *gameTimer;
    int x;
    int y;
}

@property (retain,nonatomic) Sudoku *sudokuCreator;
@property (retain,nonatomic) NSTimer *gameTimer;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@end
