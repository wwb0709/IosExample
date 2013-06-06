//
//  UtilTool.cpp
//  playcard
//
//  Created by wangwb on 13-6-6.
//
//

#include "UtilTool.h"
static UtilTool *utilt = NULL;
UtilTool::UtilTool(void)
{

}
UtilTool::~UtilTool(void)
{
}
bool UtilTool::init(void)
{
    
    return true;
}
UtilTool* UtilTool::sharedUtilTool(void)
{
    if (!utilt)
    {
        utilt = new UtilTool();
        utilt->init();
    }
    
    return utilt;
}

void UtilTool::moveWithBezier(CCSprite*mSprite,CCPoint startPoint ,CCPoint endPoint ,float time){
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex =endPoint.x+50;
    float ey =endPoint.y+150;
    
    int h = mSprite->getContentSize().height*0.5;
    ccBezierConfig bezier; // 创建贝塞尔曲线
    bezier.controlPoint_1 = ccp(sx, sy); // 起始点
    bezier.controlPoint_2 = ccp(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5+200); //控制点
    bezier.endPosition = ccp(endPoint.x-30, endPoint.y+h); // 结束位置
    CCBezierTo *actionMove =CCBezierTo::actionWithDuration(time, bezier);
    //    [mSprite runAction:actionMove];
    mSprite->runAction(actionMove);
}