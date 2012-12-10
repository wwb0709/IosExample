//
//  Cell.h
//  ShuDu
//
//  Created by wangwb on 12-12-10.
//
//

#import "CCSprite.h"

@interface Cell : CCSprite
{
    BOOL isBlank;//YES：需要用户输入的 NO：提供给用户的
    int x;//宫格的坐标
    int y;
    int value;//最终要验证的值
    int userValue;//用户输入的值
    NSMutableArray *noteList;
}

@property(assign) BOOL isBlank;
@property(assign) int x;
@property(assign) int y;
@property(assign) int value;
@property(assign) int userValue;
@property(nonatomic,copy) NSMutableArray *noteList;
@end
