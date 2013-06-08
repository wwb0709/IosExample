//
//  CardSprite.cpp
//  playcard
//
//  Created by wangwb on 13-6-6.
//
//

#include "CardSprite.h"
#include "UtilTool.h"
USING_NS_CC;
CardSprite::CardSprite(void)
{
    isMoving = false;

}

CardSprite::~CardSprite(void)
{
}
CardSprite* CardSprite::createWithFrame(CCSpriteFrame *pSpriteFrame)
{
    CardSprite *sprite = new CardSprite();
    
    if (sprite&&sprite->initWithSpriteFrame(pSpriteFrame))
    {
        sprite->autorelease();
        return sprite;
    }
    
    return NULL;
}
void CardSprite::onEnter()
{

    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, 0, true);
    CCSprite::onEnter();
}

void CardSprite::onExit()
{
    CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
    CCSprite::onExit();
}

CCRect CardSprite::rect()
{

    CCSize size = getContentSize();
    CCPoint pos = getPosition();

    return CCRectMake(pos.x - size.width / 2, pos.y - size.height / 2, size.width, size.height);
}

bool CardSprite::containsTouchLocation(cocos2d::CCTouch *touch)
{
    CCPoint touchPoint = touch->getLocation();
    CCLog("Point On Node: %f, %f", touchPoint.x, touchPoint.y);
    CCLog("cPoint On Node: %f, %f", touchPoint.x, touchPoint.y);
    
    
    return CCRect::CCRectContainsPoint(rect(), touchPoint);
}

bool CardSprite::ccTouchBegan(cocos2d::CCTouch *touch, cocos2d::CCEvent *event)
{
    bool bRet = false;
    
    if (containsTouchLocation(touch))
    {
        CCLog("Touchable Sprite Began");
        CCLog("id %d",this->getTag());
        CCPoint point = this->getPosition();

        CCSize size = CCDirector::sharedDirector()->getWinSize();
        
        UtilTool::sharedUtilTool()->moveWithBezier(this,this->getPosition(),ccp(size.width/2,size.height/2),0.5);
    
        bRet = true;
    }
    
    return bRet;
}

void CardSprite::ccTouchMoved(cocos2d::CCTouch *touch, cocos2d::CCEvent *event)
{
    CCLog("Touchable Sprite Moved");
}

void CardSprite::ccTouchEnded(cocos2d::CCTouch *touch, cocos2d::CCEvent *event)
{
    CCLog("Touchable Sprite Ended");
}