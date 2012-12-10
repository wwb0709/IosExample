//
//  global.h
//  ShuDu
//
//  Created by wangwb on 12-12-10.
//
//

#ifndef ShuDu_global_h
#define ShuDu_global_h

enum PAGEINDEX
{
    RANK_PAGE,
    MODE_PAGE,
    GAME_PAGE
};

//游戏难度
enum GAMELEVEL
{
    LEVEL_ESAY,
    LEVEL_MID,
    LEVEL_HARD
};



//游戏模式
enum GAMEMODE
{
    MODE_TIME,
    MODE_CHALLENGE
};
extern int gGameLevel;
extern int gGameMode;

extern float gsoundVolume;
extern float gmusicVolume;

#define SQUAREWIDTH 279 //九宫图的宽高
#define CELLWIDTH 34//每个小格子的宽高

#endif
