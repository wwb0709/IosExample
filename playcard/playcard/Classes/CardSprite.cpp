//
//  CardSprite.cpp
//  playcard
//
//  Created by wangwb on 13-6-6.
//
//

#include "CardSprite.h"
CardSprite::CardSprite(void)
{

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
//    CCTouchDispatcher::sharedDispatcher()->addTargetedDelegate(this, 0, true);
    CCSprite::onEnter();
}

void CardSprite::onExit()
{
//    CCTouchDispatcher::sharedDispatcher()->removeDelegate(this);
    CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
    CCSprite::onExit();
}

CCRect CardSprite::rect()
{
//    CCSize size = this->getContentSize();
//    
//    return CCRectMake(-size.width / 2, -size.height / 2, size.width, size.height);
    
    CCSize size = getContentSize();
    CCPoint pos = getPosition();

    return CCRectMake(pos.x - size.width / 2, pos.y - size.height / 2, size.width, size.height);
}

bool CardSprite::containsTouchLocation(cocos2d::CCTouch *touch)
{
//    return CCRect::CCRectContainsPoint(rect(), convertTouchToNodeSpaceAR(touch));
    
    CCPoint touchPoint = touch->locationInView();
    touchPoint = CCDirector::sharedDirector()->convertToGL(touchPoint);

    return CCRect::CCRectContainsPoint(rect(), touchPoint);
    
    //    return CCRect::CCRectContainsPoint(getTextureRect(), convertTouchToNodeSpaceAR(touch));
    //    CCLog("Texture Rect: %f, %f, %f, %f", -getTextureRect().size.width / 2, -getTextureRect().size.height / 2, getTextureRect().size.width, getTextureRect().size.height);
    
    //    CCLog("Point On Node: %f, %f", convertTouchToNodeSpaceAR(touch).x, convertTouchToNodeSpaceAR(touch).y);
}

bool CardSprite::ccTouchBegan(cocos2d::CCTouch *touch, cocos2d::CCEvent *event)
{
    bool bRet = false;
    
    if (containsTouchLocation(touch))
    {
        CCLog("Touchable Sprite Began");
        CCLog("id %d",this->getTag());
        CCPoint point = this->getPosition();
        this->setPosition(ccp(point.x,point.y+5));
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