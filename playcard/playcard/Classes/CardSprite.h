//
//  CardSprite.h
//  playcard
//
//  Created by wangwb on 13-6-6.
//
//

#ifndef __playcard__CardSprite__
#define __playcard__CardSprite__

#include <iostream>
#include "cocos2d.h"
USING_NS_CC;
class CardSprite : public CCSprite ,public CCTargetedTouchDelegate
{
public:
    
	CardSprite(void);
	virtual ~CardSprite(void);

    virtual void onEnter();
    virtual void onExit();
    
    CCRect rect();
    bool containsTouchLocation(CCTouch *touch);
    
    virtual bool ccTouchBegan(CCTouch *touch, CCEvent *event);
    virtual void ccTouchMoved(CCTouch *touch, CCEvent *event);
    virtual void ccTouchEnded(CCTouch *touch, CCEvent *event);
    
    static CardSprite* createWithFrame(CCSpriteFrame *pSpriteFrame);
    
};
#endif /* defined(__playcard__CardSprite__) */
