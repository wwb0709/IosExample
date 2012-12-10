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
@interface GameLayer : CCLayer
{
    Cell *cells[9][9];
    Sudoku *sudokuCreator;
    NSTimer *gameTimer;
}

@property (retain,nonatomic) Sudoku *sudokuCreator;
@property (retain,nonatomic) NSTimer *gameTimer;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@end
