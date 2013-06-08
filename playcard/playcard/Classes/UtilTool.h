//
//  UtilTool.h
//  playcard
//
//  Created by wangwb on 13-6-6.
//
//

#ifndef __playcard__UtilTool__
#define __playcard__UtilTool__

#include <iostream>
#include "cocoa/CCObject.h"
#include "cocos2d.h"
using namespace cocos2d;
class UtilTool :public CCObject
{
public:
    UtilTool(void);
    virtual ~UtilTool(void);
    virtual bool init(void);
    static UtilTool* sharedUtilTool(void);
    void moveWithBezier(CCSprite*mSprite,CCPoint startPoint ,CCPoint endPoint ,float time);
    CCSize getScreenSize();
};

#endif /* defined(__playcard__UtilTool__) */
