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

enum OPERATE_TYPE{

};
enum MESSAGE_TYPE{
    Login=1>>4,
    logout  
};

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
    char *itoa1(int val, char *buf, unsigned radix);
    void getMessageByType(MESSAGE_TYPE type,const char* content);
};

#endif /* defined(__playcard__UtilTool__) */
