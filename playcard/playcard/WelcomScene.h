//
//  WelcomScene.h
//  playcard
//
//  Created by wangwb on 13-6-6.
//
//

#ifndef __playcard__WelcomScene__
#define __playcard__WelcomScene__

#include <iostream>
#include "cocos2d.h"
#include "SocketClient.h"
using namespace cocos2d;
class Welcome : public CCLayer ,public NetEngine
{
    
private:
    SocketClient *cSocket;
public:

    virtual bool init();
    
    virtual void update(float dt);//更新精灵位置
    // there's no 'id' in cpp, so we recommend to return the class instance pointer
    static CCScene* scene();
    
    // a selector callback
    void StartGame(CCObject* pSender);

    CREATE_FUNC(Welcome);
    
    void InitSocket();
    virtual void returnRequest(void *content);

    
};
#endif /* defined(__playcard__WelcomScene__) */
